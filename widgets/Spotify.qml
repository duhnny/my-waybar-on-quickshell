// Spotify media widget — shows the current track and toggles play/pause on click.
// Hides entirely when no Spotify MPRIS player is present (mirrors waybar's
// custom/spotify module with exec-if "pgrep spotify").
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Item {
    id: spotify

    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    // Find the Spotify MPRIS player (by desktop entry id, like playerctl -p spotify).
    readonly property var player: {
        for (let i = 0; i < Mpris.players.values.length; i++) {
            const p = Mpris.players.values[i]
            if (p.desktopEntry && p.desktopEntry.toLowerCase().indexOf("spotify") !== -1)
                return p
        }
        return null
    }

    visible: player !== null

    function trackText() {
        if (!player)
            return ""

        const artist = player.trackArtist || ""
        const title = player.trackTitle || ""
        if (!artist && !title)
            return ""

        if (artist && title)
            return `${artist} - ${title}`
        return artist || title
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
                text: ""
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: 600
                color: "#66dc69"
            }

            Text {
                text: ""
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: 600
                color: "#66dc69"
                visible: spotify.player && spotify.player.playbackState === MprisPlaybackState.Paused
            }

            Text {
                text: spotify.trackText()
                font.family: "DM Sans"
                font.pixelSize: 13
                font.weight: 600
                color: "#66dc69"
                width: Math.min(implicitWidth, 260)
                elide: Text.ElideRight
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (!spotify.player)
                return
            if (mouse.button === Qt.RightButton) {
                spotify.player.next()
                return
            }
            spotify.player.togglePlaying()
        }
    }
}
