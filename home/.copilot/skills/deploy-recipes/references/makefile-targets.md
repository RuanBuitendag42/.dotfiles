# Makefile Targets for Team Management

How to add Makefile targets to manage Copilot agent teams in the dotfiles repo.

## Standard Targets

### Install Genesis
```makefile
install-genesis:
	@echo "Deploying Agent Genesis..."
	@make install-configs
	@echo "Genesis deployed! Check VS Code agent dropdown."
```

### Genesis Status
```makefile
genesis-status:
	@echo "Genesis Agent Registry"
	@echo "======================"
	@echo ""
	@echo "Agents:"
	@ls -1 config/Code/User/prompts/*.agent.md 2>/dev/null | xargs -I{} basename {} | sed 's/^/  /'
	@echo ""
	@echo "Skills:"
	@ls -1d config/Code/User/prompts/genesis-skills/*/ 2>/dev/null | xargs -I{} basename {} | sed 's/^/  /'
	@echo ""
	@echo "Instructions:"
	@ls -1 config/Code/User/prompts/*.instructions.md 2>/dev/null | xargs -I{} basename {} | sed 's/^/  /'
	@echo ""
	@echo "Deployed to: ~/.config/Code/User/prompts/"
	@echo "Symlink status:"
	@ls -la ~/.config/Code/User/prompts/*.agent.md 2>/dev/null | tail -5
```

### Validate Genesis
```makefile
genesis-validate:
	@echo "Validating Genesis deployment..."
	@bash config/Code/User/prompts/genesis-skills/deploy-recipes/scripts/validate-deploy.sh
```

## Adding to Help Target

```makefile
help:
	@echo "Genesis:"
	@echo "  make install-genesis   Deploy Agent Genesis to VS Code"
	@echo "  make genesis-status    Show deployed agents and skills"
	@echo "  make genesis-validate  Validate deployment structure"
```

## Integration Pattern

Add these targets to the existing Makefile, grouped under a "Genesis" section. They should use the existing `install-configs` target as the core deployment mechanism.
