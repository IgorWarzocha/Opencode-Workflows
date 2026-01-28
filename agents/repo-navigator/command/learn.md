---
description: Document session findings
---

<summary>
You MUST document session findings and workarounds.
You SHOULD append 1-3 concise lines to root or create a nested AGENTS.md.
Findings MUST be captured from non-obvious fixes or decisions.
</summary>

<user_guidelines>
$ARGUMENTS
</user_guidelines>

<objective>
Capture critical "why" decisions, workarounds, or fixes from this session.
Intelligently identify findings from context or user guidelines, if present.
</objective>

<instructions>
1. **Identify Findings**: you MUST analyze the session/task for friction points or non-obvious fixes.
2. **Auto-Detect Scope**: you MUST determine if findings are nested-directory-specific or repo-wide.
3. **Distill Lesson**: you MUST extract findings into 1-2 non-verbose lines. you SHOULD match existing documentation style.
4. **Apply**: you MUST append to root or identified sub-directory AGENTS.md. If no AGENTS.md exist in the chosen directory, you MUST create a minimalist file containing ONLY the new findings.
</instructions>

<rules>
- MUST be extremely concise (1-2 lines of new content).
- MUST focus on "how to avoid this issue next time."
- MUST NOT use generic preambles or repeat info.
</rules>
