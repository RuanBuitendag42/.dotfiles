---
name: linux-ricing
description: "Linux ricing patterns, animation theory, color theory, r/unixporn inspiration, and aesthetic design"
---

# Linux Ricing Reference

The art of making your Linux desktop beautiful — color theory, animation design, typography, consistency patterns, and showcasing.

---

## What is Ricing?

Ricing is the art of customizing your Linux desktop environment for aesthetics. The term comes from the car enthusiast community (**R**ace **I**nspired **C**osmetic **E**nhancements). It's about making your setup look AND feel amazing — every pixel intentional, every animation purposeful.

---

## Core Principles

1. **Consistency** — Same color scheme, font family, and design language across ALL applications
2. **Cohesion** — Elements should feel like they belong together, not thrown together
3. **Restraint** — Less is more; don't add effects just because you can
4. **Functionality** — Beauty should enhance workflow, never hinder it

---

## Color Theory for Ricing

### Color Relationships

| Scheme | Description | Use Case |
|--------|-------------|----------|
| **Complementary** | Opposite sides of color wheel | High contrast accents |
| **Analogous** | Adjacent colors on wheel | Harmonious, subtle |
| **Monochromatic** | Shades of single hue | Elegant, minimal |
| **Triadic** | Three evenly spaced colors | Vibrant, balanced |
| **Split-Complementary** | Base + two adjacent to complement | Less tension than complementary |

### Catppuccin Macchiato Palette (Current Setup)

**Base colors:**
| Name | Hex | Role |
|------|-----|------|
| Base | `#24273a` | Main background |
| Mantle | `#1e2030` | Slightly darker background |
| Crust | `#181926` | Darkest background |
| Surface0 | `#363a4f` | Subtle backgrounds |
| Surface1 | `#494d64` | Borders, separators |
| Surface2 | `#5b6078` | Inactive elements |
| Text | `#cad3f5` | Primary text |
| Subtext1 | `#b8c0e0` | Secondary text |
| Subtext0 | `#a5adcb` | Tertiary text |
| Overlay0 | `#6e738d` | Muted text |

**Accent colors:**
| Name | Hex | Role in Setup |
|------|-----|---------------|
| **Mauve** | `#c6a0f6` | Primary accent (current) |
| Rosewater | `#f4dbd6` | Soft warm accent |
| Flamingo | `#f0c6c6` | Warm accent |
| Pink | `#f5bde6` | Bright warm accent |
| Red | `#ed8796` | Errors, destructive actions |
| Maroon | `#ee99a0` | Warnings |
| Peach | `#f5a97f` | Secondary highlights |
| Yellow | `#eed49f` | Warnings, attention |
| Green | `#a6da95` | Success, confirmations |
| Teal | `#8bd5ca` | Info, links |
| Sky | `#91d7e3` | Light info |
| Sapphire | `#7dc4e4` | Cool accent |
| Blue | `#8aadf4` | Primary blue accent |
| Lavender | `#b7bdf8` | Soft purple accent |

**Usage rules:**
- Use max 3-4 accent colors from the palette
- Primary accent (Mauve) for focused/active elements
- Use Red/Yellow/Green semantically (error/warning/success)
- Trust the Catppuccin palette — it's been carefully balanced

---

## Font Pairing

### Typography Rules

| Category | Font | Used For |
|----------|------|----------|
| **Monospace** | Maple Mono NF | Terminal, editor, code, bar |
| **Sans-serif** | Inter / Cantarell / Noto Sans | UI elements, GTK apps |
| **Nerd Fonts** | Symbols via Maple Mono NF | Icons in bar, terminal |

**Key rules:**
- Use ONE monospace font everywhere — currently **Maple Mono NF**
- Nerd Font patching gives you thousands of icons in the same font
- Font size consistency: pick sizes that look proportional across apps
- Anti-aliasing: enable subpixel rendering for crisp text

### Nerd Font Icons

Common icons used in ricing:

```
        — distro logos
  — terminal, code
       — audio, settings
    — network
  — power states
       — filesystem
      — battery
   — media
       — git
```

---

## Animation Principles

### Purpose-Driven Animation

Every animation should communicate something:
- **Window open** → element entering the stage
- **Window close** → element leaving
- **Workspace switch** → spatial navigation
- **Fade** → state change (focus/unfocus)

### Timing Guidelines

| Animation Type | Duration | Notes |
|---------------|----------|-------|
| Micro-interaction | 100-200ms | Button press, hover |
| Window open/close | 200-400ms | Should feel snappy |
| Workspace switch | 200-300ms | Quick spatial movement |
| Fade in/out | 150-300ms | Subtle state change |
| Background transition | 1-3s | Wallpaper changes can be slow |

### Easing / Bezier Curves

| Name | Bezier Values | Use Case |
|------|--------------|----------|
| **Natural** | `0.25, 0.1, 0.25, 1.0` | Default, smooth movement |
| **Snappy** | `0.4, 0.0, 0.2, 1.0` | Quick, responsive feel |
| **Bouncy** | `0.68, -0.55, 0.265, 1.55` | Playful overshoot |
| **Smooth** | `0.45, 0, 0.55, 1` | Even acceleration |
| **Ease-out** | `0, 0, 0.2, 1` | Entering elements (decelerate) |
| **Ease-in** | `0.4, 0, 1, 1` | Leaving elements (accelerate) |

**Rules:**
- Ease-out for entering elements (fast start, gentle stop)
- Ease-in for leaving elements (gentle start, fast exit)
- Don't overdo it — too many animations = distracting
- Disable animations for low-power or accessibility needs

---

## Ricing Checklist

### Must-Have Consistency

- [ ] **Color scheme** — Same palette across ALL apps
- [ ] **Fonts** — Same monospace font in terminal, bar, editor, notifications
- [ ] **Wallpaper** — Complements the color scheme
- [ ] **Waybar** — Matches overall aesthetic (colors, fonts, rounded corners)
- [ ] **Notifications (Dunst)** — Themed with same colors and fonts
- [ ] **Lock screen (Hyprlock)** — Themed consistently
- [ ] **Login screen (SDDM)** — Themed to match
- [ ] **Terminal (Kitty)** — Themed with matching opacity/blur
- [ ] **App launcher (Wofi)** — Same colors, rounded corners
- [ ] **File manager** — GTK theme applied (Catppuccin)
- [ ] **Cursor theme** — Catppuccin cursors installed
- [ ] **Icon theme** — Papirus or similar, matching palette
- [ ] **Animations** — Smooth, purposeful, not excessive
- [ ] **Fastfetch** — Clean, branded system info display
- [ ] **Borders and gaps** — Consistent sizing across components
- [ ] **Rounded corners** — Same radius everywhere

### Nice-to-Have

- [ ] Custom Waybar modules (GPU temp, now playing, etc.)
- [ ] Dynamic wallpaper rotation
- [ ] Matching VS Code theme
- [ ] Custom splash screen
- [ ] Themed GRUB/systemd-boot

---

## Inspiration Sources

### Communities
- **r/unixporn** — THE subreddit for Linux ricing showcases
- **r/hyprland** — Hyprland-specific setups
- **Catppuccin Discussions** — Official showcase channel

### Curated Galleries
- **awesome-rices** (`zemmsoares/awesome-rices`) — Curated rice gallery with screenshots
- **awesome-ricing** (`fosslife/awesome-ricing`) — Tools and techniques
- **awesome-linux-ricing** (`avtzis/awesome-linux-ricing`) — Comprehensive resource list
- **awesome-hyprland** — Hyprland plugins, tools, rices

### Search Patterns
- GitHub: `hyprland dotfiles catppuccin`
- GitHub: `hyprland rice macchiato`
- r/unixporn: `[Hyprland]` flair filter

---

## Screenshot Setup for Sharing

### Capture Workflow

```bash
# Area capture → annotate
grim -g "$(slurp)" - | satty -f -

# Full screen capture with timestamp
grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png

# Capture active window only
hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - screenshot.png
```

### Showcase Composition

For r/unixporn posts, include:
1. **Clean desktop** — wallpaper with empty bar
2. **Busy desktop** — multiple tiled windows showing apps
3. **Terminal** — fastfetch output + some colorful terminal output
4. **Details** — notification, lock screen, app launcher closeups
5. **Dotfiles link** — always share your dotfiles repo

---

## Advanced Ricing Techniques

### Rounded Corners
Apply consistent corner radius across all components:
- Hyprland: `rounding = 10` in `decoration {}`
- Waybar: `border-radius: 10px` in CSS
- Dunst: `corner_radius = 10` in dunstrc
- Kitty: Window decorations handle this via compositor
- Wofi: `border-radius: 10px` in CSS

### Gaps
Consistent spacing between windows and screen edges:
- Hyprland: `gaps_in` (between windows) and `gaps_out` (from edges)
- Matching padding in Waybar CSS

### Background Opacity + Blur
Translucent windows with background blur:
- Kitty: `background_opacity 0.85`
- Hyprland blur: `blur { enabled = true; size = 8; passes = 2 }`
- Waybar: `background: rgba(36, 39, 58, 0.85)` in CSS

### Shadow Effects
Windows cast subtle shadows for depth:
- Hyprland: `shadow { enabled = true; range = 15; render_power = 3 }`
- Shadow color should be dark and subtle

### Border Gradients
Colored borders on active windows:
```conf
general {
    col.active_border = rgba(c6a0f6ee) rgba(8aadf4ee) 45deg
    col.inactive_border = rgba(494d6466)
}
```
