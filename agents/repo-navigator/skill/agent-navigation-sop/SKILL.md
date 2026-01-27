---
name: agent-navigation-sop
description: |-
  Generate AGENTS.md for AI agent navigation. Covers build/test commands, coding conventions, task routing, and codebase structure. Use proactively during /init workflow or when creating agent-readable repository documentation.

  Examples:
  - user: "/init" → full AI navigation AGENTS.md + skill recommendations
  - user: "/init basic" → minimal AGENTS.md structure only
  - user: "Create AGENTS.md for this repo" → assess complexity, generate navigation doc
  - user: "Document codebase for AI agents" → structured AGENTS.md with task routing
---

# Agent Navigation SOP

This SOP COMPLEMENTS the `/init` command by providing deep-dive mapping for developer-facing AGENTS.md files.

<workflow>
## Phase 1: Deep Analysis
The agent SHOULD skip basic directory scans (opencode already sees the tree) and focus on:

1. **Tooling & Scripts**: Identify one-shot commands for Build, Test, Lint, and Typecheck.
2. **Process Constraints**: Identify dev servers and watch-modes to EXCLUDE.
3. **Conventions**: Identify project-specific naming, architectural patterns, and unique error handling.

## Phase 2: AGENTS.md Composition
Target a high-density output of ~50 lines.

### 1. Build & Test (Instructions)
- List copy-pasteable, one-shot commands.
- **MUST NOT** include `dev`, `watch`, or interactive commands.

### 2. Constraints & Patterns (Rules)
- **CRITICAL**: The agent MUST explicitly forbid running blocking processes (dev servers, watch modes).
- Identify **read-only** or **restricted** paths that agents SHOULD NOT modify.
- Document repository-specific coding patterns (e.g., "Use Bun APIs", "Prefer functional over class").

### 3. Task Routing (Routing)
- Map common tasks (feature addition, bug fix) to specific directories and related tests.
- Reference nested `AGENTS.md` files for package-level details instead of duplicating them.
- Identify repetitive tasks and SHOULD suggest creating new skills using `skill-creator` to extend agent capabilities.
</workflow>

<instructions>
- The agent MUST NOT repeat environment metadata (date, OS, absolute paths).
- Output length of ~50 lines is STRONGLY RECOMMENDED.
- The agent MUST use RFC 2119 keywords (MUST, MUST NOT, SHOULD, STRONGLY RECOMMENDED).
- The agent MUST prioritize "Access Constraints" (read-only files/folders).
- The agent MUST NOT document long-running/blocking processes.
- The agent MUST document one-shot verification commands (build, lint, test, typecheck, codegen).
- The agent MUST NOT include prose that does not change agent behavior.
</instructions>
