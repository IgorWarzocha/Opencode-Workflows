---
name: command-creator
description: |-
  Create custom /slash commands for repetitive tasks. Use proactively for command creation, prompt automation, or workflow shortcuts.

  Examples:
  - user: "Make a /test command that runs pytest" → create command in opencode.json, set prompt to run tests with bash tool
  - user: "Add a /review command for PRs" → design prompt to fetch diff, analyze changes, generate review comments
  - user: "Automate this repetitive task" → identify pattern, create slash command with parameterized prompt
  - user: "Make a /deploy command" → design workflow (build, test, deploy), encode in command prompt
---

# Command Creator

Create custom slash commands for repetitive tasks in OpenCode.

<core_approach>

**Command creation is conversational, not transactional.**

- MUST NOT assume what the user wants—ask
- SHOULD start simple, add complexity only if needed
- MUST show drafts and iterate based on feedback

</core_approach>

<question_tool>

**Batching:** Use the `question` tool for 2+ related questions. Single questions → plain text.

**Syntax:** `header` ≤12 chars, `label` 1-5 words, add "(Recommended)" to default.

When to ask: Vague request ("make a command"), or multiple implementation approaches exist.

</question_tool>

<reference>

## Command Locations

| Scope   | Path                                   |
| ------- | -------------------------------------- |
| Project | `.opencode/command/<name>.md`          |
| Global  | `~/.config/opencode/command/<name>.md` |

## Template Placeholders (CRITICAL)

- **Single Insertion**: Each placeholder (`$ARGUMENTS`, `$1`, `@filename`, etc.) MUST be inserted ONLY ONCE in the command body.
- **Dedicated Blocks**: Use dedicated XML blocks for user inputs and file contents to keep the objective and instructions clean.
- **Preference**: Prefer using a single argument (`$ARGUMENTS`) over complex positional ones unless strictly necessary.

BAD: "Do $ARGUMENTS and then check $ARGUMENTS for errors."

GOOD:
```markdown
<user_guidelines>
$ARGUMENTS
</user_guidelines>

<context>
@src/schema.ts
</context>

<objective>
Analyze findings based on user guidelines and the provided schema.
</objective>
```

| Placeholder      | Description            | Example                             |
| ---------------- | ---------------------- | ----------------------------------- |
| `$ARGUMENTS`     | All arguments passed   | `/cmd foo bar` → "foo bar"          |
| `$1`, `$2`, `$3` | Positional arguments   | `/cmd foo bar` → $1="foo", $2="bar" |
| `!command`       | Shell output injection | `!ls -F`                            |
| `@filename`      | Include file content   | `@src/index.ts`                     |

## Terminology Standard

- **Direct Address**: You MUST use "you" (referring to the agent executing the command) instead of "the agent" or "opencode".

## Command File Format

```markdown
---
description: 3-word command summary
agent: build # Optional: build, plan, or custom agent
model: provider/model-id # Optional: override model
subtask: true # Optional: run as subagent
---

<summary>
Line 1: You MUST [purpose].
Line 2: You SHOULD [inputs].
Line 3: You MUST [outcome].
</summary>

<user_guidelines>
$ARGUMENTS
</user_guidelines>

Template body goes here.
```

## Frontmatter Options

| Field         | Purpose                   | Required    |
| ------------- | ------------------------- | ----------- |
| `description` | Shown in command list     | RECOMMENDED |
| `agent`       | Route to specific agent   | No          |
| `model`       | Override model            | No          |
| `subtask`     | Force subagent invocation | No          |

## Conceptual Boundary (CRITICAL)

- **Commands are for USERS**: They are high-level shortcuts for humans to trigger an agent with specific context.
- **Agents CANNOT use commands**: Agents lack a terminal interface to "type" commands. They execute the *template body* provided by the command.
- **One-Way Street**: User -> Command -> Agent.
- **NEVER** tell an agent to use a command "proactively"—they literally cannot.
- If logic needs to be shared, put it in a **Skill** (script/instruction), not a Command.

## Shell Commands in Templates

Use the !`command` syntax to inject bash output into your prompt. The shell execution is triggered by an exclamation mark followed by the command wrapped in backticks:

```markdown
Review recent changes:

!`git log --oneline -10`

Suggest improvements.
```

## File References

Use `@` to include file content:

```markdown
Given the schema in @prisma/schema.prisma, generate a migration for $ARGUMENTS.
```

<workflow>

## Phase 1: Understand the Task

1. **"What task do you want to automate?"**
   - Get the repetitive prompt/workflow
   - Examples: "run tests", "review this file", "create a component"

2. **"Can you show me how you'd normally ask for this?"**
   - Get the actual prompt they'd type
   - This becomes the template body

## Phase 2: Inputs & Routing

3. **"Does it need arguments?"**
   - If they mention "this file", "a name", "the function" → yes
   - Explain: `/command foo bar` → `$ARGUMENTS` = "foo bar", `$1` = "foo", `$2` = "bar"

4. **"Should it make changes or just analyze?"**
   - Changes → default agent (build)
   - Analysis only → set `agent: plan`

5. **"Should it run as a background subtask?"**
   - Long-running or parallel work → set `subtask: true`
   - Interactive or quick → leave unset

6. **"Project-specific or use everywhere?"**
   - Project → `.opencode/command/`
   - Global → `~/.config/opencode/command/`

## Phase 3: Review & Refine

7. **Show the draft command, ask for feedback**
   - "Here's what I've created. Want to adjust anything?"
   - Iterate until user is satisfied

**Be flexible:** If user provides lots of info upfront, adapt—MUST NOT rigidly ask every question.

</workflow>

<examples>

## /test - Run and Fix Tests

```markdown
---
description: Run tests and fix failures
---

<summary>
You MUST run the full test suite.
You SHOULD identify and fix failures.
You MUST re-verify fixes.
</summary>

<objective>
You MUST run the full test suite, find the root cause of any failures, and fix the issue.
</objective>

1. Show the failing test
2. Identify the root cause
3. Fix the issue
4. Re-run to verify
```

## /review - Code Review (Read-Only)

```markdown
---
description: Review code for issues
agent: plan
---

<summary>
You MUST review $ARGUMENTS for issues.
You SHOULD check for bugs, security, and performance.
You MUST provide actionable feedback.
</summary>

<objective>
You MUST review $ARGUMENTS for bugs, security, and performance issues and provide actionable feedback without making changes.
</objective>

- Bugs and edge cases
- Security issues
- Performance problems
```

## /commit - Smart Commit with Prefixes

```markdown
---
description: Stage and commit with conventional prefix
---

<summary>
You MUST analyze changes and stage files.
You SHOULD choose a conventional commit prefix.
You MUST commit with a concise message.
</summary>

<context>
!`git status`
!`git diff`
</context>

<objective>
You MUST analyze changes, stage relevant files, and commit with a concise message.
</objective>

1. Analyze all changes
2. Choose appropriate prefix: docs:, feat:, fix:, refactor:, test:, ci:
3. Write concise commit message (imperative mood)
4. Stage relevant files and commit
```

## /spellcheck - Check Spelling

```markdown
---
description: Check spelling in markdown files
subtask: true
---

<summary>
You MUST find unstaged markdown files.
You SHOULD check them for spelling errors.
You MUST report any found errors.
</summary>

Check spelling in all unstaged markdown files:

<context>
!`git diff --name-only | grep -E '\.md$'`
</context>

<objective>
You MUST check for and report any spelling errors found in unstaged markdown files.
</objective>
```

## /issues - Search GitHub Issues

```markdown
---
description: Search GitHub issues
model: anthropic/claude-3-5-haiku-20241022
subtask: true
---

<summary>
You MUST search GitHub issues for $ARGUMENTS.
You SHOULD limit results to the top 10.
You MUST summarize the relevant issues.
</summary>

Search GitHub issues matching: $ARGUMENTS

<context>
!`gh issue list --search "$ARGUMENTS" --limit 10`
</context>

<objective>
You MUST summarize the top 10 relevant GitHub issues found for $ARGUMENTS.
</objective>
```

## /component - Create Component

```markdown
---
description: Create a new React component
---

<summary>
You MUST create a React component named $1.
You SHOULD include TypeScript props and basic styling.
You MUST provide a unit test file.
</summary>

Create a React component named $1 in $2 with:

<objective>
You MUST create a React component with TypeScript props and basic styling, and provide a corresponding unit test file.
</objective>

- TypeScript props interface
- Basic styling
- Unit test file
```

Usage: `/component UserProfile src/components`

## /migrate - Database Migration

```markdown
---
description: Generate database migration
---

<summary>
You MUST read the Prisma schema.
You SHOULD generate a migration for $ARGUMENTS.
You MUST ensure the migration matches the schema.
</summary>

Given the schema in @prisma/schema.prisma:

<context>
@prisma/schema.prisma
</context>

<objective>
You MUST generate a Prisma migration for $ARGUMENTS that matches the provided schema.
</objective>
```

</examples>

<quality_checklist>

Before delivering:

- [ ] Asked what task to automate
- [ ] Got example of how they'd normally prompt it
- [ ] Determined if arguments needed ($ARGUMENTS vs $1, $2)
- [ ] Set appropriate agent (plan for read-only)
- [ ] Considered subtask for long-running work
- [ ] Chose project vs global scope
- [ ] Showed draft and got feedback

</quality_checklist>

<best_practices>

| Do                                    | Don't                                 |
| ------------------------------------- | ------------------------------------- |
| Keep templates focused                | Cram multiple tasks in one            |
| Use `$1`, `$2` for structured args    | Rely only on $ARGUMENTS for multi-arg |
| Use !`cmd` to gather context          | Hardcode dynamic values               |
| Use `@file` for config/schema refs    | Copy-paste file contents              |
| Set `agent: plan` for read-only       | Forget agent for reviews              |
| Set `subtask: true` for parallel work | Block main session unnecessarily      |

</best_practices>
