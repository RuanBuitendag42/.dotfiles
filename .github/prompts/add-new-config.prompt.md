---
description: 'Step-by-step workflow for adding a new application config to the dotfiles repo'
agent: 'dotfiles-implementer'
---

# Add New Application Config

Walk me through adding a new application's configuration to this dotfiles repository.

## Steps

1. **Identify the application** — What app are we adding? Where does it store its config (`~/.config/<app>/` or `~/.<file>`)?

2. **Create the directory** — Set up `config/<appname>/` (for XDG apps) or add to `home/` (for home dotfiles).

3. **Add config files** — Copy or create the configuration files. If the app supports theming:
   - Apply Catppuccin Macchiato colors (reference `.github/instructions/THEMES.md`)
   - Use Mauve (#c6a0f6) as default accent

4. **Verify theme compliance** — Hand off to theme-enforcer to audit the new config for Macchiato consistency.

5. **Deploy** — Run `make install-configs` to symlink the new config into place.

6. **Verify deployment** — Run `make status` to confirm symlinks are correct.

7. **Test** — Run `make test` if syntax validation is available for this config format.

8. **Update documentation** — Add the app to the dotfiles-implementer knowledge map if it's a permanent addition.

9. **Commit** — Use conventional commits: `feat: add <appname> config with Macchiato theme`

10. **Push** — `git push` immediately.
