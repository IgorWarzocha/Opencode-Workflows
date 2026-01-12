# Repository Maintenance Standards

## Documentation Synchronization
- **Trigger**: Run whenever agents or commands are added/modified.
- **Scope**: 
  - Root `AGENTS.md` must list high-level agents.
  - Nested `AGENTS.md` (e.g., `agents/generic/.opencode/agent/`) should be indexed.
  - `COMMANDS.md` must reflect all available `.md` commands in the path.
- **Format**: Use Markdown tables for listings with columns: Name, Description, Type (Agent/Command), Status.

## Quality Assurance
- **RFC 2119**: Agents MUST use "MUST", "SHOULD", "MAY" for critical instructions.
- **XML Tags**: Prompt sections MUST be wrapped in XML tags (e.g., `<instructions>`, `<workflow>`).
- **Frontmatter**: All assets MUST have valid YAML frontmatter with `description`.

## File Naming
- All files SHOULD use `kebab-case`.
- Agent files: `descriptive-name.md`
- Command files: `verb-noun.md` (e.g., `sync-docs.md`)
