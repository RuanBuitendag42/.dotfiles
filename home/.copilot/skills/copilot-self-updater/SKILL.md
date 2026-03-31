---
name: copilot-self-updater
description: "Auto-fetch latest VS Code Copilot patterns from github/awesome-copilot repository. Use when checking for updates, new agent patterns, or evolving Genesis knowledge base."
---

# Copilot Self-Update System

You can fetch the latest Copilot customization patterns from the public `github/awesome-copilot` repository.

## Update Triggers

Execute this procedure when user says: "update", "check for updates", "what's new", "evolve", "refresh knowledge"

## Update Procedure

### Step 1: Fetch Latest Data

Use the `fetch` tool to pull from these public GitHub raw URLs:

```
https://raw.githubusercontent.com/github/awesome-copilot/main/README.md
https://raw.githubusercontent.com/github/awesome-copilot/main/docs/README.agents.md
https://raw.githubusercontent.com/github/awesome-copilot/main/docs/README.instructions.md
https://raw.githubusercontent.com/github/awesome-copilot/main/docs/README.skills.md
https://raw.githubusercontent.com/github/awesome-copilot/main/docs/README.hooks.md
```

### Step 2: Parse for Changes

Compare fetched content against the changelog below. Look for:
- New YAML frontmatter properties
- New tool names or tool sets
- New agent archetypes or patterns
- New skill conventions
- New hook event types
- Deprecated features

### Step 3: Report Findings

```markdown
## Genesis Evolution Report

**Scanned:** [current date]
**Last Known Update:** [LAST_UPDATE from changelog]

### New Patterns Discovered
- [pattern] — [what it enables]

### New Agent Archetypes
- [name] — [use case]

### New Capabilities
- [capability] — [how to use]

### Deprecated Features
- [feature] — [replacement]

### Recommended Actions
1. [Update suggestion for user's workflow]
2. [New pattern to adopt]
```

### Step 4: Update Skills (if needed)

If significant changes are found:
1. Update the relevant skill's `references/` files
2. Update the changelog below
3. Notify user of what was updated

## Changelog

See [references/changelog.md](references/changelog.md) for update history.

## Important Notes

- Awesome-copilot is a **community repository** — evaluate patterns before adopting
- Always validate new patterns against official VS Code docs
- Some patterns may be experimental or Insiders-only
- The `fetch` tool may not return perfectly formatted content — parse carefully
