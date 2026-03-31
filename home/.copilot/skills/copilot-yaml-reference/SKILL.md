---
name: copilot-yaml-reference
description: "Complete YAML frontmatter specification for VS Code Copilot custom agents, instructions, skills, and prompts. Use when creating or validating .agent.md, .instructions.md, or SKILL.md files."
---

# Copilot YAML Frontmatter Reference

You have authoritative knowledge of the VS Code GitHub Copilot YAML frontmatter specification for all customization file types.

## Agent Frontmatter (`.agent.md`)

### Required Properties

| Property | Type | Description |
|----------|------|-------------|
| `description` | string | Brief description shown as placeholder text in chat input. **Keep under 100 characters.** |

### Optional Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | filename | Display name of the agent |
| `argument-hint` | string | — | Hint text shown in chat input to guide users |
| `tools` | array | — | Tool names, tool sets, or MCP wildcards (see `copilot-tools-reference` skill). **Must include `agent` when `agents` is also set.** |
| `agents` | array | `["*"]` | Subagent access. `["*"]` = all, `[]` = none, `["Display Name"]` = specific (uses `name` field) |
| `model` | string or array | current | AI model(s). Array = prioritized fallback list |
| `user-invokable` | boolean | `true` | `false` hides from agents dropdown (subagent-only) |
| `disable-model-invocation` | boolean | `false` | `true` prevents other agents from auto-invoking as subagent |
| `target` | string | `vscode` | Target: `vscode` or `github-copilot` |
| `mcp-servers` | array | — | MCP server configs (only for `target: github-copilot`) |
| `handoffs` | array | — | List of handoff definitions |

### Deprecated Properties

| Property | Replacement |
|----------|-------------|
| `infer` | Use `user-invokable` and `disable-model-invocation` instead |

### Handoff Properties

| Property | Required | Type | Description |
|----------|----------|------|-------------|
| `label` | **Yes** | string | Button text shown to user |
| `agent` | **Yes** | string | Target agent's `name` field (display name), NOT the filename |
| `prompt` | No | string | Pre-filled prompt text |
| `send` | No | boolean | Auto-submit if `true`. Default: `false` |
| `model` | No | string | Model override. Format: `"Model Name (vendor)"` |

## Instructions Frontmatter (`.instructions.md`)

| Property | Required | Type | Description |
|----------|----------|------|-------------|
| `applyTo` | **Yes** | string | Glob pattern for when to apply |
| `description` | No | string | Purpose description |

### Common `applyTo` Patterns

| Pattern | Matches |
|---------|---------|
| `**` | All files (global) |
| `**/*.ts` | TypeScript files |
| `**/*.{ts,tsx}` | TypeScript and TSX |
| `src/**` | Everything in src/ |
| `**/tests/**` | All test directories |
| `Dockerfile` | Dockerfiles only |

## Skill Frontmatter (`SKILL.md`)

| Property | Required | Type | Description |
|----------|----------|------|-------------|
| `name` | No | string | Skill identifier |
| `description` | **Yes** | string | **Critical for discovery.** Task-matching description that triggers progressive loading. |

### Progressive Disclosure (3 Levels)

1. **Level 1 — Discovery:** Only `name` + `description` are scanned (near-zero tokens)
2. **Level 2 — Instructions:** Full `SKILL.md` body loaded when task matches description
3. **Level 3 — Resources:** Referenced files in `references/`, `templates/`, `scripts/` loaded only when explicitly needed

## File Locations

### Default Paths (built-in)

| File Type | User-Level (Global) | Workspace-Level |
|-----------|---------------------|------------------|
| Agents | `~/Library/Application Support/Code/User/prompts/*.agent.md` | `.github/agents/*.agent.md` |
| Instructions | `~/Library/Application Support/Code/User/prompts/*.instructions.md` | `.github/instructions/*.instructions.md` |
| Prompts | `~/Library/Application Support/Code/User/prompts/*.prompt.md` | `.github/prompts/*.prompt.md` |
| Skills | `~/.copilot/skills/<name>/SKILL.md` | `.github/skills/<name>/SKILL.md` |

### Configurable Paths (recommended)

VS Code settings allow custom locations. The `~` prefix resolves cross-platform (macOS, Linux, Windows).

**Format:** These settings take an **object** (NOT an array) with path strings as keys and `true`/`false` as values.

```json
"chat.agentFilesLocations": {
    "~/.copilot/agents": true
}
```

| Setting | Configures |
|---------|------------|
| `chat.agentFilesLocations` | Additional agent search paths |
| `chat.instructionsFilesLocations` | Additional instruction search paths |
| `chat.promptFilesLocations` | Additional prompt search paths |
| `chat.agentSkillsLocations` | Additional skill search paths |

**Recommended cross-platform layout** (set via settings above):

| File Type | Path | Setting |
|-----------|------|---------|
| Agents | `~/.copilot/agents/` | `chat.agentFilesLocations` |
| Instructions | `~/.copilot/instructions/` | `chat.instructionsFilesLocations` |
| Prompts | `~/.copilot/prompts/` | `chat.promptFilesLocations` |
| Skills | `~/.copilot/skills/` | Default — no setting needed |

### Critical Rules

- **No subfolders in user prompts** — VS Code does NOT recursively search. All `.agent.md` must be at root level.
- **Skill folders ARE allowed** — agents discover them via description matching.
- **Use flat prefix naming** for grouping: `genesis-captain.agent.md`, `genesis-foundry.agent.md`.

## Complete Example

See [references/frontmatter-examples.md](references/frontmatter-examples.md) for fully annotated examples of all file types.
