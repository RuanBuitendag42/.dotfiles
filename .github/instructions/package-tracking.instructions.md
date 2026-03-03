---
description: 'Package list management conventions for Arch Linux pacman and AUR package tracking'
applyTo: 'packages/**'
---

# Package Tracking Conventions

## File Format

- One package name per line, sorted alphabetically
- Lines starting with `#` are comments (header info, date, category markers)
- Blank lines allowed for readability between categories

## Package Files

| File | Source Command | Contents |
|------|---------------|----------|
| `packages/pacman.txt` | `pacman -Qqen` | Native packages from official repos |
| `packages/aur.txt` | `pacman -Qqem` | AUR / foreign packages |

## Workflow

### Saving Current State

```bash
# Snapshot all installed packages to repo
make packages-save

# Review what changed
git diff packages/

# Commit
git add packages/
git commit -m "chore: update package lists"
git push
```

### Checking for Drift

```bash
# Compare installed packages vs saved lists
make packages-diff
```

This shows packages that were installed since last save (added) and packages in the list that are no longer installed (removed).

### Cleaning Orphans

```bash
# Find and optionally remove orphan packages
make orphans
```

## NEVER Install Packages Without User Confirmation

When recommending or scripting package installation:
- List the packages to be installed
- Explain why each is needed
- Wait for explicit user confirmation before running `pacman -S` or `yay -S`

## Package Categories

Organize mental model of packages by purpose:

| Category | Examples |
|----------|---------|
| **CLI Essentials** | bat, eza, fd, fzf, ripgrep, dust, ncdu, jq, yq |
| **Dev Tools** | git, git-delta, lazygit, neovim, shellcheck, shfmt |
| **Hyprland Stack** | hyprland, hyprlock, hypridle, waybar, wofi, dunst, swaylock, pyprland |
| **Fonts** | ttf-jetbrains-mono-nerd, noto-fonts-cjk, noto-fonts-emoji |
| **Themes** | catppuccin-gtk-theme-macchiato (AUR), catppuccin-cursors-macchiato (AUR) |
| **Communication** | discord, slack-desktop (AUR) |
| **Media** | mpv, imv, grim, slurp, swappy |
| **System** | btop, fastfetch, networkmanager, pipewire, wireplumber |
| **Backup & Security** | restic, borg, git-crypt, gnupg |

## Recommended Packages (Not Yet Installed)

Consider adding these to improve the setup — install only after user confirmation:

### CLI Quality of Life
- `bat` — syntax-highlighted cat replacement
- `dust` — intuitive disk usage (du replacement)
- `ncdu` — interactive disk usage analyzer

### Script Quality
- `shellcheck` — static analysis for bash scripts
- `shfmt` — bash script formatter

### Shell Enhancements
- `direnv` — per-directory environment variables
- `atuin` — smart shell history with sync

### Hyprland Extras
- `hyprsunset` — night-light / blue-light filter
- `hyprdim` — dim inactive windows
- `kanshi` — dynamic multi-monitor profiles

### System Maintenance
- `topgrade` — unified system updater (pacman + AUR + flatpak + etc.)
- `informant` — read Arch News before upgrading (prevents breakage)
- `pacman-contrib` — paccache, checkupdates, and other utility scripts

### Backup
- `restic` — deduplicated, encrypted backups
- `borg` — similar alternative to restic
