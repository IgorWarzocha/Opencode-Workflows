<instructions>
## Verification & Dev Flow
This project is a **Workflow Selector CLI** built with Bun, Solid.js, and OpenTUI.
- **Type Check**: `bun x tsc --noEmit` (MANDATORY verification command).
- **Execution**: `bun run src/index.tsx` (PROHIBITED; direct execution is for users only).
- **Dev Mode**: `bun run --watch src/index.tsx` (PROHIBITED; long-running process).
- **Constraints**: MUST NOT run `bun run src/index.tsx` or `bun run dev`. MUST use one-shot verification commands like `tsc`.
</instructions>

<rules>
## Technical Conventions
- **Solid.js + OpenTUI**: Uses `@opentui/solid` for TUI rendering. Follow Solid.js reactive patterns (`createSignal`, `createMemo`, `Show`, `For`).
- **Keyboard Handling**: Use the `useKeyboard` hook from `@opentui/solid` for input management.
- **Registry Management**: Interacts with `registry.json` at the repository root. Uses `fs-extra` for file operations.
- **RFC 2119**: MUST use uppercase keywords (MUST, SHOULD, MAY) for requirements.
</rules>

<routing>
## Task Navigation
| Feature | Path |
|---------|------|
| TUI Components & UI Logic | `src/index.tsx` |
| Sync & File Ops Logic | `src/index.tsx` (see `performSync`) |
| Registry Definition | `../registry.json` |
| TS Configuration | `tsconfig.json` |
</routing>

<context>
## Architecture Details
- **Path Resolution**: The app resolves `ROOT_DIR` relative to `src/index.tsx` (pointing two levels up).
- **Registry Structure**: Supports `packs` (collections) and `standalone` items (agents, skills, commands, docs).
- **Target Paths**: Specialized items are automatically prefixed with `.opencode/` unless already present.
</context>
