---
description: 'Project-specific context and conventions for the .dotfiles repository'
applyTo: '**'
---

## Project Overview

This is a personal dotfiles repository for EndeavourOS (Arch-based Linux). It contains:
- Shell configurations (ZSH with zinit)
- Application configs (Neovim, Kitty, Tmux, etc.)
- System automation scripts (SSH, WireGuard, WOL)
- Hyprland setup guide (starting fresh, not HyDe configs)

**Owner**: Ruan Buitendag (@RuanBuitendag42)  
**System**: EndeavourOS (Arch-based)  
**Deployment**: GNU Stow for symlink management

## Repository Structure

```
.dotfiles/
├── config/              # XDG_CONFIG_HOME apps (~/.config/)
│   ├── btop/           # System monitor
│   ├── kitty/          # Terminal (primary)
│   ├── nvim/           # LazyVim-based setup
│   ├── nushell/        # Alternative shell
│   ├── starship/       # Shell prompt
│   ├── tmux/           # Terminal multiplexer
│   └── yazi/           # File manager
├── home/               # Home directory dotfiles (~/)
│   └── .zshrc          # ZSH configuration
├── scripts/            # Automation scripts
│   ├── network/        # SSH, WireGuard, DuckDNS
│   └── system/         # System utilities (empty currently)
├── hyprland/           # Hyprland setup documentation
│   └── README.md       # Fresh Hyprland guide (not HyDe)
├── Makefile            # Main automation interface
├── README.md           # Project overview
├── PROJECT_SETUP.md    # Detailed setup guide
└── TERMINAL_COMPARISON.md  # Kitty vs Ghostty analysis
```

## Key Design Decisions

### 1. Structure Simplification (December 2025)
- **Previous**: Confusing `arch/` and `generic/` split
- **Current**: Clear separation by purpose (`config/`, `home/`, `scripts/`)
- **Rationale**: EndeavourOS IS Arch, no need for distro separation

### 2. Hyprland Approach
- **Previous**: Incomplete HyDe configs in `generic/.config/wip/hypr/`
- **Current**: Clean slate with comprehensive guide in `hyprland/README.md`
- **Rationale**: Start fresh with understanding, not copied configs

### 3. Terminal Choice
- **Primary**: Kitty (currently installed, proven stable)
- **Alternative**: Ghostty (not installed, can test if interested)
- **Config**: Only Kitty config maintained
- **See**: `TERMINAL_COMPARISON.md` for analysis

### 4. Deployment Method
- **Tool**: GNU Stow for symlink management
- **Wrapper**: Makefile for user-friendly interface
- **Method**: 
  - `config/` → `~/.config/` (via stow)
  - `home/` → `~/` (via stow)
  - `scripts/` → `~/.local/bin/` (via cp)

## Configuration Management

### Adding New Configs

When adding a new application config:

1. Place in appropriate location:
   ```bash
   # XDG config apps
   .dotfiles/config/appname/
   
   # Home dotfiles
   .dotfiles/home/.filename
   ```

2. No need to update Makefile - stow handles it automatically

3. Deploy with:
   ```bash
   make install-configs
   # or
   cd config && stow -v -t ~/.config appname
   ```

### Modifying Scripts

All automation scripts in `scripts/network/`:

1. Keep bash scripts with `.sh` extension
2. Include usage documentation in script header
3. Make executable: `chmod +x script.sh`
4. Deploy via: `make install-scripts`

### Makefile Targets

Primary interface for users. Follow conventions:

- **No emoji in code** - Only in output messages
- **Help text** - All targets should have description in `help` target
- **Error handling** - Check for required variables/files
- **Feedback** - Echo what's happening
- **Idempotent** - Safe to run multiple times

## Theme & Styling

**CRITICAL: CATPPUCCIN MACCHIATO EVERYWHERE!** 🎨

This is the MOST important aspect - Macchiato theme must be used in ALL configurations:

- Kitty: Catppuccin Macchiato
- Neovim: LazyVim with Catppuccin Macchiato
- Tmux: Catppuccin Macchiato statusline
- btop: Macchiato theme
- Hyprland: Full Macchiato color scheme
- Waybar: Custom Macchiato theme
- Wofi: Macchiato application launcher
- Dunst: Macchiato notifications
- Swaylock: Macchiato lock screen

**See THEMES.md for complete color palette and implementation details.**

## Important Context

### User Preferences

1. **Theme**: **CATPPUCCIN MACCHIATO EVERYWHERE!** This is CRITICAL - all configs must use Macchiato
2. **Hyprland**: Full configuration ready, not deployed yet
3. **Terminal**: Kitty (23x faster than Ghostty - benchmarked!)
4. **Shell**: ZSH with Starship prompt, not bash
5. **Editor**: Neovim with LazyVim, uses Copilot
6. **Automation**: Loves Makefiles for easy commands

### Pain Points Solved

1. ✅ Confusing directory structure (arch/generic split)
2. ✅ Incomplete Hyprland configs - NOW COMPLETE with Macchiato theme!
3. ✅ No clear documentation
4. ✅ Amateur-ish organization
5. ✅ Kitty vs Ghostty - Kitty wins (benchmarked 23x faster)
6. ✅ Outdated network scripts removed
7. ✅ Theme preferences documented (Macchiato EVERYWHERE!)

## Development Guidelines

### When Editing This Repo

1. **Prefer Makefile targets** over raw commands
2. **Test with stow dry-run** before deploying: `stow -n -v -t ~/.config .`
3. **Backup before changes**: `make backup`
4. **Update docs** if changing structure
5. **Keep scripts portable** - Arch/EndeavourOS compatible

### Shell Script Style

```bash
#!/usr/bin/env bash
# Script: script-name.sh
# Purpose: Brief description
# Usage: ./script-name.sh [args]

set -e  # Exit on error
# ... implementation
```

### Documentation Style

- **README.md**: Overview, quick start, what's included
- **PROJECT_SETUP.md**: Step-by-step fresh install guide
- **Component READMEs**: Specific setup (like hyprland/)
- **Comparison docs**: Analysis and recommendations

## Common Tasks

### Adding a New Config Directory

```bash
# 1. Create in correct location
mkdir -p config/newapp

# 2. Add configs
cp ~/.config/newapp/* config/newapp/

# 3. Deploy
cd config && stow -v -t ~/.config newapp
```

### Testing Changes

```bash
# Always run before committing major changes
make test
make status
```

### Updating After Pull

```bash
git pull origin main
make install
```

## Troubleshooting Patterns

### Stow Conflicts

```bash
# Backup first
make backup

# Remove conflicting files
rm ~/.config/conflicting-file

# Retry
make install-configs
```

### Scripts Not Executable

```bash
# Fix permissions
chmod +x scripts/network/*.sh
make install-scripts
```

## Integration Points

### Neovim
- Config: `config/nvim/`
- Based on: LazyVim
- Plugins: Auto-managed by Lazy.nvim
- Custom: `lua/` directory for overrides

### Tmux
- Config: `config/tmux/tmux.conf`
- Custom modules: `config/tmux/custom_modules/`
- Theme: Catppuccin via TPM

### ZSH
- Config: `home/.zshrc`
- Plugin manager: zinit (auto-installs)
- Theme: Starship (configured in `config/starship/`)

### Kitty
- Config: `config/kitty/kitty.conf`
- Themes: `config/kitty/kitty-themes/` (200+ themes)
- Current: Uses theme from kitty-themes

## Version Control

### What to Commit

✅ Configuration files
✅ Scripts (network/, system/)
✅ Documentation (*.md)
✅ Makefile

❌ `.gitignore` from Neovim (it has its own)
❌ Lazy-lock.json changes (unless intentional)
❌ Backup files (*.old.md, etc.)
❌ Local test files

### Commit Message Style

Following Conventional Commits:

```
feat: add hyprland setup guide
fix: correct stow target paths in Makefile
docs: update README with new structure
refactor: reorganize into config/home/scripts structure
chore: remove incomplete HyDe configs
```

## Future Enhancements

Potential additions:

1. **Hyprland configs** - After following guide and customizing
2. **Ghostty config** - If performance tests are positive
3. **System scripts** - Additional automation in `scripts/system/`
4. **CI/CD** - Automated testing of configs
5. **Installation script** - Single-command full setup

## Notes for Copilot

- User wants aggressive iteration, not stopping for approval
- Prefer implementing over suggesting
- Use Makefile commands in examples
- Remember: EndeavourOS = Arch, no special handling needed
- Hyprland is aspirational, not current setup
- Kitty is primary terminal, Ghostty is optional curiosity
- All automation should be idempotent and safe to re-run

## Repository Maintenance Rules

**CRITICAL: Always clean up after yourself!**

When working on this repository:

1. **Remove temporary files**: Delete any `.md` files created for summaries/notes unless they're core documentation
2. **No summary docs**: Don't create CHANGES.md, SUMMARY.md, RESTRUCTURE.md, etc.
3. **Keep it clean**: Only commit essential files (configs, scripts, main docs)
4. **Check before finishing**: Always run cleanup before marking work complete
5. **Core docs only**: Keep README.md, PROJECT_SETUP.md, THEMES.md, TERMINAL_COMPARISON.md, and component-specific docs

**Files to keep:**
- README.md (main overview)
- PROJECT_SETUP.md (setup guide)
- THEMES.md (Catppuccin Macchiato reference)
- TERMINAL_COMPARISON.md (Kitty vs Ghostty)
- hyprland/README.md (Hyprland guide)
- .github/copilot-instructions.md (this file)

**Files to remove:**
- RESTRUCTURE_SUMMARY.md
- CHANGES.md, UPDATE.md, etc.
- Any temporary notes/summaries
- Backup files (.old, .bak, etc.)
