// Root config for the quickshell bar.
// Run with: quickshell --path /home/duhnny/projects/personal/development/local/replace-waybar
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "widgets"

ShellRoot {
    id: root

    // The bar window itself.
    PanelWindow {
        id: barWindow

        color: "transparent"
        anchors.top: true
        anchors.left: true
        anchors.right: true
        aboveWindows: false
        implicitHeight: 30

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "minibar"

        // Full-width bar across the top of the screen.
        Row {
            id: bar

            anchors.fill: parent
            spacing: 0

            Row {
                id: leftRow

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 5

                LauncherButton {}
                Workspaces {}
            }

            // Spacer pushes the right-hand widgets to the corner.
            Item {
                Layout.fillWidth: true
            }

            Row {
                id: rightRow

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 5

                Spotify {}
                Volume {}
                Brightness {}
                Network {}
                Battery {}
                Clock {}
            }
        }
    }
}
