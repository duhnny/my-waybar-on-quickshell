// Battery widget — shows charge percentage and charging state, with
// warning/critical blinking like waybar's battery module.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Item {
    id: battery

    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    readonly property var device: UPower.displayDevice
    readonly property double percent: device ? device.percentage * 100 : 0
    readonly property bool charging: device ? (device.state === UPowerDeviceState.Charging
        || device.state === UPowerDeviceState.FullyCharged
        || device.state === UPowerDeviceState.PendingCharge) : false
    readonly property bool onBattery: UPower.onBattery
    readonly property bool warning: percent <= 30 && !charging
    readonly property bool critical: percent <= 15 && !charging

    function icon() {
        if (!device)
            return ""
        const p = percent
        if (p <= 15)
            return ""
        if (p <= 40)
            return ""
        if (p <= 60)
            return ""
        if (p <= 80)
            return ""
        return ""
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
            spacing: 5

            Text {
                text: Math.round(battery.percent) + '%'
                font.family: "DM Sans"
                font.pixelSize: 13
                font.weight: 600
                color: battery.critical ? "#ffffff" : "#ffffff"
            }

            Text {
                text: battery.icon()
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: 600
                color: battery.critical ? "#ffffff" : "#ffffff"
            }

            Text {
                text: "󱐋"
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: 600
                color: battery.critical ? "#ffffff" : "#ffffff"
                visible: charging
            }
        }

        // Blink the whole pill red on warning/critical while discharging.
        SequentialAnimation {
            id: blink

            running: battery.warning || battery.critical
            loops: Animation.Infinite

            ColorAnimation {
                target: pill
                property: "color"
                to: "#ffffff"
                duration: battery.critical ? 300 : 500
            }
            ColorAnimation {
                target: pill
                property: "color"
                from: "#ffffff"
                to: Qt.rgba(0.196, 0.196, 0.196, 0.2)
                duration: battery.critical ? 300 : 500
            }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
