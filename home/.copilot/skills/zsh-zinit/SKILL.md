---
name: zsh-zinit
description: "ZSH zinit plugin management, startup optimization, custom functions, and completion styling"
---

# ZSH Zinit Configuration Reference

Comprehensive guide for ZSH plugin management with zinit, startup speed optimization, custom functions, and completion styling.

---

## Zinit Loading Modes

### Regular (Synchronous)
```zsh
zinit light zsh-users/zsh-autosuggestions
```
Loads immediately, blocks until done. Use only for essential items like the prompt.

### Turbo Mode (Deferred)
```zsh
zinit ice wait'0' lucid
zinit light zsh-users/zsh-autosuggestions
```
Loads asynchronously after the prompt is drawn. `lucid` suppresses the "loaded" message.

**Wait values:**
| Value | When it loads |
|-------|--------------|
| `wait'0'` | Immediately after prompt (first idle tick) |
| `wait'1'` | 1 tick after prompt |
| `wait'2'` | 2 ticks after prompt |
| `wait'!0'` | After prompt, reset prompt after load |

Higher wait = more deferred = faster initial prompt display.

### Conditional Loading
```zsh
zinit ice if'command -v docker'
zinit light docker/cli
```
Only loads if the condition evaluates to true.

### Ice Modifiers Reference

| Modifier | Description |
|----------|-------------|
| `wait'N'` | Deferred loading (turbo) |
| `lucid` | Suppress load messages |
| `atload'cmd'` | Run command after loading |
| `atinit'cmd'` | Run command before loading |
| `atclone'cmd'` | Run on first clone |
| `atpull'cmd'` | Run on update |
| `blockf` | Block standard completion loading |
| `as'completion'` | Treat as completion file |
| `pick'file'` | Source specific file |
| `src'file'` | Source additional file |
| `depth'1'` | Shallow clone |
| `if'condition'` | Conditional loading |
| `has'command'` | Load only if command exists |

---

## Startup Speed Optimization

### Target: < 100ms

**Measure startup:**
```zsh
time zsh -i -c exit       # Total startup time
zinit times               # Per-plugin load times
zinit report              # Detailed reports
```

### Key Strategies

1. **Turbo-load everything except the prompt** — prompt must be immediate
2. **Use `atload` for deferred initialization** — run setup code lazily
3. **Lazy-load heavy tools** — NVM, pyenv, Angular CLI, etc.
4. **Compile completions** with `zinit cdreplay` — batch completion setup
5. **Use `blockf`** to consolidate completion loading
6. **Shallow clones** with `depth'1'` — faster clone, less disk

### Lazy-Loading Pattern for Heavy Tools
```zsh
# NVM (adds ~500ms if loaded eagerly)
export NVM_LAZY_LOAD=true
zinit ice wait'2' lucid
zinit light lukechilds/zsh-nvm

# Pyenv
zinit ice wait'2' lucid atload'eval "$(pyenv init -)"'
zinit light pyenv/pyenv
```

---

## Optimal Loading Order

```zsh
# ============================================
# 1. PROMPT — immediate, no turbo
# ============================================
eval "$(starship init zsh)"

# ============================================
# 2. ESSENTIAL — turbo wait'0'
# ============================================

# Completions (must load before compinit)
zinit ice wait'0' lucid blockf
zinit light zsh-users/zsh-completions

# Autosuggestions
zinit ice wait'0' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Key bindings
zinit ice wait'0' lucid
zinit light zsh-users/zsh-history-substring-search

# ============================================
# 3. VISUAL — turbo wait'1'
# ============================================

# Syntax highlighting (must be after completions)
zinit ice wait'1' lucid
zinit light zsh-users/zsh-syntax-highlighting

# ============================================
# 4. EXTRAS — turbo wait'2'
# ============================================

# Fzf-tab (replaces default tab completion)
zinit ice wait'2' lucid
zinit light Aloxaf/fzf-tab

# Autopair brackets
zinit ice wait'2' lucid
zinit light hlissner/zsh-autopair

# You-should-use (alias reminders)
zinit ice wait'2' lucid
zinit light MichaelAqworthy/zsh-you-should-use

# ============================================
# 5. COMPLETION INIT — after all plugins
# ============================================
zinit ice wait'0' lucid atinit'zicompinit; zicdreplay'
zinit light zdharma-continuum/null
```

---

## Useful Plugins Catalog

### Already Installed
| Plugin | Description |
|--------|-------------|
| `zsh-users/zsh-autosuggestions` | Fish-like inline suggestions |
| `zsh-users/zsh-syntax-highlighting` | Command coloring |
| `zsh-users/zsh-completions` | Additional completions |
| `Aloxaf/fzf-tab` | Fzf-powered tab completion |

### Recommended Additions

| Plugin | Description | Priority |
|--------|-------------|----------|
| `zsh-users/zsh-history-substring-search` | History search by substring | High |
| `hlissner/zsh-autopair` | Auto-close brackets, quotes | Medium |
| `MichaelAqworthy/zsh-you-should-use` | Reminds about existing aliases | Medium |
| `zdharma-continuum/fast-syntax-highlighting` | Faster syntax highlighting (alternative) | Optional |
| `agkozak/zsh-z` | Smart directory jumping (if not using zoxide) | Optional |
| `djui/alias-tips` | Alternative alias reminder | Optional |
| `unixorn/fzf-zsh-plugin` | Extra fzf functions | Optional |
| `wfxr/forgit` | Git with fzf (interactive git add, log, diff) | Medium |

### Snippets / OMZ Libraries
Zinit can load individual Oh My Zsh libraries without the full framework:
```zsh
zinit ice wait'0' lucid
zinit snippet OMZ::lib/history.zsh

zinit ice wait'0' lucid
zinit snippet OMZ::lib/key-bindings.zsh

zinit ice wait'0' lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh
```

---

## Custom Function Patterns

### Archive Extraction
```zsh
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *.zst)     unzstd "$1" ;;
      *)         echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
```

### Directory Helpers
```zsh
# Create dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# Go up N directories
up() { cd $(printf '../%.0s' {1..${1:-1}}) }
```

### Quick Git
```zsh
# Add all and commit
gc() { git add -A && git commit -m "$1" }

# Add all, commit, push
gcp() { git add -A && git commit -m "$1" && git push }

# Interactive branch checkout with fzf
gco() { git branch --all | fzf --preview 'git log --oneline -10 {1}' | xargs git checkout }
```

### Fuzzy Finders
```zsh
# Find and open file in nvim
fvim() { nvim "$(fzf --preview 'bat --color=always {}')" }

# Find and cd into directory
fcd() { cd "$(find . -type d | fzf --preview 'eza -1 --color=always {}')" }

# Kill process with fzf
fkill() { ps aux | fzf --header-lines=1 | awk '{print $2}' | xargs kill -9 }
```

### System Info
```zsh
# Quick system temps (AMD)
temps() {
  echo "CPU: $(sensors | grep -m1 'Tctl' | awk '{print $2}')"
  echo "GPU: $(cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null | awk '{printf "%.0f°C\n", $1/1000}')"
}
```

---

## Completion Styling

### Case-Insensitive Matching
```zsh
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
```

### Colored Completions
```zsh
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
```

### Menu Selection
```zsh
zstyle ':completion:*' menu select              # Arrow key selection
# OR
zstyle ':completion:*' menu no                  # Required for fzf-tab
```

### Grouping
```zsh
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{magenta}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
```

### fzf-tab Previews
```zsh
# Directory preview with eza
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'

# File preview with bat
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --color=always $realpath 2>/dev/null'

# Process preview for kill
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -p $word -o pid,user,%cpu,%mem,cmd --no-headers'

# Environment variable value
zstyle ':fzf-tab:complete:export:*' fzf-preview 'echo ${(P)word}'

# Git checkout branch preview
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log --oneline --graph -10 $word'
```

### fzf-tab Appearance
```zsh
zstyle ':fzf-tab:*' fzf-flags '--height=40%' '--layout=reverse' '--border'
zstyle ':fzf-tab:*' switch-group '<' '>'        # Tab group switch keys
zstyle ':fzf-tab:*' continuous-trigger '/'       # Trigger for continuous completion
```

---

## Shell Integration Best Practices

### fzf
```zsh
eval "$(fzf --zsh)"     # Keybinds (Ctrl+T, Ctrl+R, Alt+C) + completion

# Customize fzf appearance
export FZF_DEFAULT_OPTS="
  --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
  --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
  --border --height 40% --layout=reverse
"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
```

### zoxide (Smart cd)
```zsh
eval "$(zoxide init --cmd cd zsh)"   # Replaces cd with smart version
# Now: cd = z (smart jump), cdi = zi (interactive)
```

### eza (Modern ls)
```zsh
alias ls='eza --icons'
alias l='eza -la --icons --git'
alias ll='eza -l --icons --git'
alias lt='eza --tree --level=2 --icons'
alias la='eza -la --icons --git --group-directories-first'
```

### bat (Better cat)
```zsh
alias cat='bat --style=auto'
export BAT_THEME="Catppuccin Macchiato"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # Colored man pages
```

### ripgrep
```zsh
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
# Don't alias grep to rg — they have different syntax; use rg directly
```

### yazi (Terminal file manager)
```zsh
# cd into directory on exit
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
```
