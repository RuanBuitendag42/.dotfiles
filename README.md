# 🎨 .dotfiles

> Personal development environment for EndeavourOS (Arch-based Linux)

Clean, organized, and automated dotfiles managed with GNU Stow. Focus on modern CLI tools, efficient workflows, and easy setup.

---

## 📁 Repository Structure

```
.dotfiles/
├── config/              # Application configurations (~/.config/)
│   ├── btop/           # System monitor (Catppuccin themes)
│   ├── kitty/          # Terminal emulator (200+ themes)
│   ├── nvim/           # Neovim (LazyVim-based)
│   ├── nushell/        # Modern shell
│   ├── starship/       # Shell prompt
│   ├── tmux/           # Terminal multiplexer
│   └── yazi/           # File manager
│
├── home/               # Home directory files (~/)
│   └── .zshrc          # ZSH configuration
│
├── scripts/            # Automation scripts
│   ├── network/        # SSH, WireGuard, DuckDNS
│   └── system/         # System utilities
│
├── hyprland/           # Hyprland setup guide
│   └── README.md       # Fresh Hyprland installation guide
│
├── Makefile            # Automation commands
├── README.md           # This file
├── PROJECT_SETUP.md    # Detailed setup instructions
└── TERMINAL_COMPARISON.md  # Kitty vs Ghostty analysis
```

---

## 🚀 Quick Start

### Automated Setup (Recommended)

**One command to set up everything on a fresh system:**

```bash
# Clone repository
cd ~
git clone https://github.com/RuanBuitendag42/.dotfiles.git .dotfiles
cd .dotfiles

# Run automated setup
./setup.sh
```

The setup script will:
- ✅ Update system packages
- ✅ Install yay AUR helper
- ✅ Install all dependencies
- ✅ Optionally install Hyprland
- ✅ Set ZSH as default shell
- ✅ Deploy all configurations
- ✅ Install Neovim plugins
- ✅ Backup existing configs

### Manual Setup

If you prefer manual control:

```bash
# 1. Install prerequisites
sudo pacman -S git stow zsh

# 2. Clone repository
cd ~
git clone https://github.com/RuanBuitendag42/.dotfiles.git .dotfiles
cd .dotfiles

# 3. Deploy configurations
make install
```

### 4. Optional: System Setup

```bash
# Network services (SSH, WireGuard, Wake-on-LAN)
make setup-network

# Or individually:
make setup-ssh
make setup-wol
make setup-wireguard
```

---

## 🛠️ What's Included

### 🐚 Shell & Terminal

**ZSH** - Modern shell configuration
- Plugin manager: zinit
- Auto-suggestions, syntax highlighting, completions
- fzf integration for fuzzy finding
- History management

**Starship** - Fast, customizable prompt
- Git status integration
- Directory truncation
- Command duration display

**Kitty** - GPU-accelerated terminal
- 200+ themes included
- Ligature support
- Fast rendering
- Tmux integration

### ⚙️ Development Tools

**Neovim** - Modern text editor
- Based on LazyVim distribution
- LSP support for multiple languages
- GitHub Copilot integration
- Tmux navigation keybindings
- Arduino development support

**Tmux** - Terminal multiplexer
- Custom status modules (CPU, memory, IP)
- Catppuccin theme
- Vim-style navigation
- Session management

### 📊 System Tools

**btop** - System monitor with Catppuccin themes  
**yazi** - Modern terminal file manager  
**Nushell** - Alternative shell with structured data

### 🎨 Theming

All configurations use **Catppuccin** color scheme for consistency:
- btop themes
- Kitty colorschemes
- Tmux statusline

---

## 📖 Makefile Commands

Run `make help` for full list. Common commands:

```bash
make install         # Deploy all configs and scripts
make install-configs # Deploy application configs only
make setup-network   # Configure SSH + WireGuard + WOL
make test           # Test configuration validity
make status         # Show deployment status
make backup         # Backup existing configs
make clean          # Remove deployed symlinks
```

### Network Automation

```bash
make setup-ssh              # Setup SSH server
make setup-wol              # Configure Wake-on-LAN
make setup-wireguard        # Setup WireGuard VPN server
make generate-wg-client CLIENT=laptop  # Generate WireGuard client config
make update-duckdns         # Update DuckDNS IP
make add-duckdns-cron       # Add DuckDNS auto-update cron
```

---

## 🖥️ Hyprland Setup

Want to use Hyprland as your window manager? Check out the comprehensive guide:

```bash
cat hyprland/README.md
```

The guide includes:
- Fresh installation steps (not HyDe configs)
- Complete package list
- Minimal starter configuration
- Waybar setup
- Customization roadmap

---

## 🎯 EndeavourOS vs Pure Arch

**You don't need pure Arch!** EndeavourOS is 100% compatible with these dotfiles:

- ✅ Same package manager (pacman/yay)
- ✅ Same AUR access
- ✅ Same config locations
- ✅ Better hardware support out-of-box
- ✅ More stable base

These dotfiles work identically on both distributions.

---

## 📦 Installation Methods

### Method 1: Using Makefile (Recommended)

```bash
cd ~/.dotfiles
make install
```

### Method 2: Manual with GNU Stow

```bash
# Deploy configs
cd ~/.dotfiles/config
stow -v -t ~/.config .

# Deploy home files
cd ~/.dotfiles/home
stow -v -t ~ .

# Install scripts
mkdir -p ~/.local/bin
cp scripts/network/*.sh ~/.local/bin/
chmod +x ~/.local/bin/*.sh
```

### Method 3: Selective Deployment

```bash
# Deploy only specific configs
cd ~/.dotfiles/config
stow -v -t ~/.config nvim    # Just Neovim
stow -v -t ~/.config kitty   # Just Kitty
stow -v -t ~/.config tmux    # Just Tmux
```

---

## 🔧 Configuration Details

### ZSH Setup

Located: `home/.zshrc`

Features:
- zinit plugin manager
- Auto-suggestions & completions
- Syntax highlighting
- fzf-tab for fuzzy completion
- Custom aliases and functions

### Neovim Setup

Located: `config/nvim/`

Based on LazyVim with custom plugins:
- LSP support (TypeScript, Python, Lua, etc.)
- GitHub Copilot integration
- Tmux navigation
- Arduino development
- Custom keybindings

### Kitty Terminal

Located: `config/kitty/`

Features:
- 200+ themes in `kitty-themes/`
- Font: JetBrainsMono Nerd Font
- Ligature support
- GPU acceleration
- Tab management

### Tmux Configuration

Located: `config/tmux/`

Features:
- Custom status modules in `custom_modules/`
- Catppuccin theme
- Vim-style keybindings
- Session persistence
- Mouse support

---

## 🤖 Automation Scripts

All scripts located in `scripts/network/`:

### SSH Server
- `setup-ssh-server.sh` - Configure SSH server with security
- `setup-wol.sh` - Enable Wake-on-LAN

### DuckDNS Integration
- `update-duckdns.sh` - Update your DuckDNS IP
- `add-duckdns-cron.sh` - Auto-update via cron
- `remove-duckdns-cron.sh` - Remove cron job

### WireGuard VPN
- `setup.sh` - Setup WireGuard server
- `generate-keys.sh` - Generate client keys
- `update-wg-config.sh` - Update server config
- `client-template.conf` - Client config template

---

## 🔍 Troubleshooting

### Configs not loading?

```bash
# Check symlinks
make status

# Verify deployment
ls -la ~/.config/nvim
ls -la ~/.zshrc
```

### Scripts not in PATH?

```bash
# Add to PATH if needed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Stow conflicts?

```bash
# Backup existing configs first
make backup

# Then try again
make install
```

### Want to test before deploying?

```bash
make test
```

---

## 📚 Additional Documentation

- **[PROJECT_SETUP.md](PROJECT_SETUP.md)** - Complete setup guide for fresh systems
- **[hyprland/README.md](hyprland/README.md)** - Hyprland installation and configuration
- **[TERMINAL_COMPARISON.md](TERMINAL_COMPARISON.md)** - Kitty vs Ghostty analysis

---

## 🎨 Customization Tips

### Change Theme

Kitty has 200+ themes:
```bash
# Browse themes
ls ~/.config/kitty/kitty-themes/themes/

# Change theme in kitty.conf
vim ~/.config/kitty/kitty.conf
# Update: include ./kitty-themes/themes/theme-name.conf
```

### Modify Starship Prompt

```bash
vim ~/.config/starship/starship.toml
```

### Customize Tmux

```bash
vim ~/.config/tmux/tmux.conf
```

---

## 🤝 Contributing

This is a personal dotfiles repo, but feel free to:
- Fork and adapt for your own use
- Open issues for questions
- Share improvements via pull requests

---

## 📝 License

MIT - Use however you like!

---

## 🙏 Acknowledgments

- **LazyVim** - Neovim distribution
- **Catppuccin** - Color scheme
- **Starship** - Shell prompt
- **Kitty** - Terminal emulator
- EndeavourOS community

---

## 📞 Contact

- GitHub: [@RuanBuitendag42](https://github.com/RuanBuitendag42)
- Email: ruan@minm.co.za

---

**Enjoy your dotfiles! 🚀**
