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
- **Version**: 1.1.0
- **Created**: 2026-03-03
- **Last Evolved**: 2026-03-04
- **Location**: project — `/home/ruanb/Developer/github/.dotfiles/.github/`
- **Template Source**: Dotfiles/System Team (expanded)
- **Agents**:
  - `dotfiles-orchestrator.agent.md` — Master coordinator with explicit runSubagent delegation mechanics
  - `dotfiles-researcher.agent.md` — Research specialist (tools, CLI apps, best practices, ecosystem)
  - `config-manager.agent.md` — Application config specialist (14+ apps)
  - `package-manager.agent.md` — Package list tracking, drift detection (pacman/AUR)
  - `script-builder.agent.md` — Bash automation scripts with samurai aesthetic
  - `hyprland-engineer.agent.md` — Hyprland DE stack specialist
  - `theme-enforcer.agent.md` — Catppuccin Macchiato consistency auditor (read-only)
  - `setup-deployer.agent.md` — Makefile deployment and fresh system setup
  - `backup-guardian.agent.md` — Backup strategy, commit discipline, git-crypt security
- **Skills**: None (team uses instruction files for embedded knowledge)
- **Instructions**:
  - `catppuccin-enforcement.instructions.md` — Macchiato palette reference and rules (applyTo: config/**)
  - `stow-deployment-rules.instructions.md` — Stow + Makefile conventions (applyTo: Makefile, setup.sh, scripts/**)
  - `commit-discipline.instructions.md` — Conventional commits and push discipline (applyTo: **)
  - `script-style.instructions.md` — Bash script conventions and samurai template (applyTo: scripts/**/*.sh)
  - `hyprland-conventions.instructions.md` — Hyprland 0.53+ patterns (applyTo: config/hypr/**, config/waybar/**, etc.)
  - `package-tracking.instructions.md` — Package list management (applyTo: packages/**)
- **Prompts**:
  - `add-new-config.prompt.md` — Add new app config workflow → config-manager
  - `system-health-check.prompt.md` — Full system health report → dotfiles-orchestrator
  - `fresh-install-guide.prompt.md` — Fresh Arch install walkthrough → setup-deployer
  - `theme-audit.prompt.md` — Macchiato compliance scan → theme-enforcer
  - `package-drift-check.prompt.md` — Package drift detection → package-manager
- **MCP Servers**: None added (uses existing fetch, github, context7)
- **Evolution Notes**: v1.1.0 — Added dotfiles-researcher agent (READ-ONLY research specialist with fetch/context7/github MCP tools). Rewrote dotfiles-orchestrator from scratch with explicit runSubagent delegation mechanics, routing decision tree, multi-agent workflow chains, and clear invocation patterns. Fixed orchestrator's inability to delegate by teaching it the exact mechanics of runSubagent tool usage. Updated tools array to use broad tool sets ('agent', 'read', 'search', 'todo', 'vscode') and MCP wildcard patterns ('fetch/*', 'context7/*', 'github/*'). Previous: v1.0.0 initial build with 8 agents.
- **Performance Notes**: v1.0.0 orchestrator was unable to delegate — didn't understand runSubagent mechanics. Fixed in v1.1.0 with explicit How You Delegate section and routing decision tree.

---

## Learned Templates

_Templates learned from successful custom team builds will appear here._

---

## Statistics

- **Total Teams Created**: 1
- **Total Agents Generated**: 9
- **Total Skills Created**: 9
- **Last Activity**: 2026-03-03
