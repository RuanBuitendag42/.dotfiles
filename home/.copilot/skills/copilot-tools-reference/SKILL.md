---
name: copilot-tools-reference
description: "Complete reference of VS Code Copilot tool names, tool sets, and MCP wildcards. Use when selecting tools for agents, validating tool lists, or converting between tool name formats."
---

# Copilot Tools Reference

You have authoritative knowledge of all VS Code Copilot tool names and their correct format.

## Critical Rule: Use Flat Tool Names

Tools in `.agent.md` frontmatter use **flat names** (no namespace prefixes).

```yaml
# ❌ WRONG — namespaced format (does not work)
tools:
  - read/readFile
  - edit/editFiles
  - search/codebase
  - execute/runInTerminal
  - agent/runSubagent

# ✅ CORRECT — flat format
tools:
  - readFile
  - editFiles
  - codebase
  - runInTerminal
  - runSubagent
```

## Built-in Tools (Complete List)

| Tool Name | Description |
|-----------|-------------|
| `agent` | Enable agent invocation (**required** when both `agents` and `tools` are set) |
| `changes` | List source control changes |
| `codebase` | Semantic code search in workspace |
| `createAndRunTask` | Create and run a VS Code task |
| `createDirectory` | Create a new directory |
| `createFile` | Create a new file |
| `editFiles` | Apply edits to files |
| `editNotebook` | Edit notebook cells |
| `extensions` | Search for VS Code extensions |
| `fetch` | Fetch content from a web URL |
| `fileSearch` | Search files by glob pattern |
| `getNotebookSummary` | Get notebook cells and details |
| `getProjectSetupInfo` | Get project scaffolding info |
| `getTaskOutput` | Get output from a VS Code task |
| `getTerminalOutput` | Get terminal command output |
| `githubRepo` | Search in a GitHub repository |
| `installExtension` | Install a VS Code extension |
| `listDirectory` | List files in a directory |
| `new` | Scaffold a new workspace |
| `newJupyterNotebook` | Scaffold a Jupyter notebook |
| `newWorkspace` | Create a new workspace |
| `openSimpleBrowser` | Open integrated browser |
| `problems` | Get workspace issues (lint/compile errors) |
| `readFile` | Read file content |
| `readNotebookCellOutput` | Read notebook cell output |
| `runCell` | Run a notebook cell |
| `runInTerminal` | Run shell command in terminal |
| `runSubagent` | Run task in isolated subagent context |
| `runTask` | Run an existing VS Code task |
| `runTests` | Run unit tests |
| `runVscodeCommand` | Execute a VS Code command |
| `searchResults` | Get Search view results |
| `selection` | Get current editor selection |
| `terminalLastCommand` | Get last terminal command and output |
| `terminalSelection` | Get terminal selection |
| `testFailure` | Get test failure information |
| `textSearch` | Find text in files (grep) |
| `todos` | Track progress with todo list |
| `usages` | Find references, implementations, definitions |
| `VSCodeAPI` | Ask about VS Code extension APIs |
| `askQuestions` | Ask user clarifying questions |
| `awaitTerminal` | Wait for terminal command to complete |
| `killTerminal` | Kill a terminal process |

## Tool Sets (Predefined Groups)

Reference these as single entries in the `tools` array:

| Tool Set | Contains | Description |
|----------|----------|-------------|
| `edit` | `editFiles`, `createFile`, `createDirectory` | File modifications |
| `search` | `codebase`, `fileSearch`, `textSearch`, `listDirectory`, `usages` | Workspace searching |
| `runCommands` | `runInTerminal`, `getTerminalOutput`, `terminalLastCommand` | Terminal operations |
| `runNotebooks` | `runCell`, `editNotebook`, `getNotebookSummary` | Notebook operations |
| `runTasks` | `createAndRunTask`, `runTask`, `getTaskOutput` | VS Code tasks |

Usage:
```yaml
tools:
  - search        # Includes all search tools
  - edit          # Includes all edit tools
  - runCommands   # Includes all terminal tools
  - runSubagent   # Individual tool alongside sets
```

## MCP Tool Wildcards

Include all tools from an MCP server:

```yaml
tools:
  - "github/*"           # All GitHub MCP tools
  - "mcp-atlassian/*"    # All Jira/Confluence tools
  - "agent-team/*"       # Agent coordination tools
  - "context7/*"         # Documentation lookup tools
  - "fetch/*"            # Web fetching tools
```

Or specific MCP tools:
```yaml
tools:
  - "github/create_pull_request"
  - "mcp-atlassian/jira_get_issue"
```

## Tool Selection by Agent Archetype

| Archetype | Recommended Tools |
|-----------|-------------------|
| **Read-Only / Planner** | `readFile`, `problems`, `codebase`, `fileSearch`, `listDirectory`, `textSearch`, `usages` |
| **Implementer** | Planner tools + `editFiles`, `createFile`, `runInTerminal`, `getTerminalOutput` |
| **Tester** | Planner tools + `editFiles`, `createFile`, `runInTerminal`, `getTerminalOutput`, `testFailure`, `runTests` |
| **Deployer / DevOps** | Planner tools + `runInTerminal`, `getTerminalOutput`, `github/*` |
| **Documenter** | Planner tools + `editFiles`, `createFile`, `mcp-atlassian/*` |
| **Researcher** | `readFile`, `codebase`, `fileSearch`, `listDirectory`, `textSearch`, `usages`, `mcp-atlassian/*` |
| **Captain / Team Lead** | `agent`, `runSubagent`, `askQuestions`, `todos`, `readFile`, `problems`, `codebase`, `fileSearch`, `listDirectory`, `textSearch`, `usages`, `editFiles`, `createFile`, `runInTerminal`, `getTerminalOutput`, `fetch`, `github/*`, `mcp-atlassian/*`, `agent-team/*` |

## Legacy Name Conversion

If migrating agents from namespaced format:

| Old (Namespaced) | New (Flat) |
|-------------------|-----------|
| `read/readFile` | `readFile` |
| `read/problems` | `problems` |
| `read/getNotebookSummary` | `getNotebookSummary` |
| `read/terminalSelection` | `terminalSelection` |
| `read/terminalLastCommand` | `terminalLastCommand` |
| `edit/editFiles` | `editFiles` |
| `edit/createFile` | `createFile` |
| `edit/createDirectory` | `createDirectory` |
| `edit/createJupyterNotebook` | `newJupyterNotebook` |
| `edit/editNotebook` | `editNotebook` |
| `search/codebase` | `codebase` |
| `search/fileSearch` | `fileSearch` |
| `search/listDirectory` | `listDirectory` |
| `search/textSearch` | `textSearch` |
| `search/usages` | `usages` |
| `search/changes` | `changes` |
| `search/searchResults` | `searchResults` |
| `execute/runInTerminal` | `runInTerminal` |
| `execute/getTerminalOutput` | `getTerminalOutput` |
| `execute/awaitTerminal` | `awaitTerminal` |
| `execute/killTerminal` | `killTerminal` |
| `execute/testFailure` | `testFailure` |
| `execute/runNotebookCell` | `runCell` |
| `execute/createAndRunTask` | `createAndRunTask` |
| `agent/runSubagent` | `runSubagent` |
| `vscode/openSimpleBrowser` | `openSimpleBrowser` |
| `vscode/runCommand` | `runVscodeCommand` |
| `vscode/askQuestions` | `askQuestions` |
| `fetch/fetch` | `fetch` |

## Tool Inheritance

When a captain/team-lead agent spawns a subagent via `runSubagent`, the subagent **inherits the parent's tool list**. This has important implications:

- If the captain doesn't have a tool, subagents spawned by it won't have it either
- The captain's tool list must be comprehensive enough for ALL specialists to function
- Leaf agents (`agents: []`) don't need to worry about this — they don't spawn subagents
- MCP tool wildcards (e.g., `github/*`) are also inherited

**Example:** If a captain needs its implementer subagent to use `editFiles` and `runInTerminal`, the captain must have those tools in its own `tools` array.

## Critical Rule: `agent` Tool

When both `agents` and `tools` are specified in YAML frontmatter, the literal tool `agent` **must** be included in the `tools` array. Without it, VS Code will report a lint error and subagent invocation won't work.

```yaml
# ❌ WRONG — missing `agent` tool
agents:
  - "*"
tools:
  - runSubagent
  - readFile

# ✅ CORRECT — `agent` tool included
agents:
  - "*"
tools:
  - agent
  - runSubagent
  - readFile
```

Note: If `tools` is not specified at all (agent has access to all tools), the `agent` tool is included automatically.
| `todo` | `todos` |
