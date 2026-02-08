# 🎨 .dotfiles

> Personal development environment for Arch Linux

Clean, organized, and automated dotfiles managed with GNU Stow. Full system reproducibility with package lists, Hyprland DE, and Catppuccin Macchiato everywhere.

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
**lazydocker** - Docker TUI

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
make install-home    # Deploy home dotfiles only
make install-scripts # Deploy scripts only
make packages-save   # Save installed packages to repo
make packages-diff   # Show diff between installed and saved
make test           # Test configuration validity
make status         # Show deployment status
make backup         # Backup existing configs
make clean          # Remove deployed symlinks
make orphans        # Remove orphan packages
```

---

## 🖥️ Hyprland DE

Hyprland is the active window manager, fully configured with Catppuccin Macchiato:

- **Hyprland** + Hypridle + Hyprlock
- **Waybar** with Japanese kanji workspace icons (一二三四五六七八九十)
- **Wofi** launcher, **Dunst** notifications
- **Swaylock** with blur effects
- **Scripts**: Power menu, wallpaper manager, resolution switcher

See [HYPRLAND.md](HYPRLAND.md) for key bindings and configuration details.

---

## 🎯 Arch Linux Compatibility

These dotfiles target **pure Arch Linux**. The package lists in `packages/` contain only
standard Arch and AUR packages — no distro-specific dependencies.

- ✅ Works on pure Arch, EndeavourOS, or any Arch-based distro
- ✅ `setup.sh` handles full system setup from scratch
- ✅ `make packages-save` / `make packages-diff` for package tracking

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

# Deploy scripts
cd ~/.dotfiles/scripts
stow -v -t ~ .
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

All scripts deployed to `~/.local/bin/` via stow:

- `powermenu.sh` - Wofi-based power menu (lock, logout, suspend, reboot, shutdown)
- `wallpaper.sh` - Random wallpaper setter (swww)
- `resolution.sh` - Quick resolution switcher

Deploy with `make install-scripts`.

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
- **[HYPRLAND.md](HYPRLAND.md)** - Hyprland configuration and key bindings
- **[THEMES.md](THEMES.md)** - Catppuccin Macchiato color reference
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
