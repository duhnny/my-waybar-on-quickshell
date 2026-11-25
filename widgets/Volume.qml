// Volume widget — shows the active Pipewire sink level and slides a
// horizontal volume slider in from the right on hover (like waybar's
// group/volume drawer).
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: volume

    implicitWidth: group.implicitWidth
    implicitHeight: group.implicitHeight

    readonly property var sink: Pipewire.defaultAudioSink

    // Direct QML bindings (mirrors caelestia's Audio.qml pattern).
    property real audioVolume: sink?.audio?.volume ?? 0
    property bool audioMuted: sink?.audio?.muted ?? false

    function volumePercent() {
        return Math.round(audioVolume * 100)
    }

    function icon() {
        if (!sink?.ready || !sink?.audio)
            return ""
        if (audioMuted)
            return ""
        const v = volumePercent()
        if (v === 0)
            return ""
        if (v < 33)
            return ""
        if (v < 66)
            return ""
        return ""
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: (mouse) => {
            if (!sink?.ready || !sink?.audio)
                return
            // Left-click toggles mute (mirrors waybar's pulseaudio on-click).
            if (mouse.button === Qt.LeftButton)
                sink.audio.muted = !sink.audio.muted
        }

        Row {
            id: group

            anchors.centerIn: parent
            spacing: 5

            // Main pill: icon + percentage.
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
                        text: volume.volumePercent() + "%"
                        font.family: "DM Sans"
                        font.pixelSize: 13
                        font.weight: 600
                        color: "#ffffff"
                    }

                    Text {
                        text: volume.icon()
                        font.family: "JetBrainsMono Nerd Font Propo"
                        font.pixelSize: 13
                        font.weight: 600
                        color: "#ffffff"
                    }

                }
            }

            // Slider pill, hidden until hover.
            Rectangle {
                id: sliderPill

                width: hoverArea.containsMouse ? 118 : 0
                height: 24
                radius: 100
                color: Qt.rgba(0.196, 0.196, 0.196, 0.2)
                clip: true

                Behavior on width {
                    NumberAnimation {
                        duration: 250
                        easing: Easing.InOutQuad
                    }
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
                            value: volume.volumePercent()

                            onValueChanged: {
                                if (sink?.ready && sink?.audio) {
                                    sink.audio.muted = false
                                    sink.audio.volume = value / 100
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    PwObjectTracker {
        objects: [volume.sink]
    }
}
