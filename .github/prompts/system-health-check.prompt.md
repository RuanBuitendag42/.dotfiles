---
description: 'Comprehensive system health check — deployment status, package drift, orphans, theme consistency'
agent: 'dotfiles-orchestrator'
---

# System Health Check

Run a comprehensive health check across the entire dotfiles system and report findings.

## Checks to Perform

1. **Deployment Status** — Run `make status` to verify all symlinks are intact and configs are properly deployed.

2. **Config Syntax** — Run `make test` to check for syntax errors in configuration files.

3. **Package Drift** — Run `make packages-diff` to detect packages that are installed but untracked, or tracked but uninstalled.

4. **Orphan Packages** — Run `make orphans` (dry-run) to identify packages no longer needed by any installed package.

5. **Theme Consistency** — Hand off to theme-enforcer to audit all configs for Catppuccin Macchiato compliance. Report any violations.

6. **Git Status** — Check for uncommitted changes, unpushed commits, and stale branches. Remind about the February 2026 rule.

7. **Stable Tags** — Check when the last `stable-*` tag was created. Recommend tagging if it's been a while.

## Report Format

Compile all findings into a structured health report:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  System Health Report — YYYY-MM-DD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Deployment:  ✅ OK / ⚠️ Issues found
  Syntax:      ✅ OK / ⚠️ Errors
  Packages:    ✅ Synced / ⚠️ Drift detected
  Orphans:     ✅ None / ⚠️ N orphans
  Theme:       ✅ Consistent / ⚠️ Violations
  Git:         ✅ Clean / ⚠️ Uncommitted
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Include detailed findings for any non-OK items.
