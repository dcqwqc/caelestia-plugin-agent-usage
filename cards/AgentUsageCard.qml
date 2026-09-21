import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.Plugins
import qs.components
import qs.services
import dcqwqc.agentusage.components
import dcqwqc.agentusage.services as Agents

// The coding agents on this machine and how much of each is left, sized to sit
// beside the CPU card in the dashboard's Performance tab.
StyledRect {
    id: root

    // Injected by the entry point loader
    property SettingsObject settings: null

    readonly property color accent: Colours.palette.m3primary

    // One accent per agent so three rows of the same shape still read apart,
    // in the same order the hero cards use them
    readonly property var accents: ({
        "claude": Colours.palette.m3primary,
        "codex": Colours.palette.m3secondary,
        "antigravity": Colours.palette.m3tertiary
    })

    readonly property var shown: (Agents.AgentUsage.agents ?? []).filter(a => {
        if (!settings)
            return true;
        if (a.id === "claude")
            return settings.showClaude;
        if (a.id === "codex")
            return settings.showCodex;
        if (a.id === "antigravity")
            return settings.showAntigravity;
        return true;
    })

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.extraLarge

    implicitWidth: Math.max(layout.implicitWidth + Tokens.padding.largeIncreased * 2, 320)
    implicitHeight: layout.implicitHeight + Tokens.padding.large * 2

    Binding {
        target: Agents.AgentUsage
        property: "interval"
        value: root.settings?.refreshSeconds ?? 120
        when: !!root.settings
    }

    Binding {
        target: Agents.AgentUsage
        property: "antigravityPool"
        value: root.settings?.antigravityPool ?? "worst"
        when: !!root.settings
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.leftMargin: Tokens.padding.largeIncreased
        anchors.rightMargin: Tokens.padding.largeIncreased
        anchors.topMargin: Tokens.padding.large
        anchors.bottomMargin: Tokens.padding.large

        spacing: Tokens.spacing.medium

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: -Tokens.padding.extraSmall
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "auto_awesome"
                fill: 1
                color: root.accent
                fontStyle: Tokens.font.icon.builders.medium.weight(Font.DemiBold).build() // DemiBold to fix fill issues
            }

            StyledText {
                text: qsTr("Agents")
                font: Tokens.font.title.medium
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: qsTr("Limits")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        Repeater {
            model: root.shown

            AgentRow {
                required property var modelData

                Layout.fillWidth: true
                Layout.fillHeight: true

                agent: modelData
                accent: root.accents[modelData.id] ?? root.accent
            }
        }

        // Nothing to lay out until the first poll lands
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.shown.length === 0

            StyledText {
                anchors.centerIn: parent
                text: Agents.AgentUsage.failed ? qsTr("No agent usage available") : qsTr("Collecting data...")
                font: Tokens.font.body.small
                color: Colours.palette.m3outline
            }
        }
    }
}
