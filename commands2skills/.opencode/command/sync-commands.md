---
description: Update command index
subtask: true
---

<instructions>

Synchronize COMMANDS.md with the actual command files:

1. Read all `.opencode/command/*.md` files
2. Extract the `description` from each file's YAML frontmatter
3. Update COMMANDS.md:
   - Add missing commands using format below
   - Remove entries for deleted commands
   - Preserve existing structure and formatting

</instructions>

<format>

Each command entry MUST follow this format:

```markdown
### `.opencode/command/name.md`
**Description:** [description from frontmatter]
```

</format>

<rules>

- MUST use surgical edits—do not rewrite the entire file
- MUST preserve the "How to Use Commands" section
- MUST NOT remove content unless the command file no longer exists
- If COMMANDS.md is missing, create it with the standard structure

</rules>
