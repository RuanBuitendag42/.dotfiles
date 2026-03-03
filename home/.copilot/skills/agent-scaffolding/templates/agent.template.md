---
description: 'REQUIRED: Brief description of what this agent does'
# name: 'OPTIONAL: Display name (defaults to filename without extension)'
# model: 'RECOMMENDED: GPT-4.1, Claude Sonnet 4, etc.'
# tools: ['OPTIONAL: List specific tools, omit for ALL, [] for NONE']
#   Common tools:
#     - 'codebase'           # Semantic code search
#     - 'read/readFile'      # Read file contents
#     - 'edit/editFiles'     # Edit existing files
#     - 'edit/createFile'    # Create new files
#     - 'edit/createDirectory' # Create directories
#     - 'search/textSearch'  # Grep/regex search
#     - 'search/fileSearch'  # Find files by name
#     - 'search/listDirectory' # List directory contents
#     - 'search/codebase'    # Semantic code search
#     - 'search/usages'      # Find code usages
#     - 'search/changes'     # View git changes
#     - 'execute/runInTerminal' # Run shell commands
#     - 'execute/getTerminalOutput' # Get terminal output
#     - 'execute/awaitTerminal' # Wait for terminal
#     - 'execute/killTerminal' # Kill terminal
#     - 'execute/runTests'   # Run tests
#     - 'execute/testFailure' # Get test failure details
#     - 'agent/runSubagent'  # Delegate to sub-agents
#     - 'fetch/fetch'        # Fetch web pages/APIs
#     - 'read/problems'      # Get diagnostics/errors
#     - 'vscode/askQuestions' # Ask user questions
#     - 'todo'               # Manage todo list
#     - 'context7/resolve-library-id' # Look up library IDs
#     - 'context7/get-library-docs'   # Fetch library documentation
#     - 'github/*'           # All GitHub MCP tools
# handoffs:                  # OPTIONAL: VS Code 1.106+ only
#   - label: 'Button Text'  # Action-oriented label
#     agent: 'target-agent'  # Target agent filename (without .agent.md)
#     prompt: 'Context for the next agent about what was done and what to do next'
#     send: false            # false = user reviews before sending
---

# Agent Name

You are a [role description]. Your purpose is to [primary objective].

## Identity & Expertise

- Domain expert in [specific domain]
- Specializes in [key capabilities]

## Core Responsibilities

1. [Primary task]
2. [Secondary task]
3. [Additional task]

## Workflow

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Guidelines

- [Guideline 1]
- [Guideline 2]
- [Guideline 3]

## Constraints

- [What this agent should NOT do]
- [Scope boundaries]
