---
name: validation-rules
description: 'Complete validation rulebook for Copilot files — frontmatter schemas, naming conventions, size limits, and tool alias registry'
---

# Validation Rules Skill

You are using this skill to validate Copilot customization files. Every file MUST pass all applicable rules before deployment.

## Validation Checklist

For every generated file, check these in order:

### 1. Filename Validation
- [ ] Uses `lowercase-with-hyphens` pattern (except `SKILL.md` which is uppercase)
- [ ] Only contains allowed characters: `.`, `-`, `_`, `a-z`, `A-Z`, `0-9`
- [ ] Has the correct extension for its type
- [ ] No spaces in filenames

**Regex**: `^[a-zA-Z0-9][a-zA-Z0-9._-]*\.(agent|instructions|prompt)\.md$`
**SKILL.md regex**: `^SKILL\.md$`

### 2. Frontmatter Validation
- [ ] Starts with `---` on line 1
- [ ] Ends with `---` before body content
- [ ] Valid YAML syntax between fences
- [ ] All REQUIRED fields are present
- [ ] String values use single quotes in YAML
- [ ] No trailing whitespace in values

### 3. Content Validation
- [ ] Body contains meaningful instructions (not just placeholders)
- [ ] File size is within recommended limits
- [ ] No broken internal references (handoff targets, skill references)
- [ ] Uses imperative mood for instructions
- [ ] Structured with headers, bullet points for scannability

### 4. Placement Validation
- [ ] File is in the correct directory for its type
- [ ] No naming conflicts with existing files
- [ ] Directory structure follows conventions

## Reference Material

See `references/` for detailed schemas:
- `frontmatter-schemas.md` — Required/optional fields per file type
- `naming-conventions.md` — Filenames, folder names, allowed characters
- `size-limits.md` — Character limits per file type
- `tool-alias-registry.md` — All known VS Code tool aliases

## Severity Levels

- **ERROR**: File will not work — MUST be fixed before deployment
- **WARNING**: File may have issues — SHOULD be fixed
- **INFO**: Suggestion for improvement — nice to have

| Check | Severity |
|-------|----------|
| Missing required frontmatter field | ERROR |
| Wrong file extension | ERROR |
| Spaces in filename | ERROR |
| Invalid YAML syntax | ERROR |
| Missing optional but recommended field | WARNING |
| File exceeds size limit | WARNING |
| Non-existent handoff target | WARNING |
| Placeholder content not replaced | WARNING |
| Could use more specific applyTo glob | INFO |
| Could reduce tool list scope | INFO |
