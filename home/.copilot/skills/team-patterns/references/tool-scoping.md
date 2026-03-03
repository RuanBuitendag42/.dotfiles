# Tool Scoping Strategies

How to assign tools to agents for security, focus, and effectiveness.

## Core Principle: Least Privilege

Each agent should have ONLY the tools it needs. This:
- **Focuses the agent** — fewer tools = less decision paralysis
- **Prevents accidents** — read-only agents can't accidentally edit files
- **Improves quality** — agents stay in their lane

## Tool Categories

### Read-Only Tools
For research, analysis, and review agents.
```yaml
tools: ['read/readFile', 'search/codebase', 'search/textSearch', 'search/fileSearch', 'search/listDirectory', 'search/usages', 'search/changes', 'read/problems']
```

### Read + Write Tools
For implementation and creation agents.
```yaml
tools: ['read/readFile', 'edit/editFiles', 'edit/createFile', 'edit/createDirectory', 'search/codebase', 'search/textSearch', 'search/fileSearch']
```

### Execution Tools
For agents that need to run commands, tests, or scripts. Use with caution.
```yaml
tools: ['execute/runInTerminal', 'execute/getTerminalOutput', 'execute/awaitTerminal', 'execute/killTerminal', 'execute/runTests', 'execute/testFailure']
```

### Orchestration Tools
For orchestrator agents that delegate to sub-agents.
```yaml
tools: ['agent/runSubagent', 'vscode/askQuestions', 'todo']
```

### Internet/Research Tools
For agents that need to fetch external resources.
```yaml
tools: ['fetch/fetch', 'context7/resolve-library-id', 'context7/get-library-docs']
```

### GitHub Tools
For agents managing repos, issues, PRs.
```yaml
tools: ['github/search_code', 'github/search_repositories', 'github/get_file_contents', 'github/list_issues', 'github/issue_read', 'github/issue_write', 'github/create_pull_request', 'github/pull_request_read']
```

## Role-Based Tool Assignment

| Role | Read | Write | Execute | Orchestrate | Internet | GitHub |
|------|:----:|:-----:|:-------:|:-----------:|:--------:|:------:|
| Orchestrator | Minimal | No | No | Yes | No | Optional |
| Researcher | Yes | No | No | No | Yes | Yes |
| Architect | Yes | No | No | No | Optional | No |
| Developer | Yes | Yes | Yes | No | Optional | No |
| Tester | Yes | Yes | Yes | No | No | No |
| Reviewer | Yes | No | No | No | No | Optional |
| DevOps | Yes | Yes | Yes | No | No | Yes |
| Doc Writer | Yes | Yes | No | No | No | No |
| Deployer | Yes | Yes | Yes | No | No | Optional |
| Validator | Yes | No | No | No | No | No |

## Tool List Behavior

- **No `tools` key** = ALL tools enabled (use for mega-agents only)
- **`tools: []`** = ALL tools disabled (text-only agent)
- **`tools: ['specific']`** = Only listed tools enabled
- **Unrecognized tool names** are silently ignored (enables environment-specific tools)

## Anti-Patterns

- **Giving all tools to every agent** — creates unfocused agents
- **Giving execution tools to analyzers** — they might "fix" things instead of reporting
- **No tools for implementation agents** — they can't do their job
- **Missing `runSubagent` on orchestrator** — can't delegate to team members
