---
description: 'Detect package drift between installed system and saved package lists'
agent: 'package-manager'
---

# Package Drift Check

Detect and report any drift between the currently installed packages and the saved package lists.

## Steps

1. **Run drift detection**
   ```bash
   make packages-diff
   ```

2. **Categorize drift** — Sort findings into:
   - **Added**: Packages installed on the system but NOT in `packages/pacman.txt` or `packages/aur.txt`
   - **Removed**: Packages listed in the files but NOT installed on the system

3. **Check for orphans**
   ```bash
   make orphans
   ```
   Report any packages that are no longer required by any installed package.

4. **Recommend action**
   - If drift is intentional (user installed new packages): suggest `make packages-save`
   - If drift is accidental (packages removed unexpectedly): suggest reinstalling
   - If orphans found: suggest reviewing and removing with `pacman -Rns`

5. **Remind to commit** — After running `make packages-save`:
   ```bash
   git add packages/pacman.txt packages/aur.txt
   git commit -m "chore: update package lists to match installed state"
   git push
   ```

## Report Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Package Drift Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Native (pacman): +N added / -N removed
  AUR (yay):       +N added / -N removed
  Orphans:         N found
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

List each package name under its category for review.
