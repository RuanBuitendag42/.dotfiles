---
name: team-registry
description: 'Living registry of all agent teams created by Genesis — tracks capabilities, locations, and evolution history'
---

# Genesis Team Registry

This registry is automatically maintained by Agent Genesis. It tracks all teams created, their locations, and evolution history. Read this skill to check what teams exist. Update this skill after creating or evolving a team.

## Registry Schema

Each team entry follows this format:

```
### Team: [Team Name]
- **Version**: [semver]
- **Created**: [YYYY-MM-DD]
- **Last Evolved**: [YYYY-MM-DD]
- **Location**: [global | project path]
- **Template Source**: [template name | custom]
- **Agents**: [list of agent files]
- **Skills**: [list of skill folders]
- **Instructions**: [list of instruction files]
- **Prompts**: [list of prompt files]
- **MCP Servers**: [list of MCP servers added]
- **Evolution Notes**: [what changed and why]
- **Performance Notes**: [user feedback, improvements]
```

---

## Teams

### Team: Dotfiles & System Management (未来侍 Edition)
- **Version**: 2.0.0
- **Created**: 2026-03-03
- **Last Evolved**: 2026-03-04
- **Location**: project — `/home/ruanb/Developer/github/.dotfiles/.github/`
- **Template Source**: Dotfiles/System Team (consolidated)
- **Agents** (6):
  - `dotfiles-orchestrator.agent.md` — Master coordinator, read-only, delegates via runSubagent with routing decision tree
  - `dotfiles-implementer.agent.md` — General-purpose file editor/creator for ALL config, script, docs, and skill files
  - `dotfiles-researcher.agent.md` — Read-only research specialist with awesome-* repo references and MCP tools
  - `hyprland-engineer.agent.md` — Hyprland DE stack specialist (compositor, waybar, wofi, dunst, animations)
  - `theme-enforcer.agent.md` — Read-only Catppuccin Macchiato consistency auditor
  - `system-ops.agent.md` — Merged: deployment (Makefile/stow), packages (pacman/AUR), git ops, backups
- **Removed Agents** (5, consolidated into implementer + system-ops):
  - ~~config-manager~~ → dotfiles-implementer
  - ~~script-builder~~ → dotfiles-implementer
  - ~~setup-deployer~~ → system-ops
  - ~~package-manager~~ → system-ops
  - ~~backup-guardian~~ → system-ops
- **Skills**: None (team uses instruction files for scoped domain rules)
- **Instructions**:
  - `catppuccin-enforcement.instructions.md` — Macchiato palette reference and rules (applyTo: config/**)
  - `stow-deployment-rules.instructions.md` — Stow + Makefile conventions (applyTo: Makefile, setup.sh, scripts/**)
  - `commit-discipline.instructions.md` — Conventional commits and push discipline (applyTo: **)
  - `script-style.instructions.md` — Bash script conventions and samurai template (applyTo: scripts/**/*.sh)
  - `hyprland-conventions.instructions.md` — Hyprland 0.53+ patterns (applyTo: config/hypr/**, config/waybar/**, etc.)
  - `package-tracking.instructions.md` — Package list management (applyTo: packages/**)
- **Prompts**:
  - `add-new-config.prompt.md` — Add new app config workflow → dotfiles-implementer
  - `system-health-check.prompt.md` — Full system health report → dotfiles-orchestrator
  - `fresh-install-guide.prompt.md` — Fresh Arch install walkthrough → system-ops
  - `theme-audit.prompt.md` — Macchiato compliance scan → theme-enforcer
  - `package-drift-check.prompt.md` — Package drift detection → system-ops
- **MCP Servers**: None added (uses existing fetch, github, context7)
- **Evolution Notes**:
  - v2.0.0 — **Major redesign.** Consolidated 9 over-specialized agents to 6. Added `dotfiles-implementer` (general-purpose file editor — the biggest gap in v1.x). Merged `setup-deployer` + `package-manager` + `backup-guardian` into `system-ops`. Removed `config-manager` and `script-builder` (absorbed by implementer). Updated all tool references to wildcard patterns. Updated all handoff references across agents and prompts. Orchestrator rewritten with clear routing: "if it involves editing a file and it's NOT Hyprland stack, invoke dotfiles-implementer."
  - v1.1.0 — Added dotfiles-researcher, rewrote orchestrator with runSubagent delegation mechanics
  - v1.0.0 — Initial build with 8 agents
- **Performance Notes**: v1.x orchestrator couldn't delegate implementation tasks — no general-purpose editor agent existed. v2.0 fixes this with dedicated implementer and cleaner routing.

---

## Learned Templates

_Templates learned from successful custom team builds will appear here._

---

## Statistics

- **Total Teams Created**: 1
- **Total Agents Generated**: 6 (active), 14 (lifetime including retired)
- **Total Skills Created**: 9
- **Last Activity**: 2026-03-04
