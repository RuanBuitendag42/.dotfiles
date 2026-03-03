# Context Engineering

How to maximize Copilot's context window effectiveness when designing agents and teams.

## The Context Budget

Every agent interaction has a limited context window. What goes into it:
1. **System instructions** (auto-attached `.instructions.md` files)
2. **Agent spec** (the `.agent.md` being used)
3. **Skills** (loaded on demand)
4. **Conversation history** (previous messages)
5. **File contents** (from tool calls)
6. **Tool outputs** (search results, terminal output)

## Strategies for Efficiency

### 1. Progressive Disclosure
Don't put everything in the agent spec. Use skills for details.

```markdown
## Good: Agent spec is lean, references skill for details
You are a security reviewer. Follow the security checklist in the `security-audit` skill.

## Bad: Agent spec contains the entire checklist
You are a security reviewer. Check for:
1. SQL injection: Look for string concatenation in queries...
2. XSS: Check for unsanitized user input in templates...
3. CSRF: Verify tokens on all POST endpoints...
[500 more lines]
```

### 2. Scoped Instructions
Use `applyTo` globs to load instructions only when relevant.

```yaml
# Only loads when editing Python files
applyTo: '**/*.py'

# Only loads when editing test files
applyTo: '**/*.test.*, **/*.spec.*'

# Loads everywhere (use sparingly)
applyTo: '**'
```

### 3. Lean Agent Specs
Keep the agent `.agent.md` file focused:
- Identity: 2-4 lines
- Responsibilities: 3-7 items
- Workflow: 5-10 steps
- Guidelines: 3-5 rules
- Total: 500-2,000 characters ideal

### 4. Reference Don't Repeat
Point to files instead of inlining content.

```markdown
## Good
Review the project conventions in `.github/copilot-instructions.md` before making changes.

## Bad
The project conventions are:
- Use TypeScript strict mode
- Prefer functional components
- Use Tailwind CSS for styling
[repeating what's already in copilot-instructions.md]
```

### 5. Tool-Assisted Context
Let the agent gather context via tools rather than pre-loading it.

```markdown
## Good
1. Search the codebase for related implementations
2. Read the relevant test files
3. Check for existing patterns

## Bad (tries to pre-describe the codebase)
The codebase has a src/ directory with components/ for React components,
services/ for API calls, utils/ for helpers...
```

## Context Priority

When context is tight, prioritize in this order:
1. **Agent identity and responsibilities** (always needed)
2. **Current task context** (what the user asked for)
3. **Relevant file contents** (gathered via tools)
4. **Domain knowledge** (from skills, loaded on demand)
5. **Historical context** (conversation history — oldest gets trimmed first)

## Multi-Agent Context Tips

- **Orchestrators**: Keep lean — just coordination logic, no domain details
- **Specialists**: Can be more detailed in their specific domain
- **Shared knowledge**: Put in `.instructions.md` files, not duplicated across agents
- **Pass-by-reference**: Send file paths to sub-agents, not file contents
