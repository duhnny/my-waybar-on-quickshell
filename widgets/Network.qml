// Network widget — shows the connected Wi-Fi SSID with a wifi icon.
// Clicking opens nmtui (mirrors waybar's network on-click).
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking

Item {
    id: network

    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    // Find the first wifi device that has a connected network.
    readonly property var wifiDevice: {
        for (let i = 0; i < Networking.devices.values.length; i++) {
            const d = Networking.devices.values[i]
            if (d.type === DeviceType.Wifi)
                return d
        }
        return null
    }

    readonly property var connectedNetwork: {
        if (!wifiDevice)
            return null
        const nets = wifiDevice.networks.values
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected)
                return nets[i]
        }
        return null
    }

    readonly property bool connected: connectedNetwork !== null
    readonly property string ssid: connected ? connectedNetwork.name : "Disconnected"

    function icon() {
        if (!connected)
            return ""
        // Signal strength isn't exposed by the quickshell Network model,
        // so use a single wifi icon (matches waybar's format-wifi).
        return ""
    }

    Rectangle {
        id: pill

        implicitWidth: label.implicitWidth + 14
        implicitHeight: 24
        radius: 100
        color: Qt.rgba(0.196, 0.196, 0.196, 0.2)

        Row {
            id: label

            anchors.centerIn: pill
            spacing: 6

            Text {
                text: network.icon()
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: 600
                color: connected ? "#ffffff" : "#ff6b6b"
            }

            Text {
                text: network.ssid
                font.family: "DM Sans"
                font.pixelSize: 13
                font.weight: 600
                color: connected ? "#ffffff" : "#ff6b6b"
                width: Math.min(implicitWidth, 150)
                elide: Text.ElideRight
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton

        onClicked: Quickshell.execDetached(["ghostty", "-e", "nmtui"])
    }
}
