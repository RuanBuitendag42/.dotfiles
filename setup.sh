#!/usr/bin/env bash
# Automated dotfiles setup script
# Run this on a fresh EndeavourOS/Arch installation
# Usage: ./setup.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

print_step()    { echo -e "${BLUE}==>${NC} ${1}"; }
print_success() { echo -e "${GREEN} ✓${NC} ${1}"; }
print_warning() { echo -e "${YELLOW} !${NC} ${1}"; }
print_error()   { echo -e "${RED} ✗${NC} ${1}"; }

# Check if running on Arch-based system
if ! command -v pacman &> /dev/null; then
    print_error "This script requires an Arch-based distribution"
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step "Starting dotfiles setup from ${DOTFILES_DIR}..."
echo ""

# ─── System Update ──────────────────────────────────────────────
print_step "Updating system packages..."
sudo pacman -Syu --noconfirm
print_success "System updated"

# ─── Install yay ────────────────────────────────────────────────
if ! command -v yay &> /dev/null; then
    print_step "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    print_success "yay installed"
else
    print_success "yay already installed"
fi

# ─── Essential CLI Tools ────────────────────────────────────────
print_step "Installing essential packages..."
sudo pacman -S --needed --noconfirm \
    base-devel git stow \
    zsh starship \
    eza fzf bat ripgrep fd zoxide \
    kitty neovim tmux btop \
    lazygit yazi

print_success "Essential CLI tools installed"

# ─── Hyprland DE ────────────────────────────────────────────────
echo ""
read -p "Install Hyprland desktop environment? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Installing Hyprland and DE components..."
    sudo pacman -S --needed --noconfirm \
        hyprland hypridle hyprlock hyprpicker \
        waybar wofi dunst swww \
        grim slurp satty wl-clipboard cliphist \
        xdg-desktop-portal-hyprland \
        polkit-kde-agent \
        nemo nemo-fileroller \
        network-manager-applet blueman \
        pavucontrol udiskie \
        qt5ct qt6ct kvantum nwg-look \
        papirus-icon-theme \
        brightnessctl playerctl \
        ttf-jetbrains-mono-nerd noto-fonts-emoji

    # AUR packages
    yay -S --needed --noconfirm \
        catppuccin-gtk-theme-macchiato \
        catppuccin-cursors-macchiato \
        swaylock-effects

    INSTALL_HYPRLAND=true
    print_success "Hyprland packages installed"
else
    INSTALL_HYPRLAND=false
    print_warning "Skipping Hyprland installation"
fi

# ─── Set ZSH as Default Shell ───────────────────────────────────
print_step "Setting ZSH as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    print_success "ZSH set as default shell (relogin required)"
else
    print_success "ZSH already default shell"
fi

# ─── Backup Existing Configs ────────────────────────────────────
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
if [ -f "$HOME/.zshrc" ] || [ -d "$HOME/.config/nvim" ] || [ -d "$HOME/.config/kitty" ] || [ -d "$HOME/.config/hypr" ]; then
    print_step "Backing up existing configs to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    for item in .zshrc; do
        [ -f "$HOME/$item" ] && cp "$HOME/$item" "$BACKUP_DIR/" 2>/dev/null || true
    done
    for dir in nvim kitty tmux starship hypr waybar wofi dunst swaylock; do
        [ -d "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
    done
    print_success "Backup complete"
fi

# ─── Deploy Configs ─────────────────────────────────────────────
cd "$DOTFILES_DIR"

print_step "Deploying application configs..."
mkdir -p "$HOME/.config"
cd config && stow -v --adopt -t "$HOME/.config" . 2>/dev/null || stow -v -t "$HOME/.config" .
cd "$DOTFILES_DIR"
print_success "Application configs deployed"

print_step "Deploying home configs..."
cd home && stow -v --adopt -t "$HOME" . 2>/dev/null || stow -v -t "$HOME" .
cd "$DOTFILES_DIR"
print_success "Home configs deployed"

print_step "Deploying scripts..."
cd scripts && stow -v --adopt -t "$HOME" . 2>/dev/null || stow -v -t "$HOME" .
cd "$DOTFILES_DIR"
chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
print_success "Scripts deployed"

# ─── Create Required Directories ────────────────────────────────
print_step "Creating required directories..."
mkdir -p "$HOME/pictures/screenshots"
mkdir -p "$HOME/pictures/wallpapers"
mkdir -p "$HOME/documents"
mkdir -p "$HOME/downloads"
mkdir -p "$HOME/desktop"
mkdir -p "$HOME/videos"
mkdir -p "$HOME/music"
mkdir -p "$HOME/Developer"
print_success "Directories created"

# ─── Fix XDG User Dirs ──────────────────────────────────────────
print_step "Configuring XDG user directories..."
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
print_success "XDG directories configured"

# ─── Install Neovim Plugins ────────────────────────────────────
print_step "Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
print_success "Neovim plugins installed"

# ─── Summary ────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_success "Dotfiles setup complete!"
echo ""
echo -e "${BOLD}Installed:${NC}"
echo "  ZSH + Starship prompt"
echo "  Kitty terminal (Catppuccin Macchiato)"
echo "  Neovim with LazyVim"
echo "  Tmux with Catppuccin Macchiato"
echo "  CLI tools: eza, fzf, bat, ripgrep, fd, zoxide"
echo "  btop, lazygit, yazi"

if [ "$INSTALL_HYPRLAND" = true ]; then
    echo ""
    echo -e "${BOLD}Hyprland DE:${NC}"
    echo "  Hyprland + Hypridle + Hyprlock"
    echo "  Waybar, Wofi, Dunst (all Macchiato themed)"
    echo "  Screenshots: grim + slurp + satty"
    echo "  Swww wallpaper engine"
fi

echo ""
echo -e "${BOLD}Key bindings:${NC}"
echo "  SUPER+RETURN    Terminal (Kitty)"
echo "  SUPER+D         App launcher (Wofi)"
echo "  SUPER+E         File manager (Nemo)"
echo "  SUPER+B         Browser (Zen)"
echo "  SUPER+Q         Close window"
echo "  SUPER+HJKL      Vim-style focus"
echo "  SUPER+R          Resize mode (then HJKL, ESC to exit)"
echo "  SUPER+Y         Clipboard history"
echo "  SUPER+ESCAPE    Lock screen"
echo "  SUPER+M         Power menu"
echo "  PRINT           Screenshot (area)"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "  1. Log out and log back in (for ZSH)"
if [ "$INSTALL_HYPRLAND" = true ]; then
    echo "  2. Select Hyprland from your login manager"
    echo "  3. Add wallpapers to ~/pictures/wallpapers/"
fi
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
