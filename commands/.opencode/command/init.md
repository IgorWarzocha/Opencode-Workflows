---
description: Init high-density docs
---

!`ls -F`

<context>
@AGENTS.md
User guidance: $ARGUMENTS
</context>

<objective>
Create or intelligently enhance AGENTS.md for this codebase.
Target a high-density output of ~50 lines. Focus on mapping technical facts while excluding environment boilerplate.

Philosophy: **ENHANCEMENT over REPLACEMENT**. Human-crafted content is sacred unless explicitly told otherwise. HOWEVER, generic or outdated boilerplate that violates current repository standards MUST be rewritten or removed.
</objective>

<clarification>
<question_tool>
**Batching Rule:** Use ONLY for 2+ related questions; single questions MUST use plain text.

**Syntax Constraints:** header max 12 chars, labels 1-5 words, mark defaults with `(Recommended)`.

**Purpose:** Clarify mode (create/enhance/replace) and focus areas when `$ARGUMENTS` is empty or vague.
</question_tool>

## Initial Clarification

If `$ARGUMENTS` is empty or vague, the agent SHOULD use the `question` tool before proceeding:

```json
{
  "questions": [
    {
      "question": "What kind of AGENTS.md setup do you need?",
      "header": "Mode",
      "options": [
        { "label": "Create new (Recommended)", "description": "Generate fresh AGENTS.md for this repo" },
        { "label": "Enhance existing", "description": "Improve current AGENTS.md without major rewrites" },
        { "label": "Replace", "description": "Start from scratch, ignore existing content" }
      ]
    },
    {
      "question": "Any specific focus areas?",
      "header": "Focus",
      "options": [
        { "label": "Full coverage", "description": "Document entire repo" },
        { "label": "Build/test commands", "description": "Focus on dev workflow" },
        { "label": "Code style", "description": "Focus on conventions" }
      ]
    }
  ]
}
```

If user provided detailed guidance in `$ARGUMENTS`, the agent MAY proceed directly.
</clarification>

<instructions>

## Step 0: Identify Verification Commands

Before creation, the agent SHOULD identify "one-shot" equivalents for common dev tasks:

- **Priority**: The agent SHOULD prefer type-checking over full builds (e.g., `tsc --noEmit` is STRONGLY PREFERRED over `npm run build`).
- **Missing Tools**: If no one-shot type-check or lint command is found, the agent MUST recommend setting one up in the "Dev Flow" section or as a follow-up.
- **Substitution Examples**:
  - Instead of `npm run dev` -> Use `npm run typecheck` or `npm run build`.
  - Instead of `jest --watch` -> Use `jest`.
  - Instead of `convex dev` -> Use `convex codegen`.
    These MUST be the only commands documented in the Build & Test section.

## Step 1: Assess Repository Complexity

1. Quickly gauge the codebase:
   - Count top-level directories, check for monorepo patterns (workspaces, packages/).
   - Check dependency count in package.json, pyproject.toml, Cargo.toml, etc.
   - Look for multiple languages or frameworks.
2. **If complex** (monorepo, 10+ deps, multiple languages, or large codebase):
   - The agent MUST use the Task tool with `explore` subagent FIRST to analyze the repository.
   - Instruct the subagent: "Analyze this repository structure, build systems, test commands, and coding conventions. Return a structured summary."
3. **If simple**: Proceed directly.

## Step 2: Evaluate Existing AGENTS.md and Choose Mode

### Mode A: CREATE

**Trigger**: No AGENTS.md or empty file.

- Create fresh. An output length of ~50 lines is STRONGLY RECOMMENDED.

### Mode B: ENHANCE

**Trigger**: AGENTS.md exists, <50 lines, appears auto-generated or minimal.

- **Allowed**:
  - Restructure and reorganize sections for better flow.
  - Target an output length of ~50 lines (STRONGLY RECOMMENDED).
  - Rewrite generic boilerplate into more specific, useful guidance.
  - **CRITICAL**: If existing content is non-compliant with current standards or contains obsolete patterns, the agent MUST rewrite it.
  - Replace vague descriptions with concrete commands and examples.
- **Still respect**:
  - Any accurate factual information (working commands, correct paths).
  - Project-specific details that were correctly captured.
  - Information that would be lost and is hard to rediscover.

### Mode C: PRESERVE

**Trigger**: AGENTS.md is >50 lines OR shows clear human authorship.

- **Detection signals**: Custom headings, specific team conventions, detailed explanations, comments/TODOs, references to team members, opinionated style choices.
- **STRICT RULES for Mode C**:
  1. The `write` tool is FORBIDDEN — the agent MUST use the `edit` tool only.
  2. Touch ONLY outdated factual information (non-working commands, non-existent paths, incorrect versions, dead links).
  3. The agent MUST NOT touch style guidelines, architectural decisions, workflow descriptions, or opinionated guidance.
  4. **When uncertain: DO NOTHING** — report uncertainty, MUST NOT modify.

## Step 3: Content Focus and Exclusions

Target high-density mapping. STRONGLY RECOMMENDED to stay under 50 lines.

### MUST INCLUDE:

1. **Dev Flow**: Build/lint/test commands—specifically how to run a single test.
2. **One-Shot Verification**: Document ONLY "one-shot" commands.
3. **Missing Tooling**: If essential verification commands are missing, the agent MUST recommend their implementation.
4. **Safety (Process Constraints)**: The agent MUST explicitly forbid long-running/blocking processes (dev servers, watch modes).
5. **Unique Patterns**: Focus on code patterns, variable naming, or architectural quirks unique to this repo.

### MUST EXCLUDE:

1. **Environment Metadata**: MUST NOT include date, OS, or absolute project root paths.
2. **Access Constraints**: Identify paths/files that are **read-only** or **restricted** for AI modification (e.g., legacy zones, vendor directories, specific configs). Identify any user-specified preferences regarding files or spaces the agent SHOULD NOT edit.
3. **Nested AGENTS.md**: MUST NOT duplicate content from nested AGENTS.md files.
4. **Generic Navigation**: MUST NOT include project structure lists that merely repeat the file tree.

</instructions>

<rules>
- The agent MUST NOT re-read AGENTS.md.
- The agent MUST default to preservation; enhancement is the goal, not replacement.
- Output length of ~50 lines is STRONGLY RECOMMENDED.
- The agent MUST NOT repeat environment data or standard tool instructions.
- The agent MUST use RFC 2119 keywords in generated content.
- The agent MAY use XML tags for structure in complex repositories.
- The agent MUST report what was preserved and what was changed.
</rules>
