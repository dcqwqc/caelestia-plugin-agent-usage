import QtQuick
import QtQuick.Layouts
import M3Shapes
import Caelestia.Config
import qs.components
import qs.services
import dcqwqc.agentusage.components

// One agent: its mark in a blob that swells with how much of the agent has
// been spent, then the two windows it is billed against.
RowLayout {
    id: root

    required property var agent
    required property color accent

    readonly property bool available: agent?.available ?? false
    readonly property real fiveHour: available ? (agent.fiveHour ?? -1) : -1
    readonly property real weekly: available ? (agent.weekly ?? -1) : -1
    readonly property real peak: Math.max(fiveHour, weekly)
    readonly property color colour: available ? accent : Colours.palette.m3onSurfaceVariant

    // The soonest of the two windows to come back, as a human interval
    readonly property string resetText: {
        if (!available)
            return "";

        const now = Date.now() / 1000;
        const times = [agent.fiveHourResets ?? 0, agent.weeklyResets ?? 0].filter(t => t > now);
        if (times.length === 0)
            return agent.stale ? qsTr("stale") : "";

        let mins = Math.round((Math.min(...times) - now) / 60);
        if (mins < 60)
            return qsTr("%1m").arg(mins);

        const hours = Math.floor(mins / 60);
        mins %= 60;
        if (hours < 24)
            return mins > 0 ? qsTr("%1h %2m").arg(hours).arg(mins) : qsTr("%1h").arg(hours);

        return qsTr("%1d %2h").arg(Math.floor(hours / 24)).arg(hours % 24);
    }

    spacing: Tokens.spacing.medium

    MaterialShape {
        Layout.alignment: Qt.AlignVCenter

        implicitSize: logo.implicitHeight + Tokens.padding.large
        color: root.available ? Colours.palette.m3secondaryContainer : Colours.layer(Colours.palette.m3surfaceContainerHighest, 2)
        opacity: root.available ? 1 : 0.7

        shape: {
            if (root.peak >= 0.8)
                return MaterialShape.SoftBurst;
            if (root.peak >= 0.4)
                return MaterialShape.Sunny;
            return MaterialShape.Cookie4Sided;
        }

        Behavior on color {
            CAnim {}
        }

        AgentLogo {
            id: logo

            anchors.centerIn: parent
            agent: root.agent?.id ?? ""
            colour: root.colour
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        spacing: Tokens.spacing.small

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            StyledText {
                text: root.agent?.name ?? ""
                font: Tokens.font.title.small
                color: root.colour
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                visible: text.length > 0
                text: root.available ? root.resetText : (root.agent?.detail ?? "")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
                elide: Text.ElideRight
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.large
            visible: root.available

            AgentGauge {
                Layout.fillWidth: true
                label: qsTr("5H")
                value: root.fiveHour
                accent: root.accent
            }

            AgentGauge {
                Layout.fillWidth: true
                label: qsTr("WEEK")
                value: root.weekly
                accent: root.accent
            }
        }

        // Keeps an unavailable agent the same height as an available one, so
        // the three rows stay on a grid however many are signed in
        Item {
            Layout.fillWidth: true
            visible: !root.available
            implicitHeight: Tokens.padding.small
        }
    }
}
