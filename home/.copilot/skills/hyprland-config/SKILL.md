---
name: hyprland-config
description: "Hyprland keybinds, window rules, animations, plugins, pyprland, and display management patterns"
---

# Hyprland Configuration Reference

Comprehensive reference for Hyprland window manager configuration on Arch Linux with a single monitor (HDMI-A-1, 2560x1440@60Hz) and AMD Radeon RX 6800 GPU.

---

## Keybind Patterns

### Format
```
bind = MODS, KEY, dispatcher, params
```

- `MODS` — modifier keys: `SUPER`, `SHIFT`, `ALT`, `CTRL` (combine with spaces or no separator)
- `KEY` — key name (e.g., `Q`, `Return`, `space`, `F1`, `mouse:272`)
- Dispatcher — the action to perform
- Params — dispatcher-specific arguments

### Common Dispatchers

| Dispatcher | Params | Description |
|-----------|--------|-------------|
| `exec` | command | Run a shell command |
| `killactive` | — | Close focused window |
| `togglefloating` | — | Toggle floating state |
| `fullscreen` | 0/1/2 | 0=real, 1=maximize, 2=no gaps |
| `movefocus` | l/r/u/d | Move focus direction |
| `workspace` | N / +1 / -1 / name:N | Switch workspace |
| `movetoworkspace` | N | Move window to workspace |
| `movetoworkspacesilent` | N | Move without following |
| `togglesplit` | — | Toggle dwindle split direction |
| `pseudo` | — | Toggle pseudotile |
| `pin` | — | Pin floating window on top |
| `centerwindow` | — | Center floating window |
| `resizeactive` | X Y | Resize by pixels |
| `moveactive` | X Y | Move by pixels |
| `togglespecialworkspace` | name | Toggle special workspace |
| `movetoworkspacesilent` | special:name | Stash to special |

### Bind Flags
```
bind = MODS, KEY, dispatcher, params      # Standard
binde = MODS, KEY, dispatcher, params     # Repeat on hold
bindm = MODS, KEY, dispatcher, params     # Mouse bind
bindl = MODS, KEY, dispatcher, params     # Locked (works when locked)
bindr = MODS, KEY, dispatcher, params     # On release
```

### Super Key Convention
Use `SUPER` as primary modifier:
```
bind = SUPER, Q, killactive
bind = SUPER, Return, exec, kitty
bind = SUPER, E, exec, nemo
bind = SUPER, V, togglefloating
bind = SUPER, F, fullscreen, 1
bind = SUPER, P, pseudo
bind = SUPER, J, togglesplit
```

### Workspace Navigation
```
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
# ...
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
```

### Submaps (Grouped Keybinds)
```
# Enter resize mode
bind = SUPER, R, submap, resize

submap = resize
binde = , l, resizeactive, 30 0
binde = , h, resizeactive, -30 0
binde = , k, resizeactive, 0 -30
binde = , j, resizeactive, 0 30
bind = , escape, submap, reset
submap = reset
```

### Media Keys
```
bindl = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindl = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPrev, exec, playerctl previous
binde = , XF86MonBrightnessUp, exec, brightnessctl set +5%
binde = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
bind = , Print, exec, grimblast copy area
```

---

## Window Rules

### Syntax
```
windowrulev2 = RULE, CONDITION
```

### Conditions

| Condition | Example | Description |
|----------|---------|-------------|
| `class:` | `class:^(firefox)$` | Window class (regex) |
| `title:` | `title:^(Open File)$` | Window title (regex) |
| `xwayland:` | `xwayland:1` | XWayland window |
| `floating:` | `floating:1` | Floating state |
| `fullscreen:` | `fullscreen:1` | Fullscreen state |
| `pinned:` | `pinned:1` | Pinned state |
| `workspace:` | `workspace:3` | On specific workspace |

### Common Rules

| Rule | Params | Description |
|------|--------|-------------|
| `float` | — | Force floating |
| `size` | W H | Set size (pixels or %) |
| `move` | X Y | Set position |
| `center` | — | Center on screen |
| `workspace` | N | Assign to workspace |
| `opacity` | active inactive | Set transparency |
| `animation` | style | Per-window animation |
| `idleinhibit` | focus/fullscreen/always | Prevent idle |
| `nofocus` | — | Don't auto-focus |
| `noblur` | — | Disable blur |
| `noshadow` | — | Disable shadow |
| `noborder` | — | Remove border |
| `tile` | — | Force tiled |
| `stayfocused` | — | Keep focus |
| `minsize` | W H | Minimum size |
| `maxsize` | W H | Maximum size |
| `suppressevent` | events | Suppress certain events |

### Per-App Rule Examples

**Browsers:**
```
windowrulev2 = opacity 0.95 0.85, class:^(zen-browser)$
windowrulev2 = workspace 2, class:^(zen-browser)$
```

**File Managers:**
```
windowrulev2 = float, class:^(nemo)$
windowrulev2 = size 900 600, class:^(nemo)$
windowrulev2 = center, class:^(nemo)$
windowrulev2 = float, class:^(thunar)$
```

**Communication:**
```
windowrulev2 = workspace 3, class:^(vesktop)$
windowrulev2 = workspace 3, class:^(betterbird)$
windowrulev2 = workspace 3, class:^(com.rtosta.zapzap)$
```

**Gaming:**
```
windowrulev2 = workspace 5, class:^(steam)$
windowrulev2 = float, class:^(steam)$, title:^(Friends List)$
windowrulev2 = workspace 5, class:^(lutris)$
windowrulev2 = fullscreen, class:^(gamescope)$
windowrulev2 = idleinhibit always, class:^(steam_app_.*)$
```

**Development:**
```
windowrulev2 = workspace 1, class:^(code-url-handler)$
windowrulev2 = workspace 1, class:^(kitty)$
```

**Media / Settings:**
```
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, class:^(easyeffects)$
windowrulev2 = float, title:^(Picture-in-Picture)$
windowrulev2 = pin, title:^(Picture-in-Picture)$
windowrulev2 = size 480 270, title:^(Picture-in-Picture)$
```

---

## Animations

### Format
```
animation = NAME, ON/OFF, SPEED, CURVE, [STYLE]
```

- `SPEED` — duration in ds (deciseconds), so 5 = 500ms
- `CURVE` — bezier curve name
- `STYLE` — optional style variant

### Available Animations

| Name | Styles | Description |
|------|--------|-------------|
| `windows` | — | All window animations |
| `windowsIn` | — | Window open |
| `windowsOut` | — | Window close |
| `fade` | — | All fades |
| `fadeIn` | — | Fade in |
| `fadeOut` | — | Fade out |
| `border` | — | Border color change |
| `borderangle` | once/loop | Border gradient rotation |
| `workspaces` | slide/slidevert/fade | Workspace switch |
| `specialWorkspace` | slide/slidevert/fade | Special workspace toggle |
| `layers` | — | Layer animations |

### Bezier Curves
```
bezier = ease, 0.25, 0.1, 0.25, 1.0
bezier = overshot, 0.05, 0.9, 0.1, 1.1
bezier = smooth, 0.37, 0.0, 0.63, 1.0
bezier = snappy, 0.4, 0.0, 0.2, 1.0
bezier = bounce, 0.68, -0.55, 0.265, 1.55
bezier = easeOut, 0.0, 0.0, 0.58, 1.0
bezier = easeInOut, 0.42, 0.0, 0.58, 1.0
```

### Example Config
```
animations {
    enabled = yes
    bezier = overshot, 0.05, 0.9, 0.1, 1.1
    bezier = smooth, 0.37, 0.0, 0.63, 1.0

    animation = windows, 1, 5, overshot, popin 80%
    animation = windowsOut, 1, 5, smooth, slide
    animation = fade, 1, 4, smooth
    animation = border, 1, 10, smooth
    animation = borderangle, 1, 30, smooth, loop
    animation = workspaces, 1, 5, overshot, slide
    animation = specialWorkspace, 1, 4, smooth, slidevert
}
```

---

## Layouts

### Dwindle (Default)
```
dwindle {
    pseudotile = yes       # Pseudo-tiling (window chooses size)
    preserve_split = yes   # Keep split direction on resize
    force_split = 2        # 0=follows mouse, 1=left, 2=right
    smart_split = false    # Split based on cursor position
    no_gaps_when_only = 1  # Remove gaps for single window
}
```

### Master
```
master {
    new_is_master = false          # New windows go to stack
    orientation = left             # left, right, top, bottom, center
    always_center_master = false
    mfact = 0.55                   # Master area ratio
}
```

**When to use which:**
- **Dwindle** — general use, automatic tiling, most common
- **Master** — when you have one primary window (e.g., editor) and several secondary

---

## Plugins

### hyprpm (Plugin Manager)
```bash
hyprpm update                    # Update plugin repos
hyprpm add <repo-url>           # Add plugin source
hyprpm enable <plugin-name>     # Enable plugin
hyprpm disable <plugin-name>    # Disable plugin
hyprpm list                     # List installed
```

### Notable Plugins

**hy3** — i3-like manual tiling with groups, tabs, stacks:
```
plugin {
    hy3 {
        tabs {
            height = 5
            padding = 8
            render_text = false
        }
    }
}
bind = SUPER, G, hy3:makegroup, tab
bind = SUPER, V, hy3:changegroup, toggletab
```

**hyprscroller** — scrolling/column layout like PaperWM/niri:
```
plugin {
    scroller {
        column_default_width = onehalf
    }
}
```

**hyprspace** — workspace overview (KDE/macOS-like):
```
bind = SUPER, Tab, overview:toggle
```

**dynamic-cursors** — realistic cursor physics, shake to find:
```
plugin {
    dynamic-cursors {
        enabled = true
        shake {
            enabled = true
            threshold = 4.0
        }
    }
}
```

**hyprfocus** — flash on focus change:
```
plugin {
    hyprfocus {
        enabled = yes
        animate_floating = yes
        focus_animation = shrink
    }
}
```

**hyprland-easymotion** — easymotion window navigation:
```
bind = SUPER, slash, easymotion, action:focus
```

---

## Pyprland

### Configuration
Config file: `~/.config/hypr/pyprland.toml`

Start pyprland in hyprland.conf:
```
exec-once = pypr
```

### Key Plugins

**scratchpads — Dropdown terminals/apps:**
```toml
[scratchpads.term]
command = "kitty --class kitty-dropterm"
animation = "fromTop"
size = "75% 60%"
class = "kitty-dropterm"
lazy = true

[scratchpads.volume]
command = "pavucontrol"
animation = "fromRight"
size = "40% 90%"
class = "pavucontrol"
lazy = true
```
```
bind = SUPER, grave, exec, pypr toggle term
bind = SUPER, A, exec, pypr toggle volume
```

**expose — Show all windows on focused workspace:**
```
bind = SUPER, Tab, exec, pypr expose
```

**layout_center — Maximized with margins:**
```toml
[layout_center]
margin = 200
```
```
bind = SUPER, C, exec, pypr layout_center toggle
```

**lost_windows — Recover off-screen windows:**
```
bind = SUPER SHIFT, W, exec, pypr lost_windows
```

**magnify — Zoom toggle:**
```
bind = SUPER, Z, exec, pypr zoom
```

**toggle_special — Stash windows:**
```
bind = SUPER, S, exec, pypr toggle_special stash
bind = SUPER SHIFT, S, exec, pypr toggle_special stash
```

**monitors — Flexible monitor placement:**
```toml
[monitors]
startup_relayout = true

[monitors.placement]
"HDMI-A-1".topOf = ""
```

---

## Display Management

### Monitor Config
```
monitor = NAME, RESOLUTION@RATE, POSITION, SCALE
```

**Single monitor (current setup):**
```
monitor = HDMI-A-1, 2560x1440@60, 0x0, 1
```

**Resolution switching patterns:**
```
# 1080p
monitor = HDMI-A-1, 1920x1080@60, 0x0, 1
# 1440p (current)
monitor = HDMI-A-1, 2560x1440@60, 0x0, 1
# 4K native
monitor = HDMI-A-1, 3840x2160@60, 0x0, 1
# 4K scaled to 1440p effective
monitor = HDMI-A-1, 3840x2160@60, 0x0, 1.5
```

### Transform Options (Rotation)
```
# 0=none, 1=90°, 2=180°, 3=270°, 4=flipped, 5=flipped+90°, etc.
monitor = HDMI-A-1, 2560x1440@60, 0x0, 1, transform, 0
```

### Environment Variables
```
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = GDK_BACKEND,wayland,x11
env = MOZ_ENABLE_WAYLAND,1
env = XCURSOR_SIZE,24
```

---

## Input Configuration

### Keyboard
```
input {
    kb_layout = us
    kb_variant =
    kb_options = caps:escape   # Caps Lock as Escape
    repeat_rate = 50
    repeat_delay = 300
    numlock_by_default = true
}
```

### Mouse
```
input {
    sensitivity = 0
    accel_profile = flat
    follow_mouse = 1          # 0=click, 1=loose, 2=strict, 3=always
    natural_scroll = false
}
```

### Touchpad
```
input {
    touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = true
        disable_while_typing = true
    }
}
```

### Per-Device Config
```
device {
    name = epic-mouse-v1
    sensitivity = -0.5
}
```
