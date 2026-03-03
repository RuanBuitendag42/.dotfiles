# Anti-Patterns

Common mistakes when writing agent prompts and how to avoid them.

## 1. The "Do Everything" Agent

**Problem**: Agent has no focus, tries to handle all tasks.

```markdown
## Bad
You are a helpful coding assistant. You can write code, review code,
debug issues, write tests, deploy applications, manage databases,
and handle any other programming task.
```

**Fix**: Give the agent a specific role with clear boundaries.
```markdown
## Good
You are a test engineer. Your purpose is to write comprehensive unit
and integration tests for the codebase. You do NOT implement features
or fix bugs — hand those to the Developer agent.
```

## 2. The "Wall of Text" Agent

**Problem**: Agent spec is thousands of characters of prose.

**Fix**: Use structured formatting with headers, bullets, and numbered lists. Offload details to skills.

## 3. The "Wish List" Agent

**Problem**: Guidelines use soft language that the model can ignore.

```markdown
## Bad
- Try to write clean code
- You should probably run the tests
- It would be nice to check for errors
```

**Fix**: Use imperative, specific instructions.
```markdown
## Good
- Write clean code following the project style guide
- Run the full test suite after every change
- Check for compile errors before proceeding
```

## 4. The "Copy-Paste" Agent

**Problem**: Multiple agents have identical sections duplicated.

**Fix**: Extract shared knowledge into `.instructions.md` files with appropriate `applyTo` patterns. Each agent spec should be unique.

## 5. The "Black Box" Agent

**Problem**: Agent has no workflow defined, just responsibilities.

```markdown
## Bad
## Responsibilities
- Review code
- Find bugs
- Report issues
```

**Fix**: Add explicit workflow steps.
```markdown
## Good
## Workflow
1. Read the changed files using `search/changes`
2. Analyze each file for security vulnerabilities
3. Cross-reference with known patterns in the security skill
4. Report findings with file path, line number, and severity
5. If critical issues found, recommend blocking the PR
```

## 6. The "Tool Hoarder" Agent

**Problem**: Agent has every tool enabled when it only needs a few.

**Fix**: Apply least privilege — only list the tools the agent actually needs.

## 7. The "Personality Override" Agent

**Problem**: So much personality text that the actual instructions get diluted.

**Fix**: Keep personality to 2-3 lines max. Personality enhances instructions, it doesn't replace them.

## 8. The "No Handoff" Agent

**Problem**: Agent tries to handle edge cases outside its role instead of delegating.

**Fix**: Define explicit handoff triggers.
```markdown
## Handoff Rules
- If implementation needed → Developer agent
- If architecture decision needed → Architect agent
- If unclear requirements → ask the user
```

## 9. The "Static" Agent

**Problem**: Agent never references external context or uses tools for research.

**Fix**: Instruct the agent to gather context before acting.
```markdown
## Workflow
1. Search the codebase for related code before making changes
2. Read existing tests to understand testing patterns
3. Check `.github/copilot-instructions.md` for project conventions
```

## 10. The "Infinite Loop" Agent

**Problem**: Agent keeps refining without a termination condition.

**Fix**: Define clear completion criteria.
```markdown
## Completion Criteria
- All required files have been created
- Validation passes with no errors
- No TODO comments remain in generated code
- Summary of work has been reported
```
