import QtQuick
import Caelestia.Plugins
import Caelestia.Config
import M3Shapes
import qs.components
import dcqwqc.agentusage.services as Agents

Item {
    id: root

    // Passed by EntryPointLoader in Calendar.qml
    property var calendarDate: parent ? parent.calendarDate : undefined
    property bool isToday: parent ? parent.isToday : false

    // Injected by the entry point loader
    property SettingsObject settings: null

    property bool markCalendarResets: settings?.markCalendarResets ?? true

    visible: markCalendarResets && !isToday
    anchors.fill: parent

    // Calculate all agents that reset on this date
    property var activeAgentsOnDate: {
        if (!calendarDate) return [];
        let active = [];
        for (let j = 0; j < Agents.AgentUsage.agents.length; j++) {
            let ag = Agents.AgentUsage.agents[j];
            let resets = [];
            if (ag.weeklyResets) resets.push(ag.weeklyResets);
            if (ag.fiveHourResets) resets.push(ag.fiveHourResets);
            
            let matches = false;
            for (let i = 0; i < resets.length; i++) {
                let resetDate = new Date(resets[i] * 1000);
                if (resetDate.getFullYear() === calendarDate.getFullYear() &&
                    resetDate.getMonth() === calendarDate.getMonth() &&
                    resetDate.getDate() === calendarDate.getDate()) {
                    matches = true;
                    break;
                }
            }
            if (matches) active.push(ag.id);
        }
        return active;
    }

    Item {
        id: row
        anchors.fill: parent

        Repeater {
            model: Agents.AgentUsage.agents

            delegate: MaterialShape {
                required property var modelData

                property int activeIndex: root.activeAgentsOnDate.indexOf(modelData.id)
                property bool isResetDate: activeIndex !== -1

                property color markerColor: {
                    if (modelData.id === "claude") return "#E58F65"; // deep pastel orange
                    if (modelData.id === "antigravity") return "#8AB4F8"; // light blue
                    if (modelData.id === "codex") return "#666666"; // more grey than black
                    return "black";
                }

                visible: isResetDate
                implicitSize: 32
                shape: MaterialShape.Sunny
                color: markerColor
                opacity: 0.6
                clip: true
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -1
                // Only rotate if there are multiple agents, so single agents aren't weirdly rotated
                // A Sunny shape has 8 points (45 degrees each), so a 22.5 degree rotation perfectly aligns the points into the valleys!
                rotation: root.activeAgentsOnDate.length > 1 ? activeIndex * 22.5 : 0
            }
        }
    }
}
