# Makefile for dotfiles automation
# EndeavourOS / Arch Linux

.PHONY: help install install-configs install-scripts backup status test clean update migrate

# Default target
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Deployment:"
	@echo "  make install          Deploy all configs, scripts, and home dotfiles"
	@echo "  make install-configs  Deploy ~/.config/ application configs only"
	@echo "  make install-scripts  Deploy ~/.local/bin/ scripts only"
	@echo "  make install-home     Deploy home dotfiles (~/.zshrc, etc.)"
	@echo ""
	@echo "Maintenance:"
	@echo "  make backup           Backup existing configs before deploying"
	@echo "  make status           Show deployment status"
	@echo "  make test             Test configuration syntax"
	@echo "  make update           Pull latest from remote"
	@echo "  make clean            Remove deployed symlinks"
	@echo ""
	@echo "System:"
	@echo "  make migrate          Run system cleanup/migration script"
	@echo "  make orphans          Remove orphan packages"
	@echo ""

# ─── Deployment ─────────────────────────────────────────────────

install: install-configs install-home install-scripts
	@echo "All configurations deployed!"

install-configs:
	@echo "Deploying application configs to ~/.config/..."
	@mkdir -p ~/.config
	@cd config && stow -v -t ~/.config .
	@echo "Configs deployed!"

install-home:
	@echo "Deploying home dotfiles..."
	@cd home && stow -v -t ~ .
	@echo "Home dotfiles deployed!"

install-scripts:
	@echo "Deploying scripts to ~/.local/bin/..."
	@mkdir -p ~/.local/bin
	@cd scripts && stow -v -t ~ .
	@chmod +x ~/.local/bin/*.sh 2>/dev/null || true
	@echo "Scripts deployed!"

# ─── Maintenance ────────────────────────────────────────────────

backup:
	@BACKUP_DIR=~/dotfiles_backup_$$(date +%Y%m%d_%H%M%S); \
	echo "Backing up existing configs to $$BACKUP_DIR..."; \
	mkdir -p "$$BACKUP_DIR"; \
	[ -f ~/.zshrc ] && cp -v ~/.zshrc "$$BACKUP_DIR/" || true; \
	for dir in nvim kitty tmux starship hypr waybar wofi dunst swaylock btop yazi; do \
		[ -d "$$HOME/.config/$$dir" ] && cp -rv "$$HOME/.config/$$dir" "$$BACKUP_DIR/" || true; \
	done; \
	echo "Backup complete: $$BACKUP_DIR"

status:
	@echo "Dotfiles Status"
	@echo ""
	@echo "Repository: $$(git remote get-url origin 2>/dev/null || echo 'No remote')"
	@echo "Branch: $$(git branch --show-current)"
	@echo "Last commit: $$(git log -1 --pretty=format:'%h - %s (%cr)' 2>/dev/null || echo 'No commits')"
	@echo ""
	@echo "Deployed configs:"
	@[ -L ~/.config/kitty/kitty.conf ] && echo "  Kitty (symlinked)" || ([ -f ~/.config/kitty/kitty.conf ] && echo "  Kitty (file, not linked)" || echo "  Kitty (missing)")
	@[ -L ~/.config/nvim/init.lua ] && echo "  Neovim (symlinked)" || ([ -f ~/.config/nvim/init.lua ] && echo "  Neovim (file, not linked)" || echo "  Neovim (missing)")
	@[ -L ~/.config/tmux/tmux.conf ] && echo "  Tmux (symlinked)" || ([ -f ~/.config/tmux/tmux.conf ] && echo "  Tmux (file, not linked)" || echo "  Tmux (missing)")
	@[ -L ~/.config/starship/starship.toml ] && echo "  Starship (symlinked)" || ([ -f ~/.config/starship/starship.toml ] && echo "  Starship (file, not linked)" || echo "  Starship (missing)")
	@[ -L ~/.config/hypr/hyprland.conf ] && echo "  Hyprland (symlinked)" || ([ -f ~/.config/hypr/hyprland.conf ] && echo "  Hyprland (file, not linked)" || echo "  Hyprland (missing)")
	@[ -L ~/.config/waybar/config ] && echo "  Waybar (symlinked)" || ([ -f ~/.config/waybar/config ] && echo "  Waybar (file, not linked)" || echo "  Waybar (missing)")
	@[ -L ~/.config/wofi/config ] && echo "  Wofi (symlinked)" || ([ -f ~/.config/wofi/config ] && echo "  Wofi (file, not linked)" || echo "  Wofi (missing)")
	@[ -L ~/.config/dunst/dunstrc ] && echo "  Dunst (symlinked)" || ([ -f ~/.config/dunst/dunstrc ] && echo "  Dunst (file, not linked)" || echo "  Dunst (missing)")
	@[ -L ~/.zshrc ] && echo "  ZSH (symlinked)" || ([ -f ~/.zshrc ] && echo "  ZSH (file, not linked)" || echo "  ZSH (missing)")
	@echo ""
	@echo "Scripts:"
	@ls -1 ~/.local/bin/*.sh 2>/dev/null | while read f; do echo "  $$(basename $$f)"; done || echo "  No scripts deployed"

test:
	@echo "Testing configurations..."
	@echo "Checking ZSH syntax..."
	@zsh -n home/.zshrc 2>/dev/null && echo "  .zshrc OK" || echo "  .zshrc has errors"
	@echo "Checking Hyprland config..."
	@hyprctl keyword debug:disable_logs true 2>/dev/null && echo "  Hyprland OK (live)" || echo "  Hyprland not running (cannot test live)"
	@echo "Tests complete"

clean:
	@echo "Removing deployed symlinks..."
	@echo "This will unlink (not delete) configs from ~ and ~/.config"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [ "$$REPLY" = "y" ] || [ "$$REPLY" = "Y" ]; then \
		cd config && stow -D -v -t ~/.config . 2>/dev/null || true; \
		cd ../home && stow -D -v -t ~ . 2>/dev/null || true; \
		cd ../scripts && stow -D -v -t ~ . 2>/dev/null || true; \
		echo "Symlinks removed!"; \
	else \
		echo "Cancelled"; \
	fi

update:
	@echo "Updating dotfiles..."
	@git pull origin main
	@echo "Dotfiles updated - run 'make install' to deploy"

# ─── System ─────────────────────────────────────────────────────

migrate:
	@echo "Running system migration..."
	@bash ./migrate.sh
	@echo "Migration complete!"

orphans:
	@echo "Checking for orphan packages..."
	@if pacman -Qdtq > /dev/null 2>&1; then \
		echo "Orphan packages found:"; \
		pacman -Qdtq; \
		echo ""; \
		read -p "Remove all orphans? [y/N] " -n 1 -r; \
		echo; \
		if [ "$$REPLY" = "y" ] || [ "$$REPLY" = "Y" ]; then \
			sudo pacman -Rns $$(pacman -Qdtq); \
		fi; \
	else \
		echo "No orphan packages found!"; \
	fi
