// System tray widget — shows StatusNotifierItem icons (SNI / D-Bus system tray).
// Mirrors caelestia's Tray.qml pattern: Repeater over SystemTray.items,
// one TrayItem delegate per tray entry. The Tray itself is the pill background;
// items are spaced inside it.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: tray

    color: Qt.rgba(0.196, 0.196, 0.196, 0.2)
    radius: 100
    implicitHeight: 24

    Row {
        id: row

        anchors.centerIn: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 3

        Repeater {
            model: SystemTray.items.values

            delegate: TrayItem { }
        }
    }

    implicitWidth: SystemTray.items.values.length > 0
        ? row.implicitWidth + 8
        : 0

    visible: SystemTray.items.values.length > 0
}
