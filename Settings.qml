import Caelestia.Plugins

SettingsObject {
    property int refreshSeconds: 120
    SettingMeta on refreshSeconds {
        label: "Refresh interval"
        description: "Seconds between usage polls. Claude Code is asked over the network; the others are read off disk."
        icon: "update"
        inputType: SettingMeta.SpinBox
        min: 30
        max: 900
        step: 30
    }

    property bool showClaude: true
    SettingMeta on showClaude {
        label: "Show Claude Code"
        description: "Reads the usage endpoint with the credentials Claude Code already stores."
        icon: "smart_toy"
        inputType: SettingMeta.Switch
    }

    property bool showCodex: true
    SettingMeta on showCodex {
        label: "Show Codex"
        description: "Reads the rate limits recorded in the newest Codex session log."
        icon: "terminal"
        inputType: SettingMeta.Switch
    }

    property bool showAntigravity: true
    SettingMeta on showAntigravity {
        label: "Show Antigravity"
        description: "Hidden rows still show as unavailable when Antigravity is not installed."
        icon: "rocket_launch"
        inputType: SettingMeta.Switch
    }

    property string antigravityUsageFile: ""
    SettingMeta on antigravityUsageFile {
        label: "Antigravity usage file"
        description: "Path to a JSON file holding Antigravity's limits, for an install the collector cannot find on its own."
        icon: "description"
        inputType: SettingMeta.TextField
    }
}
