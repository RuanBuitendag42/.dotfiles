---
name: kitty-terminal
description: "Kitty terminal configuration, kittens, custom tab bar, fonts, opacity, and session management"
---

# Kitty Terminal Configuration Reference

Comprehensive guide for Kitty terminal emulator configuration, custom tab bars, kittens, fonts, sessions, and performance tuning.

---

## Configuration Structure

| File | Purpose |
|------|---------|
| `~/.config/kitty/kitty.conf` | Main configuration |
| `~/.config/kitty/themes/catppuccin-macchiato.conf` | Theme colors |
| `~/.config/kitty/tab_bar.py` | Custom tab bar renderer (Python) |

Config is stow-managed from the dotfiles repo at `config/kitty/`.

---

## Font Configuration

### Current Setup
```conf
font_family      Maple Mono NF
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0
```

### Fallback Fonts
```conf
# Symbol/emoji fallbacks (automatically used for missing glyphs)
symbol_map U+E0A0-U+E0A3,U+E0B0-U+E0B3 JetBrains Mono NF
symbol_map U+23FB-U+23FE,U+2B58 Nerd Font Symbols
```

### Font Features (OpenType)
```conf
# Maple Mono ligatures and stylistic alternates
font_features MapleMonoNF-Regular +cv01 +ss01
font_features MapleMonoNF-Bold +cv01 +ss01
font_features MapleMonoNF-Italic +cv01 +ss01
font_features MapleMonoNF-BoldItalic +cv01 +ss01
```

Common features:
- `+liga` — standard ligatures (usually on by default)
- `+calt` — contextual alternates
- `+ss01`–`+ss20` — stylistic sets (font-specific)
- `+cv01`–`+cv99` — character variants

### Line Spacing
```conf
modify_font cell_height 122%    # Line height
modify_font baseline 0          # Vertical baseline offset
```

### Font Size Shortcuts
- `Ctrl+Shift+Equal` — increase
- `Ctrl+Shift+Minus` — decrease
- `Ctrl+Shift+Backspace` — reset

---

## Window & Layout

### Layouts
```conf
enabled_layouts tall,fat,grid,splits,stack
```

| Layout | Description |
|--------|-------------|
| `tall` | One large left, stacked right |
| `fat` | One large top, stacked bottom |
| `grid` | Equal grid |
| `splits` | Arbitrary splits (like tmux) |
| `stack` | One window full screen, others hidden |

Switch layout: `Ctrl+Shift+L`

### Window Borders & Margins
```conf
window_border_width  1pt
window_margin_width  0
window_padding_width 8
single_window_margin_width -1   # -1 = use window_margin_width
placement_strategy center
```

### Border Colors (set by theme)
```conf
active_border_color   #c6a0f6
inactive_border_color #494d64
bell_border_color     #ed8796
```

---

## Tab Bar Customization

### Built-in Styles
```conf
tab_bar_style       custom      # Use tab_bar.py for custom rendering
# Other options: fade, slant, separator, powerline, hidden
tab_bar_edge        bottom      # top or bottom
tab_bar_min_tabs    2           # Hide when < N tabs
tab_bar_align       left        # left, center, right
```

### Custom Tab Bar (tab_bar.py)

The custom Python script controls all tab rendering. Key concepts:

```python
def draw_tab(
    draw_data,       # DrawData object with colors and fonts
    screen,          # Screen object to write to
    tab,             # Tab object with title, index, is_active, etc.
    before,          # Number of cells before this tab
    max_title_length,
    index,
    is_last,
    extra_data,      # Extra data dict
):
    # Write cells to screen using screen.draw()
    pass
```

**Template variables** available in `tab_title_template`:
- `{index}` — tab number
- `{title}` — tab title
- `{num_windows}` — window count in tab
- `{layout_name}` — active layout name
- `{num_window_groups}` — window group count

**Formatting tags:**
- `{fmt.fg._c6a0f6}` — set foreground color (hex without #)
- `{fmt.bg._24273a}` — set background color
- `{fmt.bold}` — toggle bold
- `{fmt.nobold}` — unset bold
- `{fmt.italic}` — toggle italic

**Current samurai theme** uses Japanese-style brackets with Catppuccin colors.

### Tab Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+Q` | Close tab |
| `Ctrl+Shift+Right` | Next tab |
| `Ctrl+Shift+Left` | Previous tab |
| `Ctrl+Shift+.` | Move tab forward |
| `Ctrl+Shift+,` | Move tab backward |
| `Ctrl+Shift+Alt+T` | Set tab title |

---

## Kittens (Extensions)

### Built-in Kittens

**icat — Inline image display:**
```bash
kitten icat image.png              # Display image in terminal
kitten icat --clear                # Clear images
kitten icat --place 40x20@0x0     # Specific placement
```

**diff — Terminal diff viewer:**
```bash
kitten diff file1.txt file2.txt    # Diff two files
```
Supports git diffs, side-by-side, syntax highlighting.

**themes — Theme browser:**
```bash
kitten themes                      # Browse and apply themes interactively
```

**ssh — Enhanced SSH:**
```bash
kitten ssh user@host              # SSH with kitty features
```
Transfers terminfo, enables image display, clipboard sharing on remote.

**clipboard — Clipboard operations:**
```bash
echo "text" | kitten clipboard     # Copy to clipboard
kitten clipboard --get-clipboard   # Paste from clipboard
```

**unicode_input — Unicode picker:**
```bash
kitten unicode_input               # Search and insert unicode characters
```
Default shortcut: `Ctrl+Shift+U`

### Custom Kitten Development
Create a Python script in `~/.config/kitty/`:
```python
# my_kitten.py
def main(args):
    pass

def handle_result(args, answer, target_window_id, boss):
    # Process result in the main kitty process
    pass
```

Run: `kitten my_kitten.py`

---

## Opacity & Visual Effects

### Background Opacity
```conf
background_opacity 0.88
dynamic_background_opacity yes   # Allow runtime toggle
```

Toggle opacity: `Ctrl+Shift+A` then `M` (cycles through levels)

Set specific level via remote control:
```bash
kitty @ set-background-opacity 0.9
```

### Cursor
```conf
cursor_shape          beam       # block, beam, underline
cursor_blink_interval 0.5
cursor_stop_blinking_after 15
```

### URL Handling
```conf
url_style             curly      # none, straight, double, curly, dotted, dashed
detect_urls           yes
open_url_with         default
url_prefixes          file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh
show_hyperlink_targets yes
```

Click URLs with `Ctrl+Click` (default) or configure:
```conf
mouse_map ctrl+left press ungrabbed,grabbed mouse_click_url
```

---

## Session Management

### Session File Format
```
# ~/.config/kitty/sessions/dev.conf
new_tab Development
layout tall
cd ~/Developer/github/project
launch zsh
launch zsh -c 'nvim .'

new_tab Terminal
layout stack
cd ~/Developer/github/project
launch zsh

new_tab Git
layout stack
launch zsh -c 'lazygit'
```

### Launch with Session
```bash
kitty --session ~/.config/kitty/sessions/dev.conf
```

### Session Commands
| Command | Description |
|---------|-------------|
| `new_tab [title]` | Create new tab |
| `layout <name>` | Set layout for current tab |
| `cd <path>` | Set working directory |
| `launch <cmd>` | Launch a process in a window |
| `focus` | Focus this window |
| `enabled_layouts` | Set allowed layouts |
| `os_window_size` | Set window dimensions |

---

## Remote Control

Enable in config:
```conf
allow_remote_control yes
listen_on unix:/tmp/kitty-socket
```

### Remote Control Commands
```bash
# Change settings at runtime
kitty @ set-font-size 14
kitty @ set-background-opacity 0.9
kitty @ set-colors foreground=#cad3f5

# Tab/window management
kitty @ new-window --cwd ~/Developer
kitty @ close-window
kitty @ focus-tab --match title:Development
kitty @ set-tab-title "Custom Title"

# Send text to windows
kitty @ send-text --match title:Terminal "ls -la\n"

# Get window info
kitty @ ls   # JSON of all windows/tabs
```

---

## Environment Variables
```conf
env TERM_PROGRAM=kitty
env EDITOR=nvim
```

---

## Bell Configuration
```conf
enable_audio_bell    no
visual_bell_duration 0.1
visual_bell_color    #ed8796
window_alert_on_bell yes
bell_on_tab          "🔔 "
```

---

## Performance Tips

### Rendering
```conf
repaint_delay    10       # ms between repaints (lower = smoother, more CPU)
input_delay      3        # ms to wait for input before processing (lower = snappier)
sync_to_monitor  yes      # Sync to display refresh rate
```

### Scrollback
```conf
scrollback_lines          10000    # Lines in scrollback buffer
scrollback_pager          less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER
scrollback_pager_history_size 10   # MB for pager
```

### GPU Rendering
Kitty uses GPU rendering by default. On AMD RX 6800:
- Ensure Vulkan drivers are installed (`vulkan-radeon`)
- No special GPU config needed — Kitty auto-detects

### Useful Performance Settings
```conf
update_check_interval 0     # Disable update checks
confirm_os_window_close 0   # Don't confirm close
```
