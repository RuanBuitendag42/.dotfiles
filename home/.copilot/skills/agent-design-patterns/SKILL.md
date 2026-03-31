---
name: agent-design-patterns
description: "Templates, anti-patterns, quality checklists, and requirements gathering framework for creating VS Code Copilot agents, instructions, skills, and hooks. Use when designing or creating any Copilot customization artifact."
---

# Agent Design Patterns

You have expert knowledge of patterns, templates, and quality standards for creating VS Code Copilot customization artifacts.

## Requirements Gathering Framework

**CRITICAL:** Before creating ANY artifact, gather requirements through these 5 phases.

### Phase 1: Purpose & Identity (3 questions)

1. **What problem does this solve?** — Pain point, need, consequence of not having it
2. **Who is the target user?** — Developer? Non-technical? What expertise level?
3. **What persona should it embody?** — Expert / Mentor / Assistant / Strict enforcer? Formal or conversational?

### Phase 2: Scope & Tasks (3 questions)

4. **What are the PRIMARY tasks?** (max 3-5) — Core responsibilities, ruthlessly prioritized
5. **What is OUT OF SCOPE?** — Explicit boundaries, what to refuse or redirect
6. **Read-only or Implementation?** — Analysis/planning only, or also modifying code?

### Phase 3: Tool Requirements (2 questions)

7. **What tools are needed?** — Consult `copilot-tools-reference` skill for correct names and archetypes
8. **What MCP servers are needed?** — External service integrations (`github/*`, `mcp-atlassian/*`, etc.)

### Phase 4: Workflow & Integration (3 questions)

9. **Standalone or part of a chain?** — Handoffs to/from other agents?
10. **Pre-conditions?** — What must exist before this runs?
11. **Post-conditions?** — What state/artifacts should exist after completion?

### Phase 5: Location & Naming (2 questions)

12. **Where should this be saved?** — User prompts (global) vs `.github/agents/` (workspace)
13. **Naming convention?** — kebab-case, match existing patterns (`{team}-{role}.agent.md`)

## Templates

All templates are in the `templates/` directory. Reference the appropriate one:

- **[agent-basic.md](templates/agent-basic.md)** — Minimal single-purpose agent
- **[agent-captain.md](templates/agent-captain.md)** — Team lead/captain with delegation (includes `agent` tool and tool inheritance notes)
- **[agent-specialist.md](templates/agent-specialist.md)** — Hidden subagent (researcher, implementer, tester, deployer, documenter)
- **[instructions-template.md](templates/instructions-template.md)** — Auto-applied coding rules
- **[skill-template.md](templates/skill-template.md)** — Skill with resources

## Anti-Patterns (REJECT THESE)

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **God Agent** | One agent does everything | Split into focused specialists with handoffs |
| **Orphan Agent** | No handoffs in or out | Integrate into team or make standalone explicit |
| **Circular Dependencies** | A → B → C → A with no exit | Design linear or diamond flows with clear termination |
| **Tool Hoarding** | Agent has all tools "just in case" | Match tools to actual needs (principle of least privilege) |
| **Vague Boundaries** | "Helps with various things" | Explicit task lists and "DO NOT" sections |
| **Missing Description** | Empty or vague `description` | Specific, action-oriented description under 100 chars |
| **Overly Complex Single Agent** | Plans, implements, tests, deploys | Each responsibility = separate agent |
| **Namespaced Tool Names** | `read/readFile`, `edit/editFiles` | Use flat names: `readFile`, `editFiles` |
| **Hardcoded Paths** | `/Users/specific/path/` | Relative paths or environment variables |
| **No Examples** | Abstract instructions only | Concrete input→output examples |
| **Too Many Instructions Files** | Kills context window | Use skills (progressive disclosure) for reference material |

## Quality Checklists

### For Agents
- [ ] `description` under 100 characters, specific and action-oriented
- [ ] Tool names are flat format (no namespace prefixes)
- [ ] Minimal tool set (principle of least privilege)
- [ ] Clear persona definition in body
- [ ] Explicit "Out of Scope" section
- [ ] Actionable task list (max 3-5 primary tasks)
- [ ] `user-invokable: false` on subagent-only agents
- [ ] `agents: []` on leaf agents that shouldn't delegate
- [ ] Handoff `agent` values match the `name` field of the target agent (display name, NOT filename)
- [ ] When both `agents` and `tools` are set, `agent` tool is included in `tools`
- [ ] Uses `askQuestions` tool for ALL user interaction (never asks in chat)
- [ ] `askQuestions` is included in the tools list
- [ ] Post-creation: run `problems` tool to validate YAML syntax

### For Agent Teams
- [ ] Clear handoff chain with no gaps
- [ ] No overlapping responsibilities
- [ ] Escalation path defined
- [ ] Entry point (captain/team lead) is `user-invokable: true`
- [ ] All specialists are `user-invokable: false`
- [ ] Captain has all tools needed by subagents (tool inheritance via `runSubagent`)
- [ ] Shared context documented
- [ ] Mermaid visualization diagram included

### For Instructions
- [ ] `applyTo` pattern is precise (not `**` unless truly global)
- [ ] Rules are actionable and enforceable
- [ ] Includes ✅ good / ❌ bad code examples
- [ ] No conflicts with existing instructions
- [ ] Reasoning included for non-obvious rules

### For Skills
- [ ] `description` is task-matching (what triggers loading)
- [ ] SKILL.md is focused instructions (not a dump of everything)
- [ ] Heavy reference material in `references/` (Level 3 — loaded on demand)
- [ ] Templates in `templates/` directory
- [ ] Scripts in `scripts/` directory
- [ ] Folder name is descriptive kebab-case
