# Instructions Template

Use this for auto-applied coding rules scoped to specific file patterns.

```yaml
---
applyTo: "[glob pattern — e.g., **/*.ts]"
description: "[What these rules enforce — be specific]"
---

# [Instructions Title]

## Overview

[Brief explanation of purpose and WHY these rules exist]

## Rules

### [Category 1]

1. [Rule] — [reasoning]
2. [Rule] — [reasoning]

### [Category 2]

1. [Rule] — [reasoning]
2. [Rule] — [reasoning]

## Examples

### ✅ Good

\`\`\`[language]
[good example code]
\`\`\`

### ❌ Bad

\`\`\`[language]
[bad example code — explain why it's bad]
\`\`\`
```

## Key Principles for Instructions

1. **Include reasoning** — "Use `date-fns` instead of `moment.js` — moment is deprecated and adds 70KB"
2. **Focus on non-obvious rules** — skip what linters already enforce
3. **Show both good and bad examples** — concrete is better than abstract
4. **Scope narrowly with `applyTo`** — don't use `**` unless truly global
5. **Keep it short** — instructions are always-on, so every line costs context tokens
