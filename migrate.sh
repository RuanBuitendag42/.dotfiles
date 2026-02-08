#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# migrate.sh - System cleanup and dotfiles migration
# Removes foreign dotfiles, fixes broken references, deploys yours
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

step()    { echo -e "\n${BLUE}━━━ ${BOLD}$1${NC}"; }
ok()      { echo -e "  ${GREEN}✓${NC} $1"; }
skip()    { echo -e "  ${DIM}· $1 (skipped)${NC}"; }
warn()    { echo -e "  ${YELLOW}! $1${NC}"; }
err()     { echo -e "  ${RED}✗ $1${NC}"; }
ask()     { read -p "  $1 [y/N] " -n 1 -r; echo; [[ $REPLY =~ ^[Yy]$ ]]; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_migration_$(date +%Y%m%d_%H%M%S)"

echo -e "${BOLD}"
echo "  ┌──────────────────────────────────────────┐"
echo "  │     Dotfiles Migration & System Cleanup   │"
echo "  └──────────────────────────────────────────┘"
echo -e "${NC}"
echo "  This script will:"
echo "  1. Backup current configs"
echo "  2. Remove foreign (matt's) configs & references"
echo "  3. Fix broken file explorer bookmarks"
echo "  4. Consolidate duplicate XDG directories"
echo "  5. Clean home directory clutter"
echo "  6. Remove foreign systemd services"
echo "  7. Deploy YOUR dotfiles"
echo "  8. Remove orphan packages"
echo ""

if ! ask "Ready to proceed?"; then
    echo "Cancelled."
    exit 0
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "1/8 - Backing up current state"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

mkdir -p "$BACKUP_DIR"

# Backup configs that will be replaced
for dir in hypr waybar wofi dunst swaylock swaync rofi cava kitty tmux starship nvim btop yazi; do
    if [ -d "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null && ok "Backed up ~/.config/$dir" || true
    fi
done

# Backup home dotfiles
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/" && ok "Backed up .zshrc" || true

# Backup GTK bookmarks
[ -f "$HOME/.config/gtk-3.0/bookmarks" ] && cp "$HOME/.config/gtk-3.0/bookmarks" "$BACKUP_DIR/gtk3-bookmarks.bak" && ok "Backed up GTK bookmarks" || true

# Backup XDG user-dirs
[ -f "$HOME/.config/user-dirs.dirs" ] && cp "$HOME/.config/user-dirs.dirs" "$BACKUP_DIR/" && ok "Backed up user-dirs.dirs" || true

ok "All backups saved to $BACKUP_DIR"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "2/8 - Removing foreign configs"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Remove the foreign Hyprland config (has node_modules, matt's scripts, etc.)
if [ -d "$HOME/.config/hypr" ]; then
    # Check if it's the foreign one (has configs/ subdirectory or node_modules)
    if [ -d "$HOME/.config/hypr/configs" ] || [ -d "$HOME/.config/hypr/node_modules" ]; then
        rm -rf "$HOME/.config/hypr"
        ok "Removed foreign Hyprland config (had node_modules/configs dirs)"
    else
        warn "Hyprland config doesn't look foreign, skipping"
    fi
fi

# Remove foreign rofi config (not in your dotfiles)
if [ -d "$HOME/.config/rofi" ]; then
    rm -rf "$HOME/.config/rofi"
    ok "Removed rofi config (you use wofi)"
fi

# Remove foreign swaync config (not in your dotfiles, you use dunst)
if [ -d "$HOME/.config/swaync" ]; then
    rm -rf "$HOME/.config/swaync"
    ok "Removed swaync config (you use dunst)"
fi

# Remove foreign cava config
if [ -d "$HOME/.config/cava" ]; then
    rm -rf "$HOME/.config/cava"
    ok "Removed cava config"
fi

# Remove foreign easyeffects config
if [ -d "$HOME/.config/easyeffects" ]; then
    if ask "Remove easyeffects config? (audio effects you may want to keep)"; then
        rm -rf "$HOME/.config/easyeffects"
        ok "Removed easyeffects config"
    else
        skip "easyeffects"
    fi
fi

# Remove current waybar (will be replaced by yours)
if [ -d "$HOME/.config/waybar" ]; then
    rm -rf "$HOME/.config/waybar"
    ok "Removed old waybar config"
fi

# Remove current wofi (will be replaced)
if [ -d "$HOME/.config/wofi" ]; then
    rm -rf "$HOME/.config/wofi"
    ok "Removed old wofi config"
fi

# Remove current dunst (will be replaced)
if [ -d "$HOME/.config/dunst" ]; then
    rm -rf "$HOME/.config/dunst"
    ok "Removed old dunst config"
fi

# Remove current swaylock (will be replaced)
if [ -d "$HOME/.config/swaylock" ]; then
    rm -rf "$HOME/.config/swaylock"
    ok "Removed old swaylock config"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "3/8 - Fixing file explorer bookmarks"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Fix GTK3 bookmarks (currently pointing to /home/matt/)
mkdir -p "$HOME/.config/gtk-3.0"
cat > "$HOME/.config/gtk-3.0/bookmarks" << EOF
file://$HOME/downloads downloads
file://$HOME/documents documents
file://$HOME/pictures pictures
file://$HOME/videos videos
file://$HOME/music music
file://$HOME/Developer Developer
file://$HOME/.config .config
EOF
ok "Fixed GTK3 bookmarks (was pointing to /home/matt/)"

# Fix GTK4 bookmarks too
mkdir -p "$HOME/.config/gtk-4.0"
cp "$HOME/.config/gtk-3.0/bookmarks" "$HOME/.config/gtk-4.0/bookmarks"
ok "Fixed GTK4 bookmarks"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "4/8 - Consolidating duplicate XDG directories"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# You have both Desktop/desktop, Documents/documents, etc.
# Lowercase is what user-dirs.dirs points to - consolidate there

consolidate_dir() {
    local upper="$HOME/$1"
    local lower="$HOME/$2"

    if [ -d "$upper" ] && [ -d "$lower" ]; then
        # Move contents from uppercase to lowercase
        if [ "$(ls -A "$upper" 2>/dev/null)" ]; then
            cp -rn "$upper/"* "$lower/" 2>/dev/null || true
            ok "Merged $1 -> $2"
        fi
        rm -rf "$upper"
        ok "Removed duplicate $1 (kept $2)"
    elif [ -d "$upper" ] && [ ! -d "$lower" ]; then
        mv "$upper" "$lower"
        ok "Renamed $1 -> $2"
    elif [ ! -d "$lower" ]; then
        mkdir -p "$lower"
        ok "Created $2"
    else
        skip "$2 already exists, no uppercase duplicate"
    fi
}

consolidate_dir "Desktop" "desktop"
consolidate_dir "Documents" "documents"
consolidate_dir "Downloads" "downloads"
consolidate_dir "Music" "music"
consolidate_dir "Pictures" "pictures"
consolidate_dir "Videos" "videos"

# Create missing dirs
mkdir -p "$HOME/pictures/screenshots"
mkdir -p "$HOME/pictures/wallpapers"
mkdir -p "$HOME/Developer"
ok "Ensured screenshots/wallpapers/Developer dirs exist"

# Update user-dirs.dirs
cat > "$HOME/.config/user-dirs.dirs" << 'EOF'
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_PUBLICSHARE_DIR="$HOME/"
XDG_TEMPLATES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/videos"
EOF
ok "Updated user-dirs.dirs"

# Prevent xdg-user-dirs-update from recreating uppercase dirs
echo "enabled=False" > "$HOME/.config/user-dirs.locale" 2>/dev/null || true

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "5/8 - Cleaning home directory clutter"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Remove catppuccin-kde directory (15MB, from the foreign setup)
if [ -d "$HOME/catppuccin-kde" ]; then
    rm -rf "$HOME/catppuccin-kde"
    ok "Removed catppuccin-kde/ (15MB)"
fi

# Remove tar archive
if [ -f "$HOME/Catppuccin-SE.tar.bz2" ]; then
    rm -f "$HOME/Catppuccin-SE.tar.bz2"
    ok "Removed Catppuccin-SE.tar.bz2 (15MB)"
fi

# Remove stray LICENSE file
if [ -f "$HOME/LICENSE" ]; then
    rm -f "$HOME/LICENSE"
    ok "Removed stray LICENSE file"
fi

# Remove test print file
if [ -f "$HOME/testprint.orca_printer" ]; then
    rm -f "$HOME/testprint.orca_printer"
    ok "Removed testprint.orca_printer"
fi

# Remove stray % file
if [ -f "$HOME/%" ]; then
    rm -f "$HOME/%"
    ok "Removed stray % file"
fi

# Remove .face.icon if from foreign setup
if [ -f "$HOME/.face.icon" ]; then
    if ask "Remove .face.icon (login avatar from foreign setup)?"; then
        rm -f "$HOME/.face.icon"
        ok "Removed .face.icon"
    else
        skip ".face.icon"
    fi
fi

# Remove Public and Templates if empty
[ -d "$HOME/Public" ] && rmdir "$HOME/Public" 2>/dev/null && ok "Removed empty Public/" || true
[ -d "$HOME/Templates" ] && rmdir "$HOME/Templates" 2>/dev/null && ok "Removed empty Templates/" || true

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "6/8 - Removing foreign systemd services"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# These are from matt's setup and won't work on your system
FOREIGN_SERVICES=(
    "backupGames.service"
    "backupGames.timer"
    "downloadMedia.service"
    "downloadMedia.timer"
    "downloadSpotify.service"
    "downloadSpotify.timer"
    "surfingKeys.service"
)

for svc in "${FOREIGN_SERVICES[@]}"; do
    if [ -f "$HOME/.config/systemd/user/$svc" ]; then
        systemctl --user disable "$svc" 2>/dev/null || true
        systemctl --user stop "$svc" 2>/dev/null || true
        rm -f "$HOME/.config/systemd/user/$svc"
        ok "Removed foreign service: $svc"
    fi
done

systemctl --user daemon-reload 2>/dev/null || true

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "7/8 - Deploying YOUR dotfiles"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

cd "$DOTFILES_DIR"

# Deploy configs
echo "  Deploying application configs..."
mkdir -p "$HOME/.config"
cd config && stow -v -t "$HOME/.config" . 2>&1 | head -20
cd "$DOTFILES_DIR"
ok "Application configs deployed"

# Deploy home dotfiles
echo "  Deploying home dotfiles..."
cd home && stow -v -t "$HOME" . 2>&1 | head -10
cd "$DOTFILES_DIR"
ok "Home dotfiles deployed"

# Deploy scripts
echo "  Deploying scripts..."
cd scripts && stow -v -t "$HOME" . 2>&1 | head -10
cd "$DOTFILES_DIR"
chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
ok "Scripts deployed"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "8/8 - Package cleanup"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Remove orphan packages
ORPHANS=$(pacman -Qdtq 2>/dev/null || true)
if [ -n "$ORPHANS" ]; then
    echo "  Orphan packages found:"
    echo "$ORPHANS" | while read pkg; do echo "    $pkg"; done
    echo ""
    if ask "Remove all orphan packages?"; then
        sudo pacman -Rns --noconfirm $ORPHANS
        ok "Orphan packages removed"
    else
        skip "Orphan removal"
    fi
else
    ok "No orphan packages"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Summary
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""
echo -e "${GREEN}${BOLD}━━━ Migration Complete! ━━━${NC}"
echo ""
echo "  What was done:"
echo "    - Foreign configs removed (hypr, rofi, swaync, cava, etc.)"
echo "    - File explorer bookmarks fixed (/home/matt/ -> /home/ruanb/)"
echo "    - Duplicate directories consolidated (uppercase -> lowercase)"
echo "    - Home directory clutter cleaned"
echo "    - Foreign systemd services disabled & removed"
echo "    - YOUR dotfiles deployed via stow"
echo "    - Orphan packages handled"
echo ""
echo "  Backup location: $BACKUP_DIR"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo "    1. Log out and log back in"
echo "    2. Select Hyprland from login manager"
echo "    3. Add wallpapers to ~/pictures/wallpapers/"
echo "    4. Run 'wallpaper.sh' or SUPER+SHIFT+W for wallpaper"
echo ""
echo -e "  ${BOLD}Key bindings cheat sheet:${NC}"
echo "    SUPER+RETURN     Kitty terminal"
echo "    SUPER+D          App launcher (Wofi)"
echo "    SUPER+E          File manager (Nemo)"
echo "    SUPER+B          Browser (Zen)"
echo "    SUPER+Q          Close window"
echo "    SUPER+HJKL       Vim-style window focus"
echo "    SUPER+SHIFT+HJKL Move windows"
echo "    SUPER+R           Resize mode (HJKL to resize, ESC to exit)"
echo "    SUPER+V          Toggle floating"
echo "    SUPER+F          Fullscreen"
echo "    SUPER+1-0        Switch workspace"
echo "    SUPER+SHIFT+1-0  Move window to workspace"
echo "    SUPER+Y          Clipboard history"
echo "    SUPER+ESCAPE     Lock screen"
echo "    SUPER+M          Power menu"
echo "    SUPER+SHIFT+R    Reload Hyprland"
echo "    PRINT            Screenshot (area select)"
echo "    SHIFT+PRINT      Screenshot (full screen)"
echo ""
echo -e "  ${YELLOW}NOTE:${NC} Some PATH entries still reference /home/matt/"
echo "  These come from shell profile files. After relogin with your"
echo "  .zshrc deployed, these will be gone."
echo ""
