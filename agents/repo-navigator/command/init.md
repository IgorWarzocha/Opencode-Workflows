---
description: Initialize repository documentation
agent: repo-navigator
---

<workflow_mode>

## Argument Routing: $1

| Argument | Workflow | Skill to Load |
|----------|----------|---------------|
| (empty)  | Full: AI navigation + skill recommendations | `agent-navigation-sop` |
| `basic`  | Minimal: AGENTS.md structure only | `agent-navigation-sop` |
| `user`   | User assistance: setup, install, troubleshoot | `user-onboarding-sop` |

**MANDATORY**: Load the appropriate skill using the `skill` tool BEFORE proceeding with the workflow below.

If `$1` = `user`, skip the AI navigation workflow entirely and execute the `user-onboarding-sop` skill.

</workflow_mode>

<context>
Current AGENTS.md (if any):

@AGENTS.md

User guidance: $ARGUMENTS
</context>

<objective>
Create or intelligently enhance AGENTS.md for this codebase.

Philosophy: **ENHANCEMENT over REPLACEMENT**. Human-crafted content is sacred unless explicitly told otherwise.

**Full mode** (no arg): After AGENTS.md creation, recommend relevant skills and offer to create them using `skill-creator`.
**Basic mode** ($1=basic): Stop after AGENTS.md creation, skip skill recommendations.
</objective>

<clarification>

<question_tool>

**Batching Rule:** Use only for 2+ related questions; single questions use plain text.

**Syntax Constraints:** header max 12 chars, labels 1-5 words, mark defaults with `(Recommended)`.

**Purpose:** Clarify mode (create/enhance/replace) and focus areas when `$ARGUMENTS` is empty or vague.

</question_tool>

## Initial Clarification (unless user provides detailed args)

If `$ARGUMENTS` is empty or vague, use the `question` tool before proceeding:

```json
{
  "questions": [
    { "question": "What kind of AGENTS.md setup do you need?", "header": "Mode", "options": [
      { "label": "Create new (Recommended)", "description": "Generate fresh AGENTS.md for this repo" },
      { "label": "Enhance existing", "description": "Improve current AGENTS.md without major rewrites" },
      { "label": "Replace", "description": "Start from scratch, ignore existing content" }
    ]},
    { "question": "Any specific focus areas?", "header": "Focus", "options": [
      { "label": "Full coverage", "description": "Document entire repo" },
      { "label": "Build/test commands", "description": "Focus on dev workflow" },
      { "label": "Code style", "description": "Focus on conventions" }
    ]}
  ]
}
```

If user provided detailed guidance in `$ARGUMENTS`, MAY proceed directly.

</clarification>

<instructions>

## Step 1: Assess Repository Complexity

Quickly gauge the codebase:
- Count top-level directories, check for monorepo patterns (workspaces, packages/)
- Check dependency count in package.json, pyproject.toml, Cargo.toml, etc.
- Look for multiple languages or frameworks

**If complex** (monorepo, 10+ deps, multiple languages, or large codebase):
- MUST use the Task tool with `explore` subagent first to thoroughly analyze the repository
- Instruct the subagent: "Analyze this repository structure, build systems, test commands, and coding conventions. Return a structured summary."

**If simple**: Proceed directly.

## Step 2: Evaluate Existing AGENTS.md and Choose Mode

### Mode A: CREATE
**Trigger:** No AGENTS.md or empty file

- Create fresh (~150 lines)
- Full creative freedom

### Mode B: ENHANCE
**Trigger:** AGENTS.md exists, <150 lines, appears auto-generated or minimal

This is the **middle ground** - more freedom than preservation, but informed by what's there.

**Allowed:**
- Restructure and reorganize sections for better flow
- Rewrite generic boilerplate into more specific, useful guidance
- Replace vague descriptions with concrete commands and examples
- Expand thin sections with proper detail
- Remove redundant or unhelpful content

**Still respect:**
- Any accurate factual information (working commands, correct paths)
- Project-specific details that were correctly captured
- Information that would be lost and is hard to rediscover

**Approach:** Treat the existing file as research notes, not as a document to preserve. Extract what's useful, discard what's generic, and produce a proper AGENTS.md.

### Mode C: PRESERVE
**Trigger:** AGENTS.md is >150 lines OR shows clear human authorship

**Detection signals for human authorship:**
- Custom section headings beyond standard boilerplate
- Specific team conventions or project-specific terminology
- Detailed explanations beyond generic descriptions
- Comments, notes, or TODOs indicating ongoing maintenance
- References to specific team members, processes, or decisions
- Opinionated style choices (naming conventions, error handling philosophy, etc.)

**STRICT RULES for Mode C:**

1. **Write tool is FORBIDDEN** - MUST use Edit tool only
2. **Touch ONLY outdated factual information:**
   - Commands that no longer work (verify against package.json scripts, Makefile, etc.)
   - File paths that no longer exist (verify with filesystem)
   - Dependency versions if explicitly listed and now incorrect
   - Dead links to documentation
3. **MUST NOT touch:**
   - Style guidelines and conventions (intentional choices)
   - Architectural decisions or explanations
   - Workflow descriptions
   - Any section with opinionated guidance
   - Anything that looks like a team decision
   - Prose that has a human voice
4. **When uncertain: DO NOTHING** - report the uncertainty, do not modify
5. **After completion:** Summarize what you preserved and why you left it alone

**Override keywords in user guidance:** "rewrite", "replace", "start fresh", "from scratch" → switch to Mode A

## Step 3: Content to Include (for CREATE and ENHANCE modes)

When creating or enhancing, cover:

1. **Build/lint/test commands** - especially how to run a single test
2. **Code style guidelines** - imports, formatting, types, naming, error handling
3. **Existing AI rules** - incorporate `.cursor/rules/`, `.cursorrules`, `.github/copilot-instructions.md` if present

## Step 4: Skill Recommendations (Full Mode Only)

**Skip this step if `$1` = `basic`.**

After AGENTS.md is complete:

1. Identify repetitive tasks in the codebase that would benefit from skills
2. Suggest 3-5 skills that would help agents working in this repo
3. Ask user if they want to create any skills
4. If yes, load `skill-creator` and guide through creation

</instructions>

<rules>

- MUST NOT re-read AGENTS.md; it is already included above via @AGENTS.md
- MUST default to preservation; enhancement is the goal, not replacement
- SHOULD keep new files ~150 lines
- MUST use RFC 2119 keywords in generated content
- MAY use XML tags for structure in complex repositories
- MUST report what was preserved and what was changed

</rules>
