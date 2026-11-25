// Brightness widget — reads the backlight via brightnessctl and slides a
// horizontal slider in from the right on hover (like waybar's group/brightness).
// quickshell has no brightness service, so this shells out to brightnessctl.
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: brightness

    implicitWidth: group.implicitWidth
    implicitHeight: group.implicitHeight

    // Current brightness as a 0–100 percentage.
    property int percent: 0

    // Maximum brightness, read from /sys/class/backlight/<device>/max_brightness.
    property int max: 100

    // Device name (defaults to intel_backlight, matching the current setup).
    property string device: "intel_backlight"

    function icon() {
        const p = percent
        if (p < 25)
            return "󰃞"
        if (p < 50)
            return "󰃟"
        if (p < 75)
            return "󰃠"
        return "󰃡"
    }

    // Refresh the current brightness.
    function refresh() {
        brightnessProcess.running = false
        brightnessProcess.running = true
    }

    // Set brightness to a 0–100 percentage.
    function setPercent(p) {
        p = Math.max(0, Math.min(100, Math.round(p)))
        percent = p
        setProcess.command = ["brightnessctl", "-d", device, "s", p + "%"]
        setProcess.running = true
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            // Cycle brightness 25/50/75/100 on click (mirrors XF86MonBrightnessUp).
            const next = [25, 50, 75, 100]
            let i = 0
            while (i < next.length && next[i] <= brightness.percent)
                i++
            brightness.setPercent(i < next.length ? next[i] : 25)
        }

        Row {
            id: group

            anchors.centerIn: parent
            spacing: 5

            Rectangle {
                id: mainPill

                width: label.implicitWidth + 14
                height: 24
                radius: 100
                color: Qt.rgba(0.196, 0.196, 0.196, 0.2)

                Row {
                    id: label

                    anchors.centerIn: mainPill
                    spacing: 5

                    Text {
                        text: brightness.percent + "%"
                        font.family: "DM Sans"
                        font.pixelSize: 13
                        font.weight: 600
                        color: "#ffffff"
                    }

                    Text {
                        text: brightness.icon()
                        font.family: "JetBrainsMono Nerd Font Propo"
                        font.pixelSize: 13
                        font.weight: 600
                        color: "#ffffff"
                    }
                }
            }

            Rectangle {
                id: sliderPill

                width: hoverArea.containsMouse ? 118 : 0
                height: 24
                radius: 100
                color: Qt.rgba(0.196, 0.196, 0.196, 0.2)
                clip: true

                Behavior on width {
                    NumberAnimation { duration: 200 }
                }

                Item {
                    anchors.fill: parent

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 8

                        Item { width: 8; height: 1; }

                        Slider {
                            id: slider

                            width: 100
                            height: 24
                            from: 0
                            to: 100
                            value: brightness.percent

                            onValueChanged: brightness.setPercent(value)
                        }
                    }
                }
            }
        }
    }

    // Read current brightness.
    Process {
        id: brightnessProcess

        command: ["brightnessctl", "get", device]
        running: false

        stdout: StdioCollector {
            id: brightnessStdout

            onStreamFinished: {
                const v = parseInt(text.trim(), 10)
                if (!isNaN(v) && v > 0) {
                    const m = parseInt(brightnessMax.text.trim(), 10) || 100
                    brightness.max = m
                    brightness.percent = Math.round(v / m * 100)
                }
            }
        }
    }

    // Read max brightness.
    Process {
        id: brightnessMaxProcess

        command: ["brightnessctl", "max", device]
        running: true

        stdout: StdioCollector {
            id: brightnessMax

            onStreamFinished: {
                const m = parseInt(text.trim(), 10)
                if (m > 0)
                    brightness.max = m
            }
        }
    }

    // Apply a new brightness value.
    Process {
        id: setProcess

        command: []
        running: false
    }

    // Poll brightness on a timer (mirrors waybar's interval polling).
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: brightness.refresh()
    }
}
