---
name: agent-scaffolding
description: 'Templates and rules for scaffolding every Copilot file type with correct frontmatter, naming, and structure'
---

# Agent Scaffolding Skill

You are using this skill to create correctly structured Copilot customization files. Every file you generate MUST follow the exact naming conventions, frontmatter schemas, and placement rules documented here.

## Critical Rules

1. **Filenames**: MUST use `lowercase-with-hyphens` — only `.`, `-`, `_`, `a-z`, `A-Z`, `0-9` are allowed
2. **Extensions**: MUST match the file type exactly (`.agent.md`, `.instructions.md`, `.prompt.md`, `SKILL.md`)
3. **Frontmatter**: MUST be valid YAML between `---` fences at the top of the file
4. **Description**: REQUIRED in ALL file types — use single quotes in YAML
5. **No trailing whitespace** in frontmatter values

## File Type Reference

### Agent Files (`*.agent.md`)
- **Extension**: `.agent.md`
- **Naming**: `lowercase-with-hyphens.agent.md`
- **Required frontmatter**: `description`
- **Recommended frontmatter**: `tools`, `model`
- **Optional frontmatter**: `name`, `handoffs`, `infer`, `metadata`, `mcp-servers`
- **Template**: See `templates/agent.template.md`

### Instruction Files (`*.instructions.md`)
- **Extension**: `.instructions.md`
- **Naming**: `lowercase-with-hyphens.instructions.md`
- **Required frontmatter**: `description`, `applyTo`
- **`applyTo`**: Glob patterns (e.g., `**/*.ts`, `**/*.py`, `**` for all files)
- **Template**: See `templates/instruction.template.md`

### Prompt Files (`*.prompt.md`)
- **Extension**: `.prompt.md`
- **Naming**: `lowercase-with-hyphens.prompt.md`
- **Recommended frontmatter**: `description`, `agent`
- **Optional frontmatter**: `name`, `model`, `tools`, `argument-hint`
- **`agent`**: One of `ask`, `edit`, `agent`, or a custom agent name
- **Template**: See `templates/prompt.template.md`

### Skill Files (`SKILL.md`)
- **Filename**: ALWAYS `SKILL.md` (uppercase) inside a named folder
- **Folder naming**: `lowercase-with-hyphens`
- **Required frontmatter**: `name` (MUST match folder name), `description`
- **Folder structure**: `SKILL.md` + optional `references/`, `templates/`, `scripts/`, `assets/`
- **Template**: See `templates/skill.template.md`

### Plugin Files (`plugin.json`)
- **Filename**: ALWAYS `plugin.json` inside a named folder
- **Folder naming**: `lowercase-with-hyphens`
- **Required fields**: `name`, `description`, `version`
- **Optional fields**: `keywords`, `author`, `repository`, `license`, `agents`, `commands`, `skills`
- **Template**: See `templates/plugin.template.json`

### Hook Files (`hooks.json` + `README.md`)
- **Location**: Inside a named folder under `hooks/`
- **Folder naming**: `lowercase-with-hyphens`
- **Events**: `sessionStart`, `sessionEnd`, `userPromptSubmitted`, `preToolUse`, `postToolUse`, `errorOccurred`
- **Template**: See `templates/hooks.template.json`

## Placement Rules

### For User-Level (Global) Deployment
| Resource | Location |
|----------|----------|
| Agents | `~/.config/Code/User/prompts/*.agent.md` |
| Instructions | `~/.config/Code/User/prompts/*.instructions.md` |
| Prompts | `~/.config/Code/User/prompts/*.prompt.md` |

### For Project-Level Deployment
| Resource | Location |
|----------|----------|
| Global instructions | `.github/copilot-instructions.md` |
| Pattern instructions | `.github/instructions/*.instructions.md` |
| Prompts | `.github/prompts/*.prompt.md` |
| Agents | `.github/agents/*.agent.md` |
| Skills | `.github/skills/<skill-name>/SKILL.md` |
| Hooks | `.github/hooks/<hook-name>/` |
| MCP config | `.vscode/mcp.json` |

### For Organization-Level Deployment
| Resource | Location |
|----------|----------|
| Agents | `.github-private/agents/*.agent.md` |
| Instructions | Organization `.github` repository |

## Size Guidelines

| File Type | Recommended Size |
|-----------|-----------------|
| `copilot-instructions.md` | 500–3,000 characters |
| Individual agents | 500–2,000 characters |
| Skills (SKILL.md) | Up to 5,000 characters |
| Agent total prompt content | Under 30,000 characters |
| AGENTS.md (for CCA/CLI) | Can be larger (cheaper context) |

## Usage

When creating any Copilot file:
1. Select the correct template from `templates/`
2. Fill in ALL required frontmatter fields
3. Verify filename follows `lowercase-with-hyphens` pattern
4. Verify the correct extension is used
5. Place the file in the correct location for the deployment target
6. Validate against the size guidelines
