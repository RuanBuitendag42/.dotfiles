# Agent Migration Guide

Step-by-step guide for migrating existing agent teams to the new skills-based architecture.

## Overview

The new architecture replaces inline documentation with shared skills, reducing agent file sizes from 500-900 lines to ~150-200 lines while improving accuracy and maintainability.

### What Changed

| Before | After |
|--------|-------|
| Tool specs embedded in every agent | → `copilot-tools-reference` skill |
| YAML frontmatter docs in every agent | → `copilot-yaml-reference` skill |
| MCP protocol copy-pasted everywhere | → `agent-team-protocol` skill |
| 500-900 line agents | → 150-200 line focused agents |
| Namespaced tool names | → Flat tool names |

---

## Migration Steps

### Step 1: Fix Tool Names (CRITICAL)

Replace ALL namespaced tool names with flat format in YAML frontmatter.

Quick reference for the most common conversions:

| Old (Namespaced) | New (Flat) |
|-------------------|-----------|
| `read/readFile` | `readFile` |
| `read/problems` | `problems` |
| `edit/editFiles` | `editFiles` |
| `edit/createFile` | `createFile` |
| `edit/createDirectory` | `createDirectory` |
| `search/codebase` | `codebase` |
| `search/fileSearch` | `fileSearch` |
| `search/listDirectory` | `listDirectory` |
| `search/textSearch` | `textSearch` |
| `search/usages` | `usages` |
| `search/changes` | `changes` |
| `execute/runInTerminal` | `runInTerminal` |
| `execute/getTerminalOutput` | `getTerminalOutput` |
| `execute/awaitTerminal` | `awaitTerminal` |
| `execute/killTerminal` | `killTerminal` |
| `execute/testFailure` | `testFailure` |
| `agent/runSubagent` | `runSubagent` |
| `vscode/runCommand` | `runVscodeCommand` |
| `vscode/askQuestions` | `askQuestions` |
| `fetch/fetch` | `fetch` |
| `todo` | `todos` |

For the complete conversion table, consult the `copilot-tools-reference` skill.

### Step 2: Set Model

Replace any model field with:
```yaml
model: "Claude Opus 4.6"
```

### Step 2.5: Fix Handoff Agent Values (CRITICAL)

Handoff `agent` values must use the target agent's `name` field (display name), NOT the filename.

```yaml
# ❌ WRONG — uses filename
handoffs:
  - label: "🧪 Test"
    agent: "project-tester"

# ✅ CORRECT — uses name field (display name)
handoffs:
  - label: "🧪 Test"
    agent: "Project Tester"
```

For each handoff, find the target agent file and copy its `name` field value.

### Step 2.6: Add `agent` Tool (CRITICAL)

When both `agents` and `tools` are specified, add the `agent` tool:

```yaml
# Required when agents + tools co-exist
agents:
  - "*"
tools:
  - agent          # ← REQUIRED
  - runSubagent
  - readFile
  # ... other tools
```

### Step 3: Remove Inline Documentation

Delete these sections if they exist in the agent body (they now live in skills):

- **Tool reference tables** — now in `copilot-tools-reference`
- **YAML frontmatter documentation** — now in `copilot-yaml-reference`
- **MCP agent-team protocol** — now in `agent-team-protocol`
- **Agent creation templates** — now in `agent-design-patterns`
- **Team design guides** — now in `team-design-framework`

Replace each removed section with a brief skills reference table:

```markdown
## Skills Reference

| Skill | Consult When |
|-------|-------------|
| `copilot-tools-reference` | Selecting tools for agents |
| `copilot-yaml-reference` | Setting YAML frontmatter |
| `agent-team-protocol` | MCP agent communication |
```

Only include skills relevant to the agent's role.

### Step 4: Simplify Agent Communication Section

Replace any long MCP protocol documentation with:

```markdown
## Agent Communication

Use the `agent-team` MCP server. On startup:
1. `register_agent(name="<agent-name>", team="<team>", role="<role>")`
2. `read_messages(agent_name="<agent-name>")`
3. `get_tasks(agent_name="<agent-name>", role="assigned")`

Refer to the `agent-team-protocol` skill for full patterns.
```

### Step 5: Validate

After migration, run these checks:

1. **YAML syntax** — Run `problems` tool on the file
2. **Tool names** — Verify all tools are flat format (no `/` in names except MCP wildcards)
3. **Description** — Under 100 characters
4. **Handoffs** — `agent` values match the `name` field (display name) of target agents
5. **`agent` tool** — present when both `agents` and `tools` are set
6. **Line count** — Target 150-200 lines per agent
7. **Quality checklist** — Run from `agent-design-patterns` skill

---

## Team-Specific Notes

### MCP Team
- 4 agents (architect, implementer, tester, docs)
- Heavy MCP protocol usage — move to `agent-team-protocol` skill ref
- Keep MCP-specific creation logic in implementer

### EVO Backend Team
- 8 agents (orchestrator, architect, implementer, tester, deployer, documenter, researcher, releaser)
- Largest team — most duplication to remove
- Deployment procedures are agent-specific — keep those inline

### Dotfiles Team
- If agents exist for dotfiles management
- Reference stow patterns from dotfiles instructions
- Keep file placement rules inline (they're the core purpose)

---

## Validation Script

After migrating a team, have `genesis-tester` validate:

```
@genesis-tester Test the [team-name] agent team for correctness
```

This runs the full test procedure: YAML validation, tool name checks, handoff integrity, and quality checklist.
