// Digital clock — HH:MM, updating every second (mirrors waybar's clock module).
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: clock

    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    SystemClock {
        id: systemClock
        enabled: true
        precision: SystemClock.Seconds
    }

    property bool showDate: false

    function pad(n) {
        return n < 10 ? "0" + n : "" + n
    }

    function timeText() {
        return pad(systemClock.hours) + ":" + pad(systemClock.minutes)
    }

    function dateText() {
        const d = systemClock.date
        // QDateTime → Qt.formatDateTime with a short date format.
        return Qt.formatDateTime(d, "yyyy-MM-dd")
    }

    Rectangle {
        id: pill

        implicitWidth: label.implicitWidth + 14
        implicitHeight: 24
        radius: 100
        color: Qt.rgba(0.196, 0.196, 0.196, 0.2)

        Text {
            id: label

            anchors.centerIn: pill
            font.family: "DM Sans"
            font.pixelSize: 13
            font.weight: 600
            color: "#ffffff"
            text: clock.showDate ? clock.dateText() : clock.timeText()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton)
                clock.showDate = !clock.showDate
        }
    }
}
