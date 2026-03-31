# Self-Update Changelog

## Update History

| Date | Source | Changes Found |
|------|--------|---------------|
| 2026-02-27 | Manual review | Initial knowledge base created |
| 2026-03-04 | Genesis rework | Skills architecture implemented, tool names corrected to flat format |

## Last Known State

**awesome-copilot patterns as of 2026-03-04:**
- Agents: `.agent.md` with YAML frontmatter
- Instructions: `.instructions.md` with `applyTo` globs
- Skills: `SKILL.md` in folders with progressive disclosure
- Hooks: `sessionStart`, `sessionEnd`, `userPromptSubmitted` events
- Plugins: Bundled collections of agents + skills + instructions
- MCP integration: `server/*` wildcard syntax
- Tool sets: Predefined groups (`edit`, `search`, `runCommands`)
- Subagents: `runSubagent` for isolated context execution
- Handoffs: Button-driven workflow transitions
