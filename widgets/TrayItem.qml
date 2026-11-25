// Individual system tray icon entry.
// Left-click activates, right-click opens the context menu.
// The Tray component is the pill background; this is just the icon.
// Icon resolution mirrors caelestia's Icons.getTrayIcon():
//
//   - "?path=" URLs (e.g. Spotify): extract the real file path from the URL
//   - Theme icon names: resolve via Quickshell.iconPath
//   - image://qspixmap/ URLs: not loadable, fall back to empty
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: trayItem

    required property var modelData

    implicitWidth: 24
    implicitHeight: 24

    property string resolvedIcon: {
        if (!trayItem.modelData || !trayItem.modelData.icon)
            return ""

        const icon = trayItem.modelData.icon

        // Qt-internal pixmap handles (e.g. image://qspixmap/1/1) are loadable
        // return directly
        if (icon.startsWith("image://qspixmap/"))
            return icon

        // Handle "?path=" appended to icon URLs (e.g. Spotify).
        // Extracts a real file path that IconImage can load.
        if (icon.includes("?path=")) {
            const parts = icon.split("?path=")
            const name = parts[0]
            const path = parts[1]
            const file = name.slice(name.lastIndexOf("/") + 1)
            const themed = Quickshell.iconPath(file, true)
            if (themed)
                return themed
            return Qt.resolvedUrl(path + "/" + file)
        }

        // Theme icon name — resolves to image://icon/<name>.
        return Quickshell.iconPath(icon)
    }

    IconImage {
        id: icon

        anchors.centerIn: parent
        implicitSize: 16
        source: trayItem.resolvedIcon
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (!modelData)
                return
            if (mouse.button === Qt.LeftButton)
                modelData.activate()
            else if (mouse.button === Qt.RightButton)
                modelData.secondaryActivate()
        }
    }
}
