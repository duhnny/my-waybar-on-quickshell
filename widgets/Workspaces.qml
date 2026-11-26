// Hyprland workspaces with per-workspace window icons.
// Mirrors waybar's hyprland/workspaces module: workspace number + app icons,
// with class-based icon rewrite rules (same mapping as the old config).
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Item {
    id: workspaces

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row

        spacing: 2

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

                    property real horizontalPadding: wsDelegate.hovered ? 10 : (wsDelegate.active ? 12 : 5)

                    spacing: 5
                    leftPadding: horizontalPadding
                    rightPadding: horizontalPadding
                    topPadding: 2
                    bottomPadding: 2
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: modelData.id + '.'
                        font.family: "DM Sans"
                        font.pixelSize: 13
                        font.weight: 600
                        color: wsDelegate.active || wsDelegate.hovered ? "#121212" : "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Repeater {
                        visible: wsDelegate.modelData.toplevels ? true : false
                        model: wsDelegate.modelData.toplevels?.values

                        delegate: Item {
                            id: wsItemDelegate

                            required property var modelData

                            implicitWidth: 20
                            implicitHeight: 20

                            anchors.verticalCenter: parent.verticalCenter

                            IconImage {
                                implicitSize: 16
                                source: Quickshell.iconPath(wsItemDelegate.modelData.lastIpcObject.class)

                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
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
