---
name: tmux-workflow
description: "Tmux TPM plugins, catppuccin theme, custom modules, keybinds, and session management"
---

# Tmux Workflow Reference

Comprehensive guide for tmux configuration, TPM plugin management, Catppuccin theming, custom modules, and session workflows.

---

## Current Setup

| Setting | Value |
|---------|-------|
| Prefix | `C-x` (Ctrl+x) |
| Plugin Manager | TPM (auto-installed) |
| Plugin Dir | `~/.config/tmux/plugins/` |
| Config | `~/.config/tmux/tmux.conf` |
| Custom Modules | `~/.config/tmux/custom_modules/` |
| True Color | Enabled (`tmux-256color`) |

---

## TPM Plugin Management

### Installation
TPM auto-installs on first launch (configured in tmux.conf).

### Plugin Lifecycle
```tmux
# Add plugin to tmux.conf
set -g @plugin 'author/plugin-name'
```

| Action | Shortcut |
|--------|----------|
| Install plugins | `prefix + I` |
| Update plugins | `prefix + U` |
| Remove unlinked | `prefix + Alt + u` |

### Adding a New Plugin
1. Add `set -g @plugin 'author/plugin'` to tmux.conf
2. Press `prefix + I` (Capital I) to install
3. Plugin is cloned to `~/.config/tmux/plugins/`

### Removing a Plugin
1. Delete/comment the `set -g @plugin` line in tmux.conf
2. Press `prefix + Alt + u` to clean up

---

## Current Plugins

| Plugin | Description |
|--------|-------------|
| `tmux-plugins/tpm` | Plugin manager |
| `tmux-plugins/tmux-sensible` | Sensible defaults (reattach, history, etc.) |
| `christoomey/vim-tmux-navigator` | Seamless Vim/tmux pane navigation (`Ctrl+h/j/k/l`) |
| `tmux-plugins/tmux-yank` | System clipboard integration |
| `sainnhe/tmux-fzf` | fzf integration for sessions, windows, panes |
| `alexwforsythe/tmux-which-key` | Discoverable keybinds (`prefix + Space`) |
| `catppuccin/tmux` | Catppuccin theme |
| `joshmedeski/tmux-nerd-font-window-name` | Icon-based window names |

---

## Catppuccin Theme Configuration

### Basic Setup
```tmux
set -g @catppuccin_flavor 'macchiato'
set -g @catppuccin_window_status_style 'rounded'
```

### Window Styling
```tmux
set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_default_text " #W"
set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_current_text " #W"
set -g @catppuccin_window_current_color "#{@thm_mauve}"
```

### Status Bar
```tmux
set -g @catppuccin_status_left_separator "█"
set -g @catppuccin_status_right_separator "█"
set -g @catppuccin_status_modules_left "session"
set -g @catppuccin_status_modules_right "cpu memory date_time"
```

### Pane Borders
```tmux
set -g @catppuccin_pane_border_style "fg=#{@thm_surface1}"
set -g @catppuccin_pane_active_border_style "fg=#{@thm_mauve}"
```

### Date/Time Format
```tmux
set -g @catppuccin_date_time_text "%H:%M"
```

### Theme Color Variables
Available via `#{@thm_*}`:
```
#{@thm_rosewater}  #{@thm_flamingo}  #{@thm_pink}
#{@thm_mauve}      #{@thm_red}       #{@thm_maroon}
#{@thm_peach}      #{@thm_yellow}    #{@thm_green}
#{@thm_teal}       #{@thm_sky}       #{@thm_sapphire}
#{@thm_blue}       #{@thm_lavender}
#{@thm_text}       #{@thm_subtext1}  #{@thm_subtext0}
#{@thm_overlay2}   #{@thm_overlay1}  #{@thm_overlay0}
#{@thm_surface2}   #{@thm_surface1}  #{@thm_surface0}
#{@thm_base}       #{@thm_mantle}    #{@thm_crust}
```

---

## Custom Module Development

### Module Location
Custom modules live in `config/tmux/custom_modules/`:
- `ctp_cpu.conf` — CPU usage display
- `ctp_memory.conf` — Memory usage display
- `primary_ip.conf` — Primary IP address display

### Module Format
Modules are sourced tmux config files containing format strings:

```tmux
# Example: custom_modules/ctp_cpu.conf
set -g @catppuccin_cpu_icon " "
set -g @catppuccin_cpu_color "#{@thm_green}"
set -g @catppuccin_cpu_text "#(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')%"
```

### Dynamic Content with `#()`
Use `#()` to run shell commands in status bar:
```tmux
# Run command every status-interval seconds
set -g status-right "#(whoami)@#(hostname)"

# Complex script
set -g status-right "#(~/.config/tmux/scripts/status.sh)"
```

### Format String Variables

| Variable | Description |
|----------|-------------|
| `#S` | Session name |
| `#W` | Window name |
| `#I` | Window index |
| `#P` | Pane index |
| `#T` | Pane title |
| `#H` | Hostname |
| `#h` | Short hostname |
| `#F` | Window flags |
| `#D` | Pane unique ID |
| `#{pane_current_path}` | Current directory |
| `#{pane_current_command}` | Running command |

### Conditional Formats
```tmux
# Show icon if zoomed
set -g @catppuccin_window_current_text "#{?window_zoomed_flag,🔍 ,}#W"

# Alert for prefix
set -g @catppuccin_status_modules_left "#{?client_prefix,#[bg=#{@thm_red}] PREFIX ,session}"
```

---

## Recommended Additional Plugins

### Session Persistence
```tmux
# Save/restore sessions across restarts
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'    # Auto-save every 15 min
```

### Text Selection
```tmux
# Vimium-like text selection (press prefix + space to activate)
set -g @plugin 'fcsonline/tmux-thumbs'
set -g @thumbs-command 'echo -n {} | wl-copy'   # Wayland clipboard

# Alternative: tmux-fingers
set -g @plugin 'Morantron/tmux-fingers'
```

### Session Management
```tmux
# FZF-powered session manager
set -g @plugin 'omerxx/tmux-sessionx'
set -g @sessionx-bind 'o'              # prefix + o to open
set -g @sessionx-zoxide-mode 'on'      # Use zoxide for paths
```

### Floating Terminal
```tmux
# Toggle floating pane
set -g @plugin 'omerxx/tmux-floax'
set -g @floax-bind 'p'                 # prefix + p to toggle
set -g @floax-width '80%'
set -g @floax-height '80%'
```

---

## Keybind Patterns

### Pane Navigation (vim-tmux-navigator)
| Key | Action |
|-----|--------|
| `Ctrl+h` | Move left (works in vim too) |
| `Ctrl+j` | Move down |
| `Ctrl+k` | Move up |
| `Ctrl+l` | Move right |

### Pane Management
```tmux
# Split panes (using current path)
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Resize panes (repeatable with -r)
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Zoom (toggle maximize)
bind -r m resize-pane -Z
```

### Window Management
| Key | Action |
|-----|--------|
| `prefix + c` | New window |
| `prefix + n` | Next window |
| `prefix + p` | Previous window |
| `prefix + &` | Kill window |
| `prefix + ,` | Rename window |
| `prefix + w` | Window list (interactive) |
| `prefix + 0-9` | Switch to window N |

### Session Management
| Key | Action |
|-----|--------|
| `prefix + s` | Session list |
| `prefix + $` | Rename session |
| `prefix + d` | Detach |
| `prefix + (` | Previous session |
| `prefix + )` | Next session |

### Copy Mode (vi keys)
```tmux
setw -g mode-keys vi

bind-key -T copy-mode-vi v send -X begin-selection
bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'wl-copy'
bind-key -T copy-mode-vi C-v send -X rectangle-toggle
```

### Which-Key Discovery
Press `prefix + Space` to open the which-key menu showing all available keybinds organized by category.

---

## Session Workflow Patterns

### Development Session
```bash
# Create or attach to dev session
tmux new-session -A -s dev -c ~/Developer/github/project

# Layout: editor (large) + terminal (small)
# Tab 1: Editor
# Tab 2: Terminal
# Tab 3: Git (lazygit)
```

### Monitoring Session
```bash
tmux new-session -A -s monitor

# Tab 1: btop (system monitor)
# Tab 2: Docker logs
# Tab 3: journalctl -f
```

### Scripted Session Setup
```bash
#!/bin/zsh
SESSION="project"

tmux has-session -t "$SESSION" 2>/dev/null
if [ $? != 0 ]; then
    tmux new-session -d -s "$SESSION" -c ~/Developer/github/project

    tmux rename-window -t "$SESSION:0" "editor"
    tmux send-keys -t "$SESSION:0" "nvim ." C-m

    tmux new-window -t "$SESSION" -n "terminal"

    tmux new-window -t "$SESSION" -n "git"
    tmux send-keys -t "$SESSION:2" "lazygit" C-m

    tmux select-window -t "$SESSION:0"
fi
tmux attach -t "$SESSION"
```

### Per-Project Sessions
Name sessions after projects for quick switching:
```bash
tmux new-session -s dotfiles -c ~/Developer/github/.dotfiles
tmux new-session -s webapp -c ~/Developer/github/webapp
```

Switch between: `prefix + s` → select with fzf (tmux-fzf) or arrow keys.

---

## General Configuration Tips

### True Color Support
```tmux
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
```

### Mouse Support
```tmux
set -g mouse on
```

### Base Index
```tmux
set -g base-index 1          # Windows start at 1
setw -g pane-base-index 1    # Panes start at 1
set -g renumber-windows on   # Re-number on close
```

### History
```tmux
set -g history-limit 50000
```

### Status Bar Refresh
```tmux
set -g status-interval 5     # Refresh every 5 seconds
```
