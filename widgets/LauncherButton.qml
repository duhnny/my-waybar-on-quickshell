// Arch-glyph launcher button — launches rofi drun on click.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: launcher

    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    property bool hovered: mouseArea.containsMouse

    Rectangle {
        id: pill

        // implicitWidth: label.implicitWidth + 16
        implicitWidth: label.implicitWidth + 16
        implicitHeight: 24
        radius: 100
        color: launcher.hovered ? "#e8eaed" : Qt.rgba(0.196, 0.196, 0.196, 0.2)

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    Text {
        id: label

        anchors.centerIn: pill
        text: ""
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 13
        font.weight: 600
        color: launcher.hovered ? "#121212" : "#ffffff"
        padding: 18

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Quickshell.execDetached(["rofi", "-show", "drun", "-show-icons", "-sort"])
    }
}
