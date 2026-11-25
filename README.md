# My Waybar in Quickshell

A [Quickshell](https://quickshell.github.io/) config that replaces **waybar** for Hyprland, replicating the same bar layout:

- **Launcher button** (Arch glyph, opens rofi drun on click)
- **Workspaces** with per-app nerdfont icons — one icon per window (no deduplication)
- **Spotify** MPRIS widget (click play/pause, right-click next)
- **Volume** widget with hover slider
- **Brightness** widget with hover slider (via `brightnessctl`)
- **Network** widget (Wi-Fi SSID, click opens `ghostty -e nmtui`)
- **Battery** widget (percentage + charging state, warning/critical blinking)
- **Clock** (HH:MM, right-click toggles date)
- **System tray** (StatusNotifierItem / SNI icons)

Launcher + workspaces sit on the left; all other widgets are pushed to the right corner via a spacer.

---

## Dependencies

- `quickshell` (0.3.2, Arch package)
- `playerctl` (Spotify MPRIS control)
- `brightnessctl` (brightness control)
- A nerd font (e.g. JetBrainsMono Nerd Font Propo, DM Sans)

---

## Install

Clone this repo into `~/.config/quickshell/`:

```bash
git clone <this-repo> ~/.config/quickshell
```

Or copy `shell.qml` and the `widgets/` directory into `~/.config/quickshell/`.

Then add to your Hyprland config (e.g. `hyprland.conf`):

```ini
exec-once = quickshell
```

Quickshell will load `shell.qml` from `~/.config/quickshell/` by default.

To test without installing:

```bash
quickshell --path /path/to/this/repo
```

---

## Widgets

| Widget | File | Notes |
|--------|------|-------|
| Launcher | `widgets/LauncherButton.qml` | Arch glyph, rofi drun on click |
| Workspaces | `widgets/Workspaces.qml` | Hyprland workspaces, one icon per window |
| Spotify | `widgets/Spotify.qml` | MPRIS, play/pause toggle, right-click next |
| Volume | `widgets/Volume.qml` | Pipewire sink, hover slider |
| Brightness | `widgets/Brightness.qml` | `brightnessctl` polling, hover slider |
| Network | `widgets/Network.qml` | Wi-Fi SSID, `ghostty -e nmtui` on click |
| Battery | `widgets/Battery.qml` | UPower, percentage + charging state |
| Clock | `widgets/Clock.qml` | HH:MM, right-click toggles date |
| Tray | `widgets/Tray.qml` | StatusNotifierItem icons, single pill |

---

## Notes

- Do not delete `~/.config/waybar/` — keep it as a fallback until you're happy with the switch.
- The tray shows icons for apps that register a StatusNotifierItem via D-Bus (e.g. `nm-applet`, Spotify).
