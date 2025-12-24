---
name: command-creator
description: Create custom OpenCode slash commands. Use when user asks to "create a command", "add a slash command", "make a /command", "set up custom commands", or wants to automate repetitive prompts.
---

# Command Creator

Create custom slash commands for repetitive tasks in OpenCode.

## Core Approach

**Command creation is conversational, not transactional.**

- Don't assume what the user wants—ask
- Start simple, add complexity only if needed
- Show drafts and iterate based on feedback

## Command Locations

| Scope | Path |
|-------|------|
| Project | `.opencode/command/<name>.md` |
| Global | `~/.config/opencode/command/<name>.md` |

## Creation Workflow (Interactive Q&A)

### Phase 1: Understand the Task

1. **"What task do you want to automate?"**
   - Get the repetitive prompt/workflow
   - Examples: "run tests", "review this file", "create a component"

2. **"Can you show me how you'd normally ask for this?"**
   - Get the actual prompt they'd type
   - This becomes the template body

### Phase 2: Inputs & Routing

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

### Phase 3: Review & Refine

7. **Show the draft command, ask for feedback**
   - "Here's what I've created. Want to adjust anything?"
   - Iterate until user is satisfied

**Be flexible:** If user provides lots of info upfront, adapt—don't rigidly ask every question.

---

## Command File Format

```markdown
---
description: What this command does (shown in /help)
agent: build              # Optional: build, plan, or custom agent
model: provider/model-id  # Optional: override model
subtask: true             # Optional: run as subagent
---

Template body goes here.
```

### Frontmatter Options

| Field | Purpose | Required |
|-------|---------|----------|
| `description` | Shown in command list | Recommended |
| `agent` | Route to specific agent | No |
| `model` | Override model | No |
| `subtask` | Force subagent invocation | No |

---

## Template Placeholders

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `$ARGUMENTS` | All arguments passed | `/cmd foo bar` → "foo bar" |
| `$1`, `$2`, `$3` | Positional arguments | `/cmd foo bar` → $1="foo", $2="bar" |
| `` `!command` `` | Shell output (runs bash) | `` `!git status` `` |
| `@filename` | Include file content | `@src/index.ts` |

### Shell Commands in Templates

Use backticks with `!` to run shell commands and include output:

```markdown
Review the current changes:

`!git diff --staged`

Suggest improvements.
```

### File References

Use `@` to include file content:

```markdown
Given the schema in @prisma/schema.prisma, generate a migration for $ARGUMENTS.
```

---

## Example Commands

### /test - Run and Fix Tests

```markdown
---
description: Run tests and fix failures
---

Run the full test suite. For any failures:
1. Show the failing test
2. Identify the root cause  
3. Fix the issue
4. Re-run to verify
```

### /review - Code Review (Read-Only)

```markdown
---
description: Review code for issues
agent: plan
---

Review $ARGUMENTS for:
- Bugs and edge cases
- Security issues
- Performance problems

Provide actionable feedback without making changes.
```

### /commit - Smart Commit with Prefixes

```markdown
---
description: Stage and commit with conventional prefix
---

1. Run `git status` and `git diff`
2. Analyze all changes
3. Choose appropriate prefix: docs:, feat:, fix:, refactor:, test:, ci:
4. Write concise commit message (imperative mood)
5. Stage relevant files and commit
```

### /spellcheck - Check Spelling

```markdown
---
description: Check spelling in markdown files
subtask: true
---

Check spelling in all unstaged markdown files:

`!git diff --name-only | grep -E '\.md$'`

Report any spelling errors found.
```

### /issues - Search GitHub Issues

```markdown
---
description: Search GitHub issues
model: anthropic/claude-3-5-haiku-20241022
subtask: true
---

Search GitHub issues matching: $ARGUMENTS

`!gh issue list --search "$ARGUMENTS" --limit 10`

Summarize the relevant issues.
```

### /component - Create Component

```markdown
---
description: Create a new React component
---

Create a React component named $1 in $2 with:
- TypeScript props interface
- Basic styling
- Unit test file
```

Usage: `/component UserProfile src/components`

### /migrate - Database Migration

```markdown
---
description: Generate database migration
---

Given the schema in @prisma/schema.prisma:

Generate a migration for: $ARGUMENTS
```

---

## Built-in Commands

| Command | Description | Subtask |
|---------|-------------|---------|
| `/init` | Create/update AGENTS.md | No |
| `/review` | Review git changes (defaults to uncommitted) | Yes |

---

## Quality Checklist

Before delivering:
- [ ] Asked what task to automate
- [ ] Got example of how they'd normally prompt it
- [ ] Determined if arguments needed ($ARGUMENTS vs $1, $2)
- [ ] Set appropriate agent (plan for read-only)
- [ ] Considered subtask for long-running work
- [ ] Chose project vs global scope
- [ ] **Showed draft and got feedback**

## Best Practices

| Do | Don't |
|----|-------|
| Keep templates focused | Cram multiple tasks in one |
| Use `$1`, `$2` for structured args | Rely only on $ARGUMENTS for multi-arg |
| Use `` `!cmd` `` to gather context | Hardcode dynamic values |
| Use `@file` for config/schema refs | Copy-paste file contents |
| Set `agent: plan` for read-only | Forget agent for reviews |
| Set `subtask: true` for parallel work | Block main session unnecessarily |
