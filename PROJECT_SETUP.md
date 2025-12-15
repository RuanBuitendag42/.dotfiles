# 🚀 Project Setup Instructions

Complete guide for setting up your dotfiles on a fresh EndeavourOS or Arch Linux system.

**Estimated Time**: 30-45 minutes

---

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Initial System Setup](#initial-system-setup)
3. [Install Dependencies](#install-dependencies)
4. [Clone and Deploy Dotfiles](#clone-and-deploy-dotfiles)
5. [Post-Installation](#post-installation)
6. [Optional: Network Services](#optional-network-services)
7. [Optional: Hyprland](#optional-hyprland)
8. [Verification](#verification)
9. [Troubleshooting](#troubleshooting)

---

## System Requirements

- **OS**: EndeavourOS or Arch Linux
- **Internet**: Required for package installation
- **User**: Non-root user with sudo privileges

**Note**: These dotfiles work identically on EndeavourOS and pure Arch Linux.

---

## 1. Initial System Setup

### Update System

```bash
sudo pacman -Syu
```

### Install Base Development Tools

```bash
sudo pacman -S --needed base-devel
```

### Install AUR Helper (yay)

If not already installed:

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
```

---

## 2. Install Dependencies

### Essential Tools

```bash
# Version control and dotfiles management
sudo pacman -S git stow

# Modern shell
sudo pacman -S zsh

# Shell prompt
sudo pacman -S starship

# Modern CLI tools
sudo pacman -S eza fzf bat ripgrep fd

# Terminal emulator
sudo pacman -S kitty

# Text editor
sudo pacman -S neovim

# Terminal multiplexer
sudo pacman -S tmux

# System tools
sudo pacman -S btop lazygit
yay -S yazi-bin
```

### Set ZSH as Default Shell

```bash
chsh -s $(which zsh)
```

**Note**: You'll need to log out and back in for this to take effect.

---

## 3. Clone and Deploy Dotfiles

### Clone Repository

```bash
cd ~
git clone https://github.com/RuanBuitendag42/.dotfiles.git .dotfiles
cd .dotfiles
```

### Backup Existing Configurations (Optional but Recommended)

```bash
make backup
```

This creates a timestamped backup in `~/dotfiles_backup_YYYYMMDD_HHMMSS/`

### Deploy All Configurations

```bash
make install
```

This will:
1. Deploy application configs to `~/.config/`
2. Deploy home dotfiles (`.zshrc`)
3. Install scripts to `~/.local/bin/`

### Alternative: Selective Deployment

```bash
# Just configs
make install-configs

# Just scripts
make install-scripts
```

---

## 4. Post-Installation

### Install Neovim Plugins

```bash
nvim
# LazyVim will automatically install plugins
# Wait for completion, then :q
```

### Install ZSH Plugins

```bash
# Open a new ZSH session
zsh

# zinit will auto-install on first run
# Wait for plugins to install
```

### Test Tmux

```bash
tmux
# Should load with custom config
# Press Ctrl+B then ? for help
```

### Verify Installation

```bash
make status
```

Should show:
```
✅ Kitty
✅ Neovim
✅ Tmux
✅ ZSH
✅ Starship
```

---

## 5. Optional: Network Services

Setup SSH server, WireGuard VPN, and Wake-on-LAN.

### Quick Setup (All Services)

```bash
make setup-network
```

### Individual Setup

#### SSH Server

```bash
make setup-ssh
```

This configures:
- SSH server with security hardening
- Firewall rules
- DuckDNS integration

#### Wake-on-LAN

```bash
make setup-wol
```

Enables WOL for remote system wake.

#### WireGuard VPN Server

```bash
make setup-wireguard
```

Setup VPN server with:
- Key generation
- Server configuration
- Firewall rules

**Generate client config:**
```bash
make generate-wg-client CLIENT=laptop
```

#### DuckDNS Auto-Update

```bash
make add-duckdns-cron
```

Automatically updates your DuckDNS IP address.

---

## 6. Optional: Hyprland

Want to use Hyprland as your Wayland compositor?

### Read the Guide

```bash
cat hyprland/README.md
```

### Quick Hyprland Install

```bash
# Install Hyprland and dependencies
sudo pacman -S hyprland waybar wofi dunst swww grim slurp \
    wl-clipboard cliphist swaylock-effects swayidle \
    xdg-desktop-portal-hyprland

# Follow hyprland/README.md for configuration
```

The guide provides:
- Complete package list
- Minimal starter config
- Customization roadmap
- Troubleshooting tips

---

## 7. Verification

### Test Configurations

```bash
make test
```

### Check Individual Tools

```bash
# ZSH
echo $SHELL  # Should show /usr/bin/zsh

# Starship
starship --version

# Neovim
nvim --version

# Tmux
tmux -V

# Kitty
kitty --version
```

### Verify Symlinks

```bash
ls -la ~/.zshrc          # Should link to .dotfiles/home/.zshrc
ls -la ~/.config/nvim    # Should link to .dotfiles/config/nvim
ls -la ~/.config/kitty   # Should link to .dotfiles/config/kitty
```

### Check PATH

```bash
echo $PATH | grep '.local/bin'
# Should include /home/yourusername/.local/bin
```

---

## 8. Troubleshooting

### Configs Not Loading

**Problem**: New configs don't seem to apply.

**Solution**:
```bash
# Verify symlinks
make status

# Check for stow conflicts
cd ~/.dotfiles/config
stow -n -v -t ~/.config .  # Dry-run to see issues
```

### ZSH Plugins Not Installing

**Problem**: zinit doesn't auto-install plugins.

**Solution**:
```bash
# Manually trigger zinit update
source ~/.zshrc
zi update --all
```

### Neovim Errors

**Problem**: Neovim shows errors on startup.

**Solution**:
```bash
# Check health
nvim +checkhealth

# Reinstall plugins
nvim
:Lazy sync
```

### Scripts Not Found

**Problem**: Scripts in `~/.local/bin` not accessible.

**Solution**:
```bash
# Add to PATH (should already be in .zshrc)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Kitty Font Issues

**Problem**: Kitty shows missing glyphs or wrong fonts.

**Solution**:
```bash
# Install Nerd Fonts
sudo pacman -S ttf-jetbrains-mono-nerd

# Restart Kitty
```

### Tmux Custom Modules Not Working

**Problem**: Custom status modules don't show.

**Solution**:
```bash
# Make sure scripts are executable
chmod +x ~/.config/tmux/custom_modules/*.sh

# Reload tmux config
tmux source-file ~/.config/tmux/tmux.conf
```

### Stow Conflicts

**Problem**: Stow reports conflicts when deploying.

**Solution**:
```bash
# Backup existing files
make backup

# Remove conflicting files
rm ~/.zshrc  # Or whatever file conflicts

# Try again
make install
```

### Permission Denied on Scripts

**Problem**: Scripts in `scripts/network/` won't execute.

**Solution**:
```bash
# Make all scripts executable
chmod +x ~/.dotfiles/scripts/network/*.sh
chmod +x ~/.local/bin/*.sh
```

---

## 🎯 Next Steps

After successful setup:

1. **Customize**:
   - Edit `~/.config/kitty/kitty.conf` for terminal preferences
   - Modify `~/.config/starship/starship.toml` for prompt
   - Adjust `~/.zshrc` for shell aliases

2. **Explore**:
   - Try different Kitty themes (200+ included!)
   - Configure Neovim with `:Lazy`
   - Customize tmux status bar

3. **Optional Features**:
   - Setup Hyprland (see `hyprland/README.md`)
   - Configure network services
   - Test Ghostty terminal (see `TERMINAL_COMPARISON.md`)

4. **Stay Updated**:
   ```bash
   cd ~/.dotfiles
   git pull origin main
   make install
   ```

---

## 📚 Additional Resources

- **README.md** - Quick overview and usage
- **hyprland/README.md** - Hyprland setup guide
- **TERMINAL_COMPARISON.md** - Kitty vs Ghostty
- **Makefile** - Run `make help` for commands

---

## 🐛 Known Issues

### Issue: Kitty themes not loading

**Workaround**: Check theme path in `kitty.conf` points to correct location.

### Issue: Starship slow on large git repos

**Workaround**: Disable git status in starship.toml or use `starship config git_status.disabled true`.

---

## 💡 Pro Tips

1. **Quick config edits**:
   ```bash
   alias nvconf='nvim ~/.config/nvim/init.lua'
   alias zshconf='nvim ~/.zshrc'
   ```

2. **Tmux sessions**:
   ```bash
   # Create named session
   tmux new -s dev
   
   # Attach to session
   tmux attach -t dev
   ```

3. **Test configs before deploying**:
   ```bash
   # Dry-run stow
   cd ~/.dotfiles/config
   stow -n -v -t ~/.config .
   ```

4. **Keep dotfiles in sync**:
   ```bash
   # After making changes
   cd ~/.dotfiles
   git add .
   git commit -m "Update config"
   git push
   ```

---

## ✅ Checklist

Use this to track your setup progress:

- [ ] System updated
- [ ] AUR helper installed
- [ ] Essential packages installed
- [ ] ZSH set as default shell
- [ ] Dotfiles cloned
- [ ] Configs deployed
- [ ] Neovim plugins installed
- [ ] ZSH plugins loaded
- [ ] Tmux working
- [ ] All tests passing
- [ ] Optional: Network services configured
- [ ] Optional: Hyprland installed

---

**Setup complete! Enjoy your development environment! 🎉**

For questions or issues, check the [README.md](README.md) or open an issue on GitHub.
