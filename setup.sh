#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# setup.sh - Full system setup from scratch
# Reproduces a complete Arch Linux environment from this repo
# Usage: ./setup.sh [--minimal] [--no-aur] [--no-hyprland]
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

# ─── Parse Arguments ────────────────────────────────────────────
INSTALL_AUR=true
INSTALL_HYPRLAND=true
MINIMAL=false

for arg in "$@"; do
    case $arg in
        --minimal)      MINIMAL=true ;;
        --no-aur)       INSTALL_AUR=false ;;
        --no-hyprland)  INSTALL_HYPRLAND=false ;;
        --help|-h)
            echo "Usage: ./setup.sh [--minimal] [--no-aur] [--no-hyprland]"
            echo ""
            echo "  --minimal      Only install essential CLI tools + deploy configs"
            echo "  --no-aur       Skip AUR packages"
            echo "  --no-hyprland  Skip Hyprland DE packages"
            exit 0
            ;;
    esac
done

# ─── Sanity Checks ──────────────────────────────────────────────
if ! command -v pacman &> /dev/null; then
    err "This script requires an Arch-based distribution"
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper: read package list, strip comments and blank lines
read_pkglist() {
    grep -v '^#' "$1" | grep -v '^$' | tr '\n' ' '
}

echo -e "${BOLD}"
echo "  ┌──────────────────────────────────────────┐"
echo "  │       Full System Setup - Dotfiles        │"
echo "  └──────────────────────────────────────────┘"
echo -e "${NC}"
echo "  Dotfiles: $DOTFILES_DIR"
echo "  AUR:      $INSTALL_AUR"
echo "  Hyprland: $INSTALL_HYPRLAND"
echo "  Minimal:  $MINIMAL"
echo ""

if ! ask "Ready to proceed?"; then
    echo "Cancelled."
    exit 0
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "1/9 - System Update"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
sudo pacman -Syu --noconfirm
ok "System updated"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "2/9 - Install yay (AUR helper)"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    ok "yay installed"
else
    ok "yay already installed"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "3/9 - Install Packages (pacman)"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$MINIMAL" = true ]; then
    echo "  Installing minimal set..."
    sudo pacman -S --needed --noconfirm \
        base-devel git stow zsh starship \
        eza fzf ripgrep fd zoxide yq less \
        kitty neovim tmux btop lazygit yazi \
        git-delta github-cli duf fastfetch
    ok "Minimal CLI tools installed"
else
    if [ -f "$DOTFILES_DIR/packages/pacman.txt" ]; then
        echo "  Installing from packages/pacman.txt..."
        PKGS=$(read_pkglist "$DOTFILES_DIR/packages/pacman.txt")
        sudo pacman -S --needed --noconfirm $PKGS
        ok "All pacman packages installed"
    else
        err "packages/pacman.txt not found!"
        exit 1
    fi
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "4/9 - Install AUR Packages"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_AUR" = true ] && [ "$MINIMAL" = false ]; then
    if [ -f "$DOTFILES_DIR/packages/aur.txt" ]; then
        echo "  Installing from packages/aur.txt..."
        AURPKGS=$(read_pkglist "$DOTFILES_DIR/packages/aur.txt")
        yay -S --needed --noconfirm $AURPKGS
        ok "All AUR packages installed"
    else
        warn "packages/aur.txt not found, skipping"
    fi
else
    skip "AUR packages"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "5/9 - Set ZSH as Default Shell"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    ok "ZSH set as default shell (relogin required)"
else
    ok "ZSH already default shell"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "6/9 - Backup Existing Configs"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
HAS_EXISTING=false

for item in .zshrc; do
    [ -f "$HOME/$item" ] && [ ! -L "$HOME/$item" ] && HAS_EXISTING=true
done
for dir in nvim kitty tmux starship hypr waybar wofi dunst swaylock btop yazi; do
    [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ] && HAS_EXISTING=true
done

if [ "$HAS_EXISTING" = true ]; then
    mkdir -p "$BACKUP_DIR"
    for item in .zshrc; do
        [ -f "$HOME/$item" ] && [ ! -L "$HOME/$item" ] && cp "$HOME/$item" "$BACKUP_DIR/" 2>/dev/null || true
    done
    for dir in nvim kitty tmux starship hypr waybar wofi dunst swaylock btop yazi; do
        [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
    done
    ok "Existing configs backed up to $BACKUP_DIR"
else
    ok "No conflicting configs found"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "7/9 - Deploy Dotfiles"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
cd "$DOTFILES_DIR"

# Application configs
echo "  Deploying application configs..."
mkdir -p "$HOME/.config"
cd config && stow --adopt -v -t "$HOME/.config" . 2>&1 | tail -5
cd "$DOTFILES_DIR"
ok "Application configs deployed"

# Home dotfiles
echo "  Deploying home dotfiles..."
cd home && stow --adopt -v -t "$HOME" . 2>&1 | tail -5
cd "$DOTFILES_DIR"
ok "Home dotfiles deployed"

# Scripts
echo "  Deploying scripts..."
mkdir -p "$HOME/.local/bin"
cd scripts && stow --adopt -v -t "$HOME" . 2>&1 | tail -5
cd "$DOTFILES_DIR"
chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
ok "Scripts deployed"

# Restore any files that got adopted (override system files with repo versions)
cd "$DOTFILES_DIR"
git checkout -- config/ home/ scripts/ 2>/dev/null || true
ok "Repo state verified"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "8/9 - Create Directories & Fix XDG"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
mkdir -p "$HOME"/{desktop,documents,downloads,music,Pictures,videos,Developer}
mkdir -p "$HOME/Pictures"/{screenshots,Wallpapers}
ok "XDG directories created"

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
echo "enabled=False" > "$HOME/.config/user-dirs.locale" 2>/dev/null || true
ok "XDG user-dirs configured (lowercase)"

# Fix GTK bookmarks
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat > "$HOME/.config/gtk-3.0/bookmarks" << EOF
file://$HOME/downloads downloads
file://$HOME/documents documents
file://$HOME/pictures pictures
file://$HOME/videos videos
file://$HOME/music music
file://$HOME/Developer Developer
file://$HOME/.config .config
EOF
cp "$HOME/.config/gtk-3.0/bookmarks" "$HOME/.config/gtk-4.0/bookmarks"
ok "File manager bookmarks set"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
step "9/9 - Post-Install Setup"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Enable services
sudo systemctl enable --now NetworkManager 2>/dev/null || true
sudo systemctl enable --now bluetooth 2>/dev/null || true
sudo systemctl enable --now sddm 2>/dev/null || true
sudo systemctl enable --now docker 2>/dev/null || true
sudo usermod -aG docker "$USER" 2>/dev/null || true
ok "System services enabled"

# Set SDDM theme to Catppuccin Macchiato Mauve
if [ -d "/usr/share/sddm/themes/catppuccin-macchiato-mauve" ]; then
    sudo mkdir -p /etc/sddm.conf.d
    echo -e '[Theme]\nCurrent=catppuccin-macchiato-mauve' | sudo tee /etc/sddm.conf.d/99-catppuccin.conf > /dev/null
    ok "SDDM theme set to Catppuccin Macchiato Mauve"
fi

# Download wallpapers if directory is empty
if [ -z "$(ls -A \"$HOME/Pictures/Wallpapers/\" 2>/dev/null)" ]; then
    echo "  Downloading cyberpunk wallpapers..."
    cd "$HOME/Pictures/Wallpapers"
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/catpuccin_samurai.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/manga-samurai.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/cyberpunk_car.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/japan-purple-blur.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/catpuccin_landscape.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/japan_torii.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/neocity.png 2>/dev/null || true
    curl -fLO https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/rad_samurai.jpg 2>/dev/null || true
    cd "$DOTFILES_DIR"
    ok "Wallpapers downloaded"
else
    ok "Wallpapers already present"
fi

# Neovim plugins
echo "  Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
ok "Neovim plugins installed"

# TPM (tmux plugin manager)
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm" 2>/dev/null || true
    ok "TPM installed (run prefix+I in tmux to install plugins)"
else
    ok "TPM already installed"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Summary
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo -e "${GREEN}${BOLD}━━━ Setup Complete! ━━━${NC}"
echo ""
echo -e "  ${BOLD}What was installed:${NC}"
echo "    Shells:     ZSH + Starship prompt"
echo "    Terminal:   Kitty (Catppuccin Macchiato)"
echo "    Editor:     Neovim (LazyVim) + VS Code"
echo "    Tmux:       Catppuccin Macchiato + TPM"
echo "    CLI:        eza, fzf, ripgrep, yq, btop, lazygit, yazi, etc."
if [ "$INSTALL_HYPRLAND" = true ] && [ "$MINIMAL" = false ]; then
    echo ""
    echo -e "  ${BOLD}Hyprland DE:${NC}"
    echo "    WM:         Hyprland + Hypridle + Hyprlock"
    echo "    Bar:        Waybar (Macchiato)"
    echo "    Launcher:   Wofi"
    echo "    Notifs:     Dunst"
    echo "    Wallpaper:  swww (19 cyberpunk wallpapers)"
    echo "    Login:      SDDM (Catppuccin Macchiato Mauve)"
    echo "    Screenshots: grim + slurp + satty"
fi
echo ""
echo -e "  ${BOLD}Key bindings:${NC}"
echo "    SUPER+RETURN     Kitty terminal"
echo "    SUPER+D          App launcher (Wofi)"
echo "    SUPER+E          File manager (Nemo)"
echo "    SUPER+B          Browser (Zen)"
echo "    SUPER+Q          Close window"
echo "    SUPER+HJKL       Vim-style focus"
echo "    SUPER+SHIFT+HJKL Move windows"
echo "    SUPER+R           Resize mode (HJKL, ESC to exit)"
echo "    SUPER+V          Toggle floating"
echo "    SUPER+F          Fullscreen"
echo "    SUPER+1-0        Switch workspace"
echo "    SUPER+Y          Clipboard history"
echo "    SUPER+W          Cycle wallpaper"
echo "    SUPER+ESCAPE     Lock screen"
echo "    SUPER+M          Power menu"
echo "    PRINT            Screenshot (area)"
echo "    SUPER+SHIFT+R    Reload Hyprland"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo "    1. Log out and log back in (for ZSH + docker group)"
echo "    2. Select Hyprland from SDDM login manager"
echo "    3. Wallpapers auto-set on login (SUPER+W to cycle)"
echo "    4. In tmux, press prefix+I to install plugins"
echo ""
echo -e "  ${BOLD}Maintaining package lists:${NC}"
echo "    make packages-save    Save current packages to repo"
echo "    make packages-diff    Show diff vs saved list"
echo ""
