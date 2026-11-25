// System tray widget — shows StatusNotifierItem icons (SNI / D-Bus system tray).
// Mirrors caelestia's Tray.qml pattern: Repeater over SystemTray.items,
// one TrayItem delegate per tray entry.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: tray

    implicitWidth: row.implicitWidth
    implicitHeight: 30

    Row {
        id: row

        spacing: 5

        Repeater {
            model: SystemTray.items.values

            delegate: TrayItem { }
        }
    }
}
