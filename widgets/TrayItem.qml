// Individual system tray icon entry.
// Left-click activates, right-click opens the context menu.
// Icon resolution mirrors caelestia's Icons.getTrayIcon(), adapted for plain
// QML Image:
//
//   - "?path=" URLs (e.g. Spotify): extract the real file path from the URL
//   - Theme icon names: resolve via Quickshell.iconPath (returns image://icon/,
//     which QML Image can load if the icon exists in the current theme)
//   - image://qspixmap/ URLs (Qt internal pixmaps): not loadable by QML Image,
//     fall back to showing the item ID as text
import QtQuick
import Quickshell
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

        // Qt-internal pixmap handles (e.g. image://qspixmap/1/1) are not
        // loadable by QML Image — skip them.
        if (icon.startsWith("image://qspixmap/"))
            return ""

        // Handle "?path=" appended to icon URLs (e.g. Spotify).
        // Extracts a real file path that QML Image can load.
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

        // Theme icon name — resolves to image://icon/<name>, loadable by
        // QML Image only if the icon exists in the current theme.
        return Quickshell.iconPath(icon)
    }

    Rectangle {
        id: bg

        width: 24
        height: 24
        radius: 100
        color: "#2a2a2a"

        Image {
            id: icon

            anchors.centerIn: parent
            source: trayItem.resolvedIcon
            fillMode: Image.PreserveAspectFit
            width: 13
            height: 13
        }

        // Fallback: show item ID if icon didn't resolve.
        Text {
            anchors.centerIn: parent
            text: trayItem.modelData ? trayItem.modelData.id : ""
            font.pixelSize: 8
            color: "#666666"
            visible: icon.source === ""
        }
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
