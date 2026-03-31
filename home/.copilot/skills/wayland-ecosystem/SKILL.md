---
name: wayland-ecosystem
description: "Wayland protocols, XWayland compatibility, screen sharing, clipboard, and debugging"
---

# Wayland Ecosystem Reference

Complete reference for Wayland on Hyprland — protocols, XWayland, screen sharing, clipboard, environment variables, and debugging.

---

## Wayland vs X11 Key Differences

| Aspect | X11 | Wayland |
|--------|-----|---------|
| Root window | Yes (global screen access) | No (isolated clients) |
| Window decorations | Server-side | Client-side (or compositor) |
| Keyboard grab | Global (any app can grab) | No global grab (more secure) |
| Security | Apps can snoop on each other | Apps are isolated |
| Scaling | Global only | Per-output scaling |
| Screenshots | Grab whole screen directly | Requires portal/compositor cooperation |
| Clipboard | Global X selection | Protocol-based (wl-clipboard) |
| Performance | Double-buffered, tearing common | Direct rendering, no tearing by default |

---

## XWayland Compatibility

XWayland provides a compatibility layer for running X11 applications under Wayland.

### How It Works
- Hyprland auto-starts XWayland by default
- X11 apps run inside an XWayland instance
- They appear as regular windows but lack some Wayland features (per-monitor scaling, etc.)

### Checking App Protocol
```bash
# List X11 (XWayland) clients
xlsclients

# In Hyprland, check window details
hyprctl clients | grep -A5 "class:"
# xwayland: 1 means X11 app, xwayland: 0 means native Wayland
```

### Forcing Wayland on Common Apps

**Electron apps** (VS Code, Discord, Slack, etc.):
```bash
# Environment variable (set in hyprland.conf)
env = ELECTRON_OZONE_PLATFORM_HINT,auto
# Or per-app launch flag:
code --ozone-platform-hint=auto
```

**Firefox:**
```bash
env = MOZ_ENABLE_WAYLAND,1
```

**Chrome/Chromium:**
```bash
chromium --ozone-platform-hint=auto
# Or create ~/.config/chromium-flags.conf:
--ozone-platform-hint=auto
```

**Qt apps:**
```bash
env = QT_QPA_PLATFORM,wayland;xcb
```

**GTK apps:**
```bash
env = GDK_BACKEND,wayland,x11,*
```

---

## Screen Sharing

### Requirements
- `xdg-desktop-portal-hyprland` — THE portal implementation for Hyprland
- `pipewire` — required for screen capture streams
- `wireplumber` — PipeWire session manager

### Environment (must be set)
```bash
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
```

### Browser Screen Sharing
Works via WebRTC + xdg-desktop-portal. When a site requests screen share:
1. Portal presents a window/monitor picker
2. PipeWire streams the capture
3. Browser receives the stream

### OBS Studio
- Use the **PipeWire capture source** (not X11 capture)
- Install `obs-studio` and `pipewire` support is built in

### Troubleshooting Screen Sharing
```bash
# Check portal service
systemctl --user status xdg-desktop-portal-hyprland

# Restart portals
systemctl --user restart xdg-desktop-portal-hyprland
systemctl --user restart xdg-desktop-portal

# Monitor portal D-Bus activity
dbus-monitor --session | grep -i screen

# Check PipeWire
systemctl --user status pipewire
pw-cli info all
```

---

## Clipboard

### wl-clipboard

The primary clipboard tools for Wayland:

| Command | Purpose |
|---------|---------|
| `wl-copy "text"` | Copy text to clipboard |
| `wl-paste` | Paste clipboard contents |
| `wl-copy < file` | Copy file contents |
| `cmd \| wl-copy` | Pipe command output to clipboard |
| `wl-paste > file` | Paste to file |
| `wl-copy --primary` | Use primary selection (middle-click paste) |

### cliphist (Clipboard History)

Clipboard history manager — already configured in Hyprland autostart:

```bash
# Running in background (from hyprland.conf exec-once):
wl-paste --type text --watch cliphist store
wl-paste --type image --watch cliphist store
```

**Usage:**
```bash
# List clipboard history
cliphist list

# Interactive selection with wofi
cliphist list | wofi --dmenu | cliphist decode | wl-copy

# Clear history
cliphist wipe

# Delete specific entry
cliphist list | wofi --dmenu | cliphist delete
```

---

## Environment Variables (Critical)

These must be set in `hyprland.conf` for proper Wayland operation:

```conf
# Desktop identification
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Qt configuration
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_QPA_PLATFORMTHEME,qt6ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_AUTO_SCREEN_SCALE_FACTOR,1

# GTK / GDK
env = GDK_BACKEND,wayland,x11,*

# SDL (games)
env = SDL_VIDEODRIVER,wayland

# Clutter
env = CLUTTER_BACKEND,wayland

# Firefox
env = MOZ_ENABLE_WAYLAND,1

# Electron apps
env = ELECTRON_OZONE_PLATFORM_HINT,auto
```

### XDG_RUNTIME_DIR
- Should be set automatically (usually `/run/user/1000`)
- Verify: `echo $XDG_RUNTIME_DIR`
- Wayland socket lives here: `$XDG_RUNTIME_DIR/wayland-1`

---

## Debugging Wayland Issues

### Hyprland Inspection Commands

| Command | Purpose |
|---------|---------|
| `hyprctl version` | Hyprland version info |
| `hyprctl monitors` | Connected displays with details |
| `hyprctl monitors -j` | Monitors as JSON |
| `hyprctl clients` | All windows with properties |
| `hyprctl clients -j` | Windows as JSON |
| `hyprctl layers` | Layer shell surfaces (bars, overlays) |
| `hyprctl devices` | Input devices (keyboard, mouse, tablet) |
| `hyprctl binds` | Active keybindings |
| `hyprctl activewindow` | Currently focused window |
| `hyprctl workspaces` | Workspace info |

### Logging

```bash
# Hyprland logs (if running as user service)
journalctl --user -u hyprland

# Live Hyprland log
hyprctl log

# Portal logs
journalctl --user -u xdg-desktop-portal-hyprland

# PipeWire logs
journalctl --user -u pipewire
```

### Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| App runs in XWayland | Set appropriate env var (see "Forcing Wayland" above) |
| Screen sharing black screen | Restart portals, verify PipeWire |
| Clipboard not syncing | Check `wl-paste --watch` is running |
| Scaling issues | Use `monitor` config with correct scale factor |
| Cursor invisible in XWayland | Install `xorg-xcursor` and set `XCURSOR_SIZE` |
| Electron app crashes | Try `--disable-gpu-sandbox` or update Electron |

---

## Common Wayland Tools

### Screenshot & Recording
| Tool | Purpose |
|------|---------|
| `grim` | Screenshot tool (full screen or region) |
| `slurp` | Interactive area selection |
| `satty` | Screenshot annotation |
| `wf-recorder` | Screen recording |

**Screenshot workflow:**
```bash
# Capture area, annotate, copy
grim -g "$(slurp)" - | satty -f -
# Full screen capture
grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png
```

### Display Management
| Tool | Purpose |
|------|---------|
| `wlr-randr` | Output management (like xrandr) |
| `wl-mirror` | Mirror one output to another |
| `kanshi` | Auto display profile switching |

### Input Simulation
| Tool | Purpose |
|------|---------|
| `wtype` | Simulate keypresses (like xdotool) |
| `wev` | Event viewer (like xev) |
| `ydotool` | Device-level input simulation |

### Wallpaper
| Tool | Purpose |
|------|---------|
| `swww` | Animated wallpaper daemon (current setup) |
| `hyprpaper` | Hyprland's native wallpaper utility |
| `swaybg` | Simple static wallpaper |
