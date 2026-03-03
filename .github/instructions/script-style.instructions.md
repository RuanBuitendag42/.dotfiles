---
description: 'Bash script conventions, header template, and style rules for automation scripts'
applyTo: 'scripts/**/*.sh'
---

# Bash Script Style Guide

## Shebang & Header Template

Every script MUST start with this header:

```bash
#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Script: script-name.sh
# Purpose: Brief description of what this script does
# Usage: script-name.sh [args]
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -e
```

## Catppuccin Macchiato Terminal Colors

Use these ANSI escape sequences for colored output — they match the Macchiato palette:

```bash
RED='\033[38;2;237;135;150m'    # #ed8796
GREEN='\033[38;2;166;218;149m'  # #a6da95
YELLOW='\033[38;2;238;212;159m' # #eed49f
BLUE='\033[38;2;138;173;244m'   # #8aadf4
MAUVE='\033[38;2;198;160;246m'  # #c6a0f6
TEXT='\033[38;2;202;211;245m'   # #cad3f5
RESET='\033[0m'
```

## Output Helper Functions

Include these for consistent styled output across all scripts:

```bash
step()  { echo -e "${BLUE}━━━▶${RESET} ${TEXT}$1${RESET}"; }
ok()    { echo -e "${GREEN} ✓${RESET} $1"; }
skip()  { echo -e "${YELLOW} ⊘${RESET} $1"; }
warn()  { echo -e "${YELLOW} ⚠${RESET} $1"; }
err()   { echo -e "${RED} ✗${RESET} $1"; }
ask()   { echo -en "${MAUVE} ?${RESET} $1 "; }
```

## Mandatory Rules

- **File extension**: `.sh` required on all scripts
- **Executable bit**: `chmod +x` after creation
- **Deployment**: Via `make install-scripts` ONLY — never copy manually
- **Location**: All scripts go in `scripts/.local/bin/`
- **Error handling**: `set -e` is mandatory at the top of every script
- **Variable quoting**: Always quote variables — `"$var"` not `$var`
- **Conditionals**: Use `[[ ]]` for tests, never `[ ]`
- **Shellcheck**: Compliance recommended — run `shellcheck script.sh` before committing

## Style Rules

- Use lowercase variable names for local variables
- Use UPPERCASE for constants and exported variables
- Use `local` keyword for function-scoped variables
- Prefer `$(command)` over backticks for command substitution
- Use `readonly` for constants that should never change
- Group related functions together with comment headers
- Keep functions focused — one function, one job

## Script Structure

```bash
#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Script: example.sh
# Purpose: Example script structure
# Usage: example.sh [--flag] <argument>
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -e

# ─── Colors ─────────────────────────────────
RED='\033[38;2;237;135;150m'
GREEN='\033[38;2;166;218;149m'
YELLOW='\033[38;2;238;212;159m'
BLUE='\033[38;2;138;173;244m'
MAUVE='\033[38;2;198;160;246m'
TEXT='\033[38;2;202;211;245m'
RESET='\033[0m'

# ─── Helpers ────────────────────────────────
step()  { echo -e "${BLUE}━━━▶${RESET} ${TEXT}$1${RESET}"; }
ok()    { echo -e "${GREEN} ✓${RESET} $1"; }
err()   { echo -e "${RED} ✗${RESET} $1"; }

# ─── Main ───────────────────────────────────
main() {
    step "Doing the thing..."
    # ... implementation
    ok "Done"
}

main "$@"
```

## Common Patterns

### Dependency check
```bash
command -v hyprctl &>/dev/null || { err "hyprctl not found"; exit 1; }
```

### User confirmation
```bash
ask "Continue? [y/N]"
read -r -n 1 reply
echo
[[ "$reply" =~ ^[Yy]$ ]] || { skip "Cancelled"; exit 0; }
```

### Cleanup trap
```bash
cleanup() { rm -f "$tmpfile"; }
trap cleanup EXIT
```
