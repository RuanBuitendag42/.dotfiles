#!/usr/bin/env bash
# Automated dotfiles setup script
# Run this on a fresh EndeavourOS/Arch installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} ${1}"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}!${NC} ${1}"
}

print_error() {
    echo -e "${RED}✗${NC} ${1}"
}

# Check if running on Arch-based system
if ! command -v pacman &> /dev/null; then
    print_error "This script requires an Arch-based distribution (EndeavourOS/Arch Linux)"
    exit 1
fi

print_step "Starting dotfiles setup..."
echo ""

# Update system
print_step "Updating system packages..."
sudo pacman -Syu --noconfirm
print_success "System updated"

# Install yay if not present
if ! command -v yay &> /dev/null; then
    print_step "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    print_success "yay installed"
else
    print_success "yay already installed"
fi

# Install essential packages
print_step "Installing essential packages..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    stow \
    zsh \
    starship \
    eza \
    fzf \
    bat \
    ripgrep \
    fd \
    kitty \
    neovim \
    tmux \
    btop \
    lazygit

yay -S --needed --noconfirm yazi-bin

print_success "Essential packages installed"

# Ask about Hyprland installation
echo ""
read -p "Do you want to install Hyprland? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Installing Hyprland and dependencies..."
    sudo pacman -S --needed --noconfirm \
        hyprland \
        waybar \
        wofi \
        dunst \
        swww \
        grim \
        slurp \
        wl-clipboard \
        cliphist \
        swaylock-effects \
        swayidle \
        xdg-desktop-portal-hyprland \
        polkit-kde-agent \
        thunar \
        thunar-volman \
        thunar-archive-plugin \
        network-manager-applet \
        blueman \
        pavucontrol \
        qt5ct \
        qt6ct \
        kvantum \
        papirus-icon-theme \
        brightnessctl \
        playerctl \
        ttf-jetbrains-mono-nerd \
        ttf-font-awesome \
        noto-fonts-emoji
    
    INSTALL_HYPRLAND=true
    print_success "Hyprland packages installed"
else
    INSTALL_HYPRLAND=false
    print_warning "Skipping Hyprland installation"
fi

# Set ZSH as default shell
print_step "Setting ZSH as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    print_success "ZSH set as default shell (relogin required)"
else
    print_success "ZSH already default shell"
fi

# Deploy dotfiles
print_step "Deploying dotfiles..."

# Backup existing configs
if [ -f ~/.zshrc ] || [ -d ~/.config/nvim ] || [ -d ~/.config/kitty ]; then
    BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    print_warning "Backing up existing configs to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    [ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_DIR/" 2>/dev/null || true
    [ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/" 2>/dev/null || true
    [ -d ~/.config/kitty ] && cp -r ~/.config/kitty "$BACKUP_DIR/" 2>/dev/null || true
    [ -d ~/.config/tmux ] && cp -r ~/.config/tmux "$BACKUP_DIR/" 2>/dev/null || true
    [ -d ~/.config/starship ] && cp -r ~/.config/starship "$BACKUP_DIR/" 2>/dev/null || true
    
    print_success "Backup complete"
fi

# Deploy configs using stow
cd "$HOME/Developer/github/.dotfiles" || cd "$HOME/.dotfiles" || exit 1

print_step "Deploying application configs..."
mkdir -p ~/.config
cd config && stow -v -t ~/.config .
cd ..
print_success "Application configs deployed"

print_step "Deploying home configs..."
cd home && stow -v -t ~ .
cd ..
print_success "Home configs deployed"

# Deploy Hyprland configs if requested
if [ "$INSTALL_HYPRLAND" = true ]; then
    print_step "Deploying Hyprland configs..."
    
    mkdir -p ~/.config/hypr
    cp hyprland/hyprland.conf ~/.config/hypr/
    
    mkdir -p ~/.config/waybar
    cp hyprland/waybar/* ~/.config/waybar/
    
    mkdir -p ~/.config/wofi
    cp hyprland/wofi/* ~/.config/wofi/
    
    mkdir -p ~/.config/dunst
    cp hyprland/dunst/dunstrc ~/.config/dunst/
    
    mkdir -p ~/.config/swaylock
    cp hyprland/swaylock.conf ~/.config/swaylock/config
    
    mkdir -p ~/.local/bin
    cp hyprland/scripts/*.sh ~/.local/bin/
    chmod +x ~/.local/bin/*.sh
    
    mkdir -p ~/Pictures/Wallpapers ~/Pictures/Screenshots
    
    print_success "Hyprland configs deployed"
fi

# Install Neovim plugins
print_step "Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
print_success "Neovim plugins installed"

# Create screenshots directory
mkdir -p ~/Pictures/Screenshots

# Print summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_success "Dotfiles setup complete!"
echo ""
echo "What's been installed:"
echo "  • ZSH with Starship prompt"
echo "  • Kitty terminal (Catppuccin Macchiato theme)"
echo "  • Neovim with LazyVim"
echo "  • Tmux with custom config"
echo "  • Modern CLI tools (eza, fzf, bat, ripgrep, fd)"
echo "  • btop, lazygit, yazi"

if [ "$INSTALL_HYPRLAND" = true ]; then
    echo "  • Hyprland with complete configuration"
    echo "  • Waybar, Wofi, Dunst (all Macchiato themed)"
    echo "  • Swaylock, Swww, screenshot tools"
fi

echo ""
echo "Next steps:"
echo "  1. Log out and log back in (for ZSH shell change)"

if [ "$INSTALL_HYPRLAND" = true ]; then
    echo "  2. Launch Hyprland from TTY by typing: Hyprland"
    echo "  3. Press SUPER+RETURN to open Kitty"
    echo "  4. Press SUPER+D to open application launcher"
else
    echo "  2. Open Kitty and enjoy!"
fi

echo ""
echo "Documentation:"
echo "  • Main README: cat ~/.dotfiles/README.md"
echo "  • Theme guide: cat ~/.dotfiles/THEMES.md"
if [ "$INSTALL_HYPRLAND" = true ]; then
    echo "  • Hyprland keys: cat ~/.dotfiles/hyprland/README.md"
fi
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

print_success "Setup complete! Enjoy your dotfiles! 🎨✨"
