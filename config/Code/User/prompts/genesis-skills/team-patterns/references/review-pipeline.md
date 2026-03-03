# Code Review Pipeline Pattern

A multi-agent review pipeline where specialized reviewers examine code from different angles, then an aggregator produces the final verdict.

## Architecture

```
Orchestrator
  ├→ Security Reviewer ──→ security_report
  ├→ Quality Reviewer ───→ quality_report
  ├→ Performance Reviewer → perf_report
  └→ Review Aggregator (input: all reports) → final_verdict
```

## Agent Definitions

### Security Reviewer
- **Focus**: Vulnerabilities, injection risks, auth issues, secrets exposure
- **Tools**: `read/readFile`, `search/textSearch`, `search/codebase`, `read/problems`
- **Output**: Security findings with severity (critical/high/medium/low)

### Quality Reviewer
- **Focus**: Code patterns, SOLID principles, DRY, naming, complexity
- **Tools**: `read/readFile`, `search/codebase`, `search/usages`, `read/problems`
- **Output**: Quality findings with improvement suggestions

### Performance Reviewer
- **Focus**: Algorithmic complexity, memory leaks, N+1 queries, bundle size
- **Tools**: `read/readFile`, `search/codebase`, `search/textSearch`
- **Output**: Performance findings with benchmarks or estimates

### Review Aggregator
- **Focus**: Combine all reports into a unified verdict
- **Tools**: `read/readFile`, `edit/editFiles`
- **Output**: Final review with approve/request-changes/block recommendation

## Invocation Example

```markdown
## Step 1: Security Review
Delegate to `security-reviewer.agent.md`:
"Review the changes in `${changes}` for security vulnerabilities. Focus on injection, auth, and data exposure. Return findings as a structured report."

## Step 2: Quality Review (parallel with Step 1)
Delegate to `quality-reviewer.agent.md`:
"Review the changes in `${changes}` for code quality. Focus on patterns, complexity, naming, and maintainability."

## Step 3: Performance Review (parallel with Steps 1-2)
Delegate to `performance-reviewer.agent.md`:
"Review the changes in `${changes}` for performance implications. Focus on algorithmic complexity and resource usage."

## Step 4: Aggregate (after Steps 1-3 complete)
Delegate to `review-aggregator.agent.md`:
"Aggregate the security, quality, and performance reports. Produce a final verdict with categorized findings."
```

## When to Use

- Pull request reviews for critical codebases
- Pre-merge quality gates
- Compliance-sensitive projects
- Large changesets that benefit from parallel analysis
