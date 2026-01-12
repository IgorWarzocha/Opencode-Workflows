# Validation Rules

## YAML Frontmatter Schema

All `.md` files in `agent/`, `command/`, or `skill/` directories MUST have valid YAML frontmatter:

```yaml
---
description: string (REQUIRED)
mode: string (optional, enum: [primary, all, subagent])
subtask: boolean (optional)
permission:
  skill:
    "*": "deny"              # MUST be deny
    "skill-name": "allow"    # Whitelist specific skills
---
```

### YAML Syntax Requirements
- Use spaces, not tabs
- Multi-line descriptions MUST use `|-` literal block scalar
- Values with colons MUST be quoted or use block scalar

## Description Patterns

### Primary Agents (mode: primary)
Description MUST be exactly **3 words**.

✅ Good: `Repository health custodian.`
❌ Bad: `Expert architect strictly following the Component Engineering Specification.`

### Non-Primary Agents (mode: all, subagent, or unset)
Description MUST include:
- Role/action summary
- `Use when [trigger contexts]`
- Trigger examples: `user: "query" → action`

Template (MUST use `|-` block scalar):
```yaml
description: |-
  [Role/Action]. Use when [triggers].
  
  Examples:
  - user: "query" → action
  - user: "query" → action
```

### Skills (SKILL.md)
Description MUST include:
- Action verb/capabilities (NOT "You are..." or role descriptions)
- `Use for [specific cases]` or `Use proactively when [contexts]`
- 3-5 examples in format: `user: "..." → action`

Template (MUST use `|-` block scalar):
```yaml
description: |-
  [Action/capabilities]. Use for [specific cases]. Use proactively when [contexts].
  
  Examples:
  - user: "query" → action
  - user: "query" → action
  - user: "query" → action
```

### Commands
Description SHOULD be concise (3-5 words), shown in `/help` list.

✅ Good: `Run tests and fix failures`
❌ Bad: `Orchestrate task tool subagents with checklist verification and stateful loops`

## RFC 2119 + XML Compliance

### RFC 2119 Keywords
Agent and skill bodies SHOULD use RFC 2119 keywords for requirements:
- `MUST` - Absolute requirement
- `SHOULD` - Strong recommendation
- `MAY` - Optional

### XML Tags
Agent and skill bodies SHOULD use XML tags for structure:
- `<role>` - Agent identity
- `<instructions>` - Core directives
- `<workflow>` - Step-by-step process
- `<constraints>` - Limitations
- `<examples>` - Few-shot demos

## Running Audits

When running `audit_repo.py` or `sync_docs.py`:
- MUST NOT use `head`, `tail`, or any output limits
- MUST NOT truncate output with pipes or redirects
- MUST review the complete output to ensure all issues are captured

Incomplete audits defeat the purpose of validation.

## Post-Audit Workflow

When an audit fails (errors or warnings found):

1. **Read the affected files** - MUST read each file listed in the audit output
2. **Analyze the issues** - Understand what changes would fix each issue
3. **Use question tool** - MUST ask the user which files/issues to address
4. **Wait for confirmation** - MUST NOT auto-fix all issues without user approval

### Question Tool Usage (REQUIRED)

After a failed audit, present findings using the question tool:

```json
{
  "questions": [
    {
      "question": "Which issues should I fix?",
      "header": "Audit Fix",
      "multiple": true,
      "options": [
        { "label": "file-name.md", "description": "Brief issue description" },
        { "label": "another-file.md", "description": "Brief issue description" },
        { "label": "Fix all errors", "description": "Auto-fix all errors only" },
        { "label": "Skip for now", "description": "Do not fix anything" }
      ]
    }
  ]
}
```

### Why This Matters

- Mass auto-fixes can introduce unintended changes
- Some "issues" may be intentional design choices
- User maintains control over their repository
- Prevents breaking changes to working configurations

## Directory Structure

This repository contains reusable agent templates and workflow patterns.

### Root Structure
- `.opencode/` - Root-level agents, commands, and skills for this repo
- `agents/` - Categorized agent template packages (each is a self-contained example)

### Agent Template Packages
Each package in `agents/<category>/` is a standalone example:
```
agents/<category>/
├── .opencode/
│   ├── agent/       # Agent definitions
│   ├── command/     # Related commands
│   └── skill/       # Supporting skills
├── README.md        # Package documentation (optional)
└── [other files]    # Reference docs, examples
```

### Skill Structure
Skills MUST follow this layout:
```
skill/<name>/
├── SKILL.md         # Required - name MUST match directory
├── scripts/         # Optional - Python/Bash utilities
├── references/      # Optional - docs loaded on-demand
└── assets/          # Optional - templates, static files
```

Skill directory name MUST match `name:` field in SKILL.md frontmatter.

## Integrity Checks

- `@path` references in markdown files MUST resolve to existing files.
- `subagent_type` in Task calls MUST match a known agent or model.
