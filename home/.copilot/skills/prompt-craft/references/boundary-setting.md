# Boundary Setting

How to define clear scope limits, tool restrictions, and safety rails for agents.

## Why Boundaries Matter

Without boundaries, agents:
- Try to do everything and do nothing well
- Make changes outside their scope
- Conflict with other team members' responsibilities
- Accumulate too much context and lose focus

## Types of Boundaries

### 1. Scope Boundaries
Define what the agent IS and IS NOT responsible for.

```markdown
## Scope
- Responsible for: Security analysis, vulnerability detection, dependency auditing
- NOT responsible for: Code style, performance optimization, feature implementation
- Hand off to: Developer agent for implementing fixes
```

### 2. Tool Boundaries
Restrict tools to only what's needed (via frontmatter `tools` list).

```yaml
# Read-only agent — cannot modify anything
tools: ['read/readFile', 'search/codebase', 'search/textSearch', 'read/problems']

# Implementation agent — read + write but no terminal
tools: ['read/readFile', 'edit/editFiles', 'edit/createFile', 'search/codebase']
```

### 3. Action Boundaries
Explicit "do NOT" statements for things the agent might be tempted to do.

```markdown
## Constraints
- Do NOT modify existing code — only report findings
- Do NOT run tests — the Tester agent handles that
- Do NOT commit or push changes — wait for user instruction
- Do NOT install packages without explicit approval
```

### 4. Output Boundaries
Define the expected format and scope of output.

```markdown
## Output Format
- Findings as a structured list with severity levels
- Maximum 10 findings per review
- Include file path, line number, and recommended fix
- Do NOT include general code style comments
```

### 5. Handoff Boundaries
When this agent's work is done, what happens next.

```markdown
## Handoff Rules
- When security issues are found → hand to Developer for fixes
- When architecture changes needed → hand to Architect for design
- When all clear (no issues) → report "Clean" and complete
```

## Boundary Patterns

### The Reviewer Pattern (Read-Only)
```markdown
## Constraints
- Read-only analysis — never modify files
- Report findings, don't fix them
- Include evidence (code snippets, line numbers) for each finding
```

### The Builder Pattern (Write with Guards)
```markdown
## Constraints
- Only create files in the designated output directory
- Never modify files outside the project scope
- Always check for existing files before creating
- Run validation after every change
```

### The Orchestrator Pattern (Delegate, Don't Do)
```markdown
## Constraints
- Never implement code directly — delegate to specialized agents
- Never modify files — only read and coordinate
- Track all delegated tasks and their status
- Aggregate results but don't alter them
```

## Anti-Patterns

- **No boundaries at all**: Agent tries everything, does nothing well
- **Too many do-nots**: Agent becomes paralyzed by restrictions
- **Vague boundaries**: "Be careful with changes" — not actionable
- **Conflicting boundaries**: "Review and fix code" but "Don't modify files"
