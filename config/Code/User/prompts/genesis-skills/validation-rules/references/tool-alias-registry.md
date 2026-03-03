# Tool Alias Registry

Complete registry of known VS Code Copilot tool aliases. Use these exact strings in agent `tools` frontmatter.

## VS Code Built-in Tools

### Read Tools
| Alias | Description |
|-------|-------------|
| `read/readFile` | Read file contents |
| `read/problems` | Get compile/lint errors and diagnostics |
| `read/getNotebookSummary` | Get Jupyter notebook summary |
| `read/terminalSelection` | Get terminal selection text |
| `read/terminalLastCommand` | Get last terminal command output |

### Edit Tools
| Alias | Description |
|-------|-------------|
| `edit/editFiles` | Edit existing files (replace, insert) |
| `edit/createFile` | Create new files |
| `edit/createDirectory` | Create directories |
| `edit/createJupyterNotebook` | Create new Jupyter notebook |
| `edit/editNotebook` | Edit Jupyter notebook cells |

### Search Tools
| Alias | Description |
|-------|-------------|
| `search/codebase` | Semantic code search |
| `search/textSearch` | Grep/regex text search |
| `search/fileSearch` | Find files by glob/name |
| `search/listDirectory` | List directory contents |
| `search/usages` | Find code usages/references |
| `search/changes` | View git changes/diff |
| `search/searchResults` | Get VS Code search results |

### Execute Tools
| Alias | Description |
|-------|-------------|
| `execute/runInTerminal` | Run shell commands in terminal |
| `execute/getTerminalOutput` | Get terminal output by ID |
| `execute/awaitTerminal` | Wait for terminal command to complete |
| `execute/killTerminal` | Kill a terminal process |
| `execute/runTests` | Run test suite |
| `execute/testFailure` | Get test failure details |
| `execute/createAndRunTask` | Create and run VS Code task |
| `execute/runNotebookCell` | Run Jupyter notebook cell |

### Agent Tools
| Alias | Description |
|-------|-------------|
| `agent/runSubagent` | Delegate task to a sub-agent |

### VS Code Tools
| Alias | Description |
|-------|-------------|
| `vscode/askQuestions` | Ask user interactive questions |
| `vscode/getProjectSetupInfo` | Get project configuration info |
| `vscode/installExtension` | Install VS Code extension |
| `vscode/newWorkspace` | Create new workspace |
| `vscode/openSimpleBrowser` | Open URL in simple browser |
| `vscode/runCommand` | Run VS Code command |
| `vscode/vscodeAPI` | Access VS Code API |
| `vscode/extensions` | List installed extensions |

### Task Management
| Alias | Description |
|-------|-------------|
| `todo` | Manage structured todo list |

## MCP Server Tools

### Fetch MCP (`fetch/`)
| Alias | Description |
|-------|-------------|
| `fetch/fetch` | Fetch web pages and API endpoints |

### Context7 MCP (`context7/`)
| Alias | Description |
|-------|-------------|
| `context7/resolve-library-id` | Look up library ID by name |
| `context7/get-library-docs` | Fetch library documentation |

### GitHub MCP (`github/`)
| Alias | Description |
|-------|-------------|
| `github/get_me` | Get authenticated user info |
| `github/search_code` | Search code across repos |
| `github/search_repositories` | Search repositories |
| `github/search_issues` | Search issues |
| `github/search_pull_requests` | Search pull requests |
| `github/search_users` | Search users |
| `github/get_file_contents` | Get file contents from repo |
| `github/get_commit` | Get commit details |
| `github/list_commits` | List commits |
| `github/list_branches` | List branches |
| `github/create_branch` | Create branch |
| `github/list_issues` | List issues |
| `github/issue_read` | Read issue details |
| `github/issue_write` | Create/update issues |
| `github/list_issue_types` | List org issue types |
| `github/add_issue_comment` | Comment on issue |
| `github/sub_issue_write` | Manage sub-issues |
| `github/assign_copilot_to_issue` | Assign Copilot to issue |
| `github/list_pull_requests` | List pull requests |
| `github/pull_request_read` | Read PR details |
| `github/create_pull_request` | Create pull request |
| `github/update_pull_request` | Update pull request |
| `github/update_pull_request_branch` | Update PR branch |
| `github/merge_pull_request` | Merge pull request |
| `github/pull_request_review_write` | Write PR review |
| `github/add_comment_to_pending_review` | Add comment to pending review |
| `github/request_copilot_review` | Request Copilot review |
| `github/create_or_update_file` | Create/update file in repo |
| `github/delete_file` | Delete file from repo |
| `github/push_files` | Push multiple files |
| `github/create_repository` | Create new repository |
| `github/fork_repository` | Fork repository |
| `github/get_label` | Get label details |
| `github/get_latest_release` | Get latest release |
| `github/get_release_by_tag` | Get release by tag |
| `github/list_releases` | List releases |
| `github/get_tag` | Get tag details |
| `github/list_tags` | List tags |
| `github/get_teams` | List teams |
| `github/get_team_members` | List team members |

### Awesome-Copilot MCP (`awesome-copilot/`)
| Alias | Description |
|-------|-------------|
| `awesome-copilot/search` | Search awesome-copilot resources |
| `awesome-copilot/install` | Install resources from awesome-copilot |

## Tool List Behavior Summary

```yaml
# ALL tools enabled (most permissive)
# Just omit the tools key entirely

# ALL tools disabled (text-only agent)
tools: []

# Specific tools only
tools: ['read/readFile', 'search/codebase', 'edit/editFiles']

# Unrecognized names are silently ignored
tools: ['read/readFile', 'nonexistent/tool']  # nonexistent/tool is skipped
```
