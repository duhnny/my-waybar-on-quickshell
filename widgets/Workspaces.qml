// Hyprland workspaces with per-workspace window icons.
// Mirrors waybar's hyprland/workspaces module: workspace number + app icons,
// with class-based icon rewrite rules (same mapping as the old config).
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: workspaces

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    // Class → nerd-font icon mapping, ported from waybar's window-rewrite rules.
    function iconFor(toplevel) {
        if (!toplevel)
            return ""

        const cls = (toplevel.lastIpcObject && toplevel.lastIpcObject.class) || ""
        const title = (toplevel.title || "")

        // Ordered rewrite rules (class first, then class+title, then title-only).
        const rules = [
            [/title<.*youtube.*>/i, ""],
            [/class<.*zen.*> title<.*github.*>/i, ""],
            [/class<.*zen.*> title<.*WhatsApp.*>/i, ""],
            [/class<zen>/i, "󰺕"],
            [/class<.*ghostty.*>/i, ""],
            [/class<.*kitty.*>/i, ""],
            [/class<.*nvim.*>/i, ""],
            [/class<.*[dD]ocker.*>/i, ""],
            [/class<.*bitwarden.*>/i, ""],
            [/class<Spotify>/i, ""],
            [/class<.*nautilus.*>/i, ""],
            [/class<.*systemmonitor.*>/i, ""],
            [/class<.*resolve.*>/i, ""],
            [/class<.*freeshow.*>/i, "󰐩"],
            [/class<.*Cursor.*>/i, "󰆦"],
            [/class<.*podman.*>/i, ""],
            [/class<.*Postman.*>/i, "󰙨"],
            [/class<.*chrome.*>/i, ""],
            [/class<.*obsidian.*>/i, ""],
            [/class<.*gimp.*>/i, ""],
            [/class<.*obs.*studio.*>/i, "󰡂"],
            [/class<.*code-oss.*>/i, ""],
            [/class<.*zathura.*>/i, ""],
            [/class<.*beekeeper.*>/i, ""],
            [/class<.*anydesk.*>/i, "󰔀"],
            [/class<.*thunderbird.*>/i, ""],
            [/class<.*systemsettings.*>/i, ""],
            [/class<.*merkuro.*calendar.*>/i, "󰃭"],
            [/class<.*ONLYOFFICE.*>/i, "󰏆"],
            [/class<.*t3code.*>/i, ""],
            [/class<.*pulseaudio.*pavucontrol.*>/i, "󰜟"],
            [/class<.*audacity.*>/i, ""],
            [/title<.*youtube.*>/i, ""],
            [/title<.*whatsapp.*>/i, ""],
        ]

        for (const rule of rules) {
            const pattern = rule[0]
            const icon = rule[1]

            // Match against class and/or title depending on the pattern.
            if (pattern.test("class<" + cls + "> title<" + title + ">"))
                return icon
        }

        return ""
    }

    function workspaceIcon(ws) {
        const windows = ws.toplevels.values
        if (windows.length === 0)
            return ""

        // One icon per window (no deduplication).
        const icons = []
        for (let i = 0; i < windows.length; i++)
            icons.push(iconFor(windows[i]))
        return icons.join(" ")
    }

    Row {
        id: row

        Repeater {
            model: Hyprland.workspaces

            delegate: Item {
                id: wsDelegate

                required property HyprlandWorkspace modelData
                property bool active: modelData.active
                property bool hovered: false

                implicitWidth: wsRow.implicitWidth
                implicitHeight: wsRow.implicitHeight

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.activate()

                    hoverEnabled: true

                    onEntered: {
                        wsDelegate.hovered = true
                    }

                    onExited: {
                        wsDelegate.hovered = false
                    }
                }

                Row {
                    id: wsRow

                    property real horizontalPadding: wsDelegate.hovered ? 10 : (wsDelegate.active ? 15 : 5)

                    spacing: 5
                    leftPadding: horizontalPadding
                    rightPadding: horizontalPadding
                    topPadding: 4
                    bottomPadding: 4

                    Text {
                        text: modelData.id + '.'
                        font.family: "DM Sans"
                        font.pixelSize: 13
                        font.weight: 600
                        color: wsDelegate.active || wsDelegate.hovered ? "#121212" : "#ffffff"
                    }

                    Text {
                        text: workspaceIcon(modelData)
                        font.family: "JetBrainsMono Nerd Font Propo"
                        font.pixelSize: 13
                        font.weight: 600
                        color: wsDelegate.active || wsDelegate.hovered ? "#121212" : "#ffffff"
                    }

                    Behavior on leftPadding {
                        NumberAnimation { duration: 150 }
                    }
                    Behavior on rightPadding {
                        NumberAnimation { duration: 150 }
                    }
                }

                Rectangle {
                    id: fill

                    anchors.fill: parent
                    radius: 100
                    color: wsDelegate.active || wsDelegate.hovered ? "#e8eaed" : Qt.rgba(0.196, 0.196, 0.196, 0.2)
                    z: -1

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }
        }
    }
}
