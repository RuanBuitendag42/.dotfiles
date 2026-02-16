tfenv (managed via dotfiles)

This directory is a placeholder for `tfenv` user installation. Use the installer script in `scripts/.local/bin/install-tfenv.sh` to clone and install `tfenv` into `~/.tfenv` and symlink the `tfenv` binary into `~/.local/bin`.

Install:

```bash
# deploy scripts via stow/make (repo convention), then:
~/scripts/.local/bin/install-tfenv.sh
```

Uninstall:

```bash
~/scripts/.local/bin/uninstall-tfenv.sh
```

Notes:
- `tfenv` is a git-based Terraform version manager (https://github.com/tfutils/tfenv).
- Ensure `~/.local/bin` is in your `PATH` so the `tfenv` command is available.
- You can manage this via your usual `make install` / `stow` workflow.
