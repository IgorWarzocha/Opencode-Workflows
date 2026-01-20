---
name: agent-navigation-sop
description: |-
  Generate AGENTS.md for AI agent navigation. Covers build/test commands, coding conventions, task routing, and codebase structure. Use for /init workflow or when creating agent-readable repository documentation.
  
  Examples:
  - user: "/init" → full AI navigation AGENTS.md + skill recommendations
  - user: "/init basic" → minimal AGENTS.md structure only
  - user: "Create AGENTS.md for this repo" → assess complexity, generate navigation doc
  - user: "Document codebase for AI agents" → structured AGENTS.md with task routing
---

# Agent Navigation SOP

Standard operating procedure for generating AGENTS.md files optimized for AI agent consumption.

<workflow>

## Phase 1: Complexity Assessment (MANDATORY)

MUST complete before any other action:

1. **Directory scan**: `ls -la` at root, count top-level directories
2. **Monorepo check**: Look for `packages/`, `workspaces/`, `apps/`, multiple `package.json`
3. **Dependency count**: Scan `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`
4. **Language detection**: Identify primary and secondary languages

**Complexity thresholds:**
| Indicator | Simple | Complex |
|-----------|--------|---------|
| Top-level dirs | ≤10 | >10 |
| Dependencies | ≤50 | >50 |
| Languages | 1 | 2+ |
| Monorepo patterns | None | Present |

## Phase 2: Analysis Method

Based on complexity:

- **Simple repo**: Proceed directly with glob/read tools
- **Complex repo**: MUST dispatch explore subagent:
  ```
  Task tool with subagent_type: "explore"
  Prompt: "Analyze repository structure, build systems, test commands, coding conventions.
           Return structured summary for AI navigation AGENTS.md.
           Thoroughness: [quick|medium|very thorough]"
  ```

## Phase 3: Information Gathering

Collect from repo:
- [ ] Build commands (`npm run build`, `make`, `cargo build`, etc.)
- [ ] Test commands (unit, integration, e2e)
- [ ] Lint/format commands
- [ ] Type checking commands
- [ ] Code generation commands (e.g., `convex codegen`, `prisma generate`)
- [ ] Entry points (main files, CLI commands)
- [ ] Configuration files (tsconfig, eslint, prettier, etc.)
- [ ] Key directories and their purposes
- [ ] Coding conventions (from existing code patterns)
- [ ] **Existing AI rules** - check for and incorporate:
  - `.cursor/rules/` directory
  - `.cursorrules` file
  - `.github/copilot-instructions.md`
  - Any other AI assistant configuration

<blocking_processes_rule>

## CRITICAL: Long-Running Processes

**The generated AGENTS.md MUST include a rule forbidding agents from running blocking processes.**

This is not just about what commands to document - the AGENTS.md must explicitly instruct agents:

```markdown
<rules>
## Process Constraints
- MUST NOT run long-running/blocking processes (dev servers, watch modes)
- Dev servers (`npm run dev`, `bun dev`, `convex dev`, etc.) are USER's responsibility
- User will run these in background and make them available to the agent
- MUST use one-shot commands for verification (build, lint, test, typecheck)
</rules>
```

**Commands to document vs avoid:**

| MUST NOT Document | Document Instead |
|-------------------|------------------|
| `npm run dev` | `npm run build` |
| `bun run dev` | `npm run lint` |
| `npm start` (if blocking) | `npm run typecheck` |
| `convex dev` | `convex codegen` |
| `next dev` | `next build` |
| `vite` / `vite dev` | `vite build` |
| `tsc --watch` | `tsc --noEmit` |
| `jest --watch` | `jest` / `npm test` |

**Good commands for AGENTS.md:**
- One-shot builds: `npm run build`, `make`, `cargo build`
- Linting: `npm run lint`, `eslint .`, `oxlint`
- Type checking: `tsc --noEmit`, `pyright`
- Testing: `npm test`, `pytest`, `go test ./...`
- Code generation: `convex codegen`, `prisma generate`, `graphql-codegen`
- Formatting: `prettier --check .`, `cargo fmt --check`

</blocking_processes_rule>

## Phase 4: AGENTS.md Generation

Structure using XML tags:

```markdown
## Repository Overview
[1-2 sentences: what this repo does]

<instructions>
## Build & Test
- Build: `exact command`
- Test: `exact command`
- Lint: `exact command`
- Typecheck: `exact command`
- Codegen: `exact command` (if applicable)
</instructions>

<rules>
## Process Constraints
- MUST NOT run long-running/blocking processes (dev servers, watch modes)
- Dev servers are USER's responsibility to run in background
- MUST use one-shot verification commands only

## Coding Conventions
- [Pattern observed in codebase]
- [Naming conventions]
- [File organization rules]
</rules>

<routing>
## Task Navigation
| Task | Entry Point | Key Files |
|------|-------------|-----------|
| Add feature | src/features/ | README in dir |
| Fix bug | src/ | Related test file |
</routing>

<context_hints>
## Context Allocation
- **Large/generated**: [files to skip or skim]
- **Legacy zones**: [directories with tech debt]
- **Critical configs**: [files that break everything]
</context_hints>
```

## Phase 5: Skill Recommendations (Full Mode Only)

If running full workflow (not basic):

1. Identify repetitive tasks in the codebase
2. Suggest skills that would benefit agents working here
3. Offer to create skills using `skill-creator`

</workflow>

<instructions>

- MUST assess complexity before choosing analysis method
- MUST use explore subagent for complex repositories
- MUST verify all file paths exist before referencing
- MUST use exact, copy-pasteable commands
- MUST use RFC 2119 keywords (MUST, SHOULD, MAY) in generated content
- MUST use XML tags for section boundaries
- MUST NOT include long-running/blocking processes (dev servers, watch modes)
- MUST document one-shot verification commands (build, lint, test, typecheck, codegen)
- SHOULD incorporate existing AI rules if present
- SHOULD keep output ~150 lines for new files
- MUST NOT include prose that doesn't change agent behavior
- MUST NOT reference files/directories without verifying they exist
- MUST NOT guess at commands - verify against package.json, Makefile, etc.

</instructions>

<quality_checklist>

- [ ] Complexity assessed FIRST
- [ ] Explore subagent used for complex repos
- [ ] All paths verified to exist
- [ ] Commands are exact (copy-pasteable)
- [ ] NO blocking/long-running processes included
- [ ] One-shot commands for build/lint/test/typecheck documented
- [ ] XML tags used for section boundaries
- [ ] RFC 2119 keywords used appropriately
- [ ] No prose that doesn't change agent behavior

</quality_checklist>
