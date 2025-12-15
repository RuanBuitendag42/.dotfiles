# Makefile for dotfiles automation
# EndeavourOS / Arch Linux

.PHONY: help install install-configs install-scripts setup-network setup-all test clean

# Default target
help:
	@echo "📦 Dotfiles Management"
	@echo ""
	@echo "Available targets:"
	@echo "  make install         - Deploy all configs"
	@echo "  make install-configs - Deploy application configs"
	@echo "  make test           - Test configuration validity"
	@echo "  make status         - Check deployment status"
	@echo "  make backup         - Backup existing configs"
	@echo "  make clean          - Remove deployed symlinks"
	@echo ""

# Install everything
install: install-configs
	@echo "✅ All configurations deployed!"

# Deploy application configs using GNU Stow
install-configs:
	@echo "📁 Deploying application configs..."
	@mkdir -p ~/.config
	@cd config && stow -v -t ~/.config .
	@echo "🏠 Deploying home configs..."
	@cd home && stow -v -t ~ .
	@echo "🔧 Deploying scripts..."
	@cd scripts && stow -v -t ~ .
	@echo "✅ Configs deployed!"

# Test configurations
test:
	@echo "🧪 Testing configurations..."
	@echo "Checking ZSH config..."
	@zsh -n home/.zshrc && echo "  ✅ .zshrc syntax OK" || echo "  ❌ .zshrc has errors"
	@echo "Checking tmux config..."
	@tmux -f config/tmux/tmux.conf list-keys > /dev/null && echo "  ✅ tmux.conf OK" || echo "  ❌ tmux.conf has errors"
	@echo "Checking Neovim config..."
	@nvim --headless +checkhealth +qa && echo "  ✅ Neovim config OK" || echo "  ⚠️  Check Neovim manually"

# Clean up deployed configs
clean:
	@echo "🧹 Removing deployed configurations..."
	@echo "⚠️  This will remove symlinks from ~ and ~/.config"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd config && stow -D -v -t ~/.config . || true; \
		cd home && stow -D -v -t ~ . || true; \
		cd scripts && stow -D -v -t ~ . || true; \
		echo "✅ Symlinks removed!"; \
	else \
		echo "❌ Cancelled"; \
	fi

# Backup current configs before installing
backup:
	@echo "💾 Backing up existing configs..."
	@mkdir -p ~/dotfiles_backup_$$(date +%Y%m%d_%H%M%S)
	@[ -f ~/.zshrc ] && cp -v ~/.zshrc ~/dotfiles_backup_$$(date +%Y%m%d_%H%M%S)/ || true
	@[ -d ~/.config/nvim ] && cp -rv ~/.config/nvim ~/dotfiles_backup_$$(date +%Y%m%d_%H%M%S)/ || true
	@[ -d ~/.config/kitty ] && cp -rv ~/.config/kitty ~/dotfiles_backup_$$(date +%Y%m%d_%H%M%S)/ || true
	@[ -d ~/.config/tmux ] && cp -rv ~/.config/tmux ~/dotfiles_backup_$$(date +%Y%m%d_%H%M%S)/ || true
	@echo "✅ Backup complete!"

# Update dotfiles from remote
update:
	@echo "🔄 Updating dotfiles..."
	@git pull origin main
	@echo "✅ Dotfiles updated!"

# Show current configuration status
status:
	@echo "📊 Dotfiles Status"
	@echo ""
	@echo "Repository: $$(git remote get-url origin 2>/dev/null || echo 'No remote')"
	@echo "Branch: $$(git branch --show-current)"
	@echo "Last commit: $$(git log -1 --pretty=format:'%h - %s (%cr)' 2>/dev/null || echo 'No commits')"
	@echo ""
	@echo "Deployed configs:"
	@ls -la ~/.config/kitty/kitty.conf 2>/dev/null && echo "  ✅ Kitty" || echo "  ❌ Kitty"
	@ls -la ~/.config/nvim/init.lua 2>/dev/null && echo "  ✅ Neovim" || echo "  ❌ Neovim"
	@ls -la ~/.config/tmux/tmux.conf 2>/dev/null && echo "  ✅ Tmux" || echo "  ❌ Tmux"
	@ls -la ~/.zshrc 2>/dev/null && echo "  ✅ ZSH" || echo "  ❌ ZSH"
	@ls -la ~/.config/starship/starship.toml 2>/dev/null && echo "  ✅ Starship" || echo "  ❌ Starship"
