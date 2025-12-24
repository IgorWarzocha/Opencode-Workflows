---
name: agent-architect
description: Research-backed creation and enhancement of opencode agents. Use when creating new agents from requirements, improving underperforming agents, or designing agent configurations. Triggers on "create an agent for X", "improve my Y agent", "design a specialized agent", "my agent isn't working well".
---

# Agent Architect

Create and refine opencode agents through a guided Q&A process.

## Core Approach

**Agent creation is conversational, not transactional.**

- Don't assume what the user wants—ask
- Start with broad questions, drill into details only if needed
- Users can skip configuration they don't care about
- Always show drafts and iterate based on feedback

The goal is to help users create agents that fit their needs, not to dump every possible configuration option on them.

## Agent Locations

| Scope | Path |
|-------|------|
| Project | `.opencode/agent/<name>.md` |
| Global | `~/.config/opencode/agent/<name>.md` |

## Agent File Format

```yaml
---
description: When to use this agent. Include trigger examples.
model: anthropic/claude-sonnet-4-20250514  # Optional
mode: primary | subagent | all             # Default: all
permission:
  skill: { "my-skill": "allow", "*": "deny" }
  bash: { "git *": "allow", "*": "ask" }
---
System prompt in markdown body (second person).
```

**Full schema:** See `references/opencode-config.md`

## Agent Modes

| Mode | Description |
|------|-------------|
| `primary` | User-selectable, can be default agent |
| `subagent` | Only callable via `task` tool |
| `all` | Both primary and subagent (default) |

## Creation Workflow (Interactive Q&A)

Agent creation is a **conversational process**. Don't assume configuration—ask the user step by step, from broad strokes to details. Users can skip questions they don't care about.

### Phase 1: Core Purpose (Required)

Ask these first—they shape everything else:

1. **"What should this agent do?"**
   - Get the core task/domain
   - Examples: "review code", "help with deployments", "research topics"

2. **"What should trigger this agent?"**
   - Specific phrases, contexts, file types
   - Becomes the `description` field

3. **"What expertise/persona should it have?"**
   - Tone, boundaries, specialization
   - Shapes the system prompt

### Phase 1.5: Research the Domain

**Never assume you know everything.** After understanding the broad strokes:

- **Search for current best practices** in the domain
- **Check for updates** to frameworks, tools, or APIs the agent will work with
- **Look up documentation** for any unfamiliar technologies mentioned
- **Find examples** of how experts approach similar tasks

This research informs better questions in Phase 2 and produces a more capable agent.

**Example:** User wants an agent for "Next.js deployments" → Research current Next.js deployment patterns, Vercel vs self-hosted, App Router vs Pages Router, common pitfalls, etc.

### Phase 2: Capabilities (Ask broadly, then drill down)

4. **"Does this agent need shell access? Web access? File editing?"**
   - If yes to shell: "Any commands that should be blocked or require approval?"
   - If yes to web: "Should it ask before fetching URLs?"
   - Determines `tools` and `permission` config

5. **"Should this agent use any skills?"**
   - If yes: "Which ones? Should others be blocked?"
   - Configures `permission.skill`

6. **"Is this a primary agent or a helper for other agents?"**
   - Primary = user-selectable
   - Subagent = only called via `task` tool
   - Sets `mode`

### Phase 3: Details (Optional—user may skip)

7. **"Any specific model preference?"** (most users skip)
8. **"Custom temperature/sampling?"** (most users skip)  
9. **"Maximum steps before stopping?"** (most users skip)

### Phase 4: Review & Refine

10. **Show the draft config and prompt, ask for feedback**
    - "Here's what I've created. Anything you'd like to change?"
    - Iterate until user is satisfied

**Key principle:** Start broad, get specific only where the user shows interest. Don't overwhelm with options like `top_p` unless asked.

**Be flexible:** If the user provides lots of info upfront, don't rigidly follow the phases—adapt to what they've already told you. If they say "I want a code review agent that can't run shell commands", you already have answers to multiple questions.

## System Prompt Structure

Use this recommended structure:

```markdown
# Role and Objective
You are [expert persona]. Your goal is [objective].

# Instructions
- Core behavioral rules
- What to always/never do

## Sub-instructions (optional)
More detailed guidance for specific areas.

# Workflow
1. First, [step]
2. Then, [step]
3. Finally, [step]

# Output Format
Specify exact format expected.

# Examples (optional)
<examples>
<example>
<input>User request</input>
<output>Expected response</output>
</example>
</examples>
```

## Using XML Tags (Recommended)

XML tags improve clarity and parseability across all models:

| Tag | Purpose |
|-----|---------|
| `<instructions>` | Core behavioral rules |
| `<context>` | Background information |
| `<examples>` | Few-shot demonstrations |
| `<thinking>` | Chain-of-thought reasoning |
| `<output>` | Final response format |

**Best practices:**
- Be consistent with tag names throughout
- Nest tags for hierarchy: `<outer><inner></inner></outer>`
- Reference tags in instructions: "Using the data in `<context>` tags..."

**Example:**
```xml
<instructions>
1. Analyze the code in <code> tags
2. List issues in <findings> tags
3. Suggest fixes in <recommendations> tags
</instructions>
```

## Description Field (Critical)

The `description` determines when the agent triggers. Be specific:

**Good:**
```
Code review agent for PR analysis. Use when user says "review this PR", 
"check my code", "find bugs in this file", or shares code asking for feedback.
```

**Bad:**
```
Helps with code.
```

## Prompt Altitude

Find the balance between too rigid and too vague:

| ❌ Too Rigid | ✅ Right Altitude | ❌ Too Vague |
|-------------|-------------------|-------------|
| Hardcoded if-else logic | Clear heuristics + flexibility | "Be helpful" |
| "If X then always Y" | "Generally prefer X, but use judgment" | No guidance |

## Agentic Prompt Components

For agents that use tools in a loop, include these reminders:

```markdown
# Persistence
Keep working until the user's request is fully resolved. Only yield 
control when you're confident the task is complete.

# Tool Usage  
If unsure about something, use tools to gather information. 
Do NOT guess or make up answers.

# Planning (optional)
Think step-by-step before each action. Reflect on results before 
proceeding.
```

## Permissions

Control what agents can access:

```yaml
permission:
  edit: "allow" | "ask" | "deny"
  bash:
    "*": "ask"
    "git *": "allow"
    "rm *": "deny"
  skill:
    "*": "deny"
    "my-skill": "allow"
  webfetch: "allow"
  external_directory: "ask"
```

**Full reference:** See `references/opencode-config.md`

### Tool Access Control

Disable specific tools:

```yaml
tools:
  bash: false       # No shell access
  webfetch: false   # No web access
  task: false       # Cannot spawn subagents
```

## Requirements Checklist (Internal Reference)

Use this to ensure you've covered the essentials—but gather info through Q&A, not a form:

| Question to Ask User | Informs |
|---------------------|----------|
| "What should this agent do?" | System prompt focus |
| "What should trigger it?" | `description` field |
| "What persona/expertise?" | Tone and boundaries |
| "Shell/web/file access needed?" | `tools` config |
| "Any commands to restrict?" | `permission.bash` |
| "Which skills should it use?" | `permission.skill` |
| "Primary agent or helper?" | `mode` |
| "Any edge cases to handle?" | System prompt details |

## System Prompt Guidelines

| Do | Don't |
|----|-------|
| Use second person ("You are...") | Use first person |
| Be specific about boundaries | Be vague about scope |
| Include self-verification steps | Assume correctness |
| Define output format explicitly | Leave format ambiguous |
| Handle edge cases explicitly | Ignore failure modes |
| Use XML tags to structure sections | Dump everything in prose |

## Enhancing Existing Agents (Q&A Process)

When improving an agent, diagnose through questions:

1. **"What's not working well?"** — Get specific symptoms
2. **"Can you show me an example where it failed?"** — Understand the gap
3. **"What should it have done instead?"** — Define success

Then propose targeted fixes:

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Triggers too often | Description too broad | Add specific contexts |
| Misses triggers | Description too narrow | Add trigger phrases |
| Wrong outputs | Prompt ambiguous | Add explicit instructions |
| Executes dangerous commands | Loose bash permissions | Restrict with patterns |
| Uses wrong skills | No skill restrictions | Configure `permission.skill` |

**Always show proposed changes and ask for confirmation before applying.**

## Example Agents

### Restricted Code Review Agent

```yaml
---
description: Safe code reviewer. Use for "review this code", "check for bugs".
mode: primary
tools:
  bash: false
  write: false
permission:
  edit: "ask"
  external_directory: "deny"
---
You are a code review specialist. Analyze code for bugs, security issues,
and improvements. Never modify files directly.
```

### Deployment Subagent

```yaml
---
description: Deployment helper for staging/production releases.
mode: subagent
permission:
  bash:
    "*": "deny"
    "git *": "allow"
    "npm run build": "allow"
    "npm run deploy:*": "ask"
  skill:
    "deploy-checklist": "allow"
    "*": "deny"
---
You are a deployment specialist...
```

## Quality Checklist (Before Delivering)

Before showing the final agent to the user:
- [ ] Asked about core purpose and triggers
- [ ] **Researched the domain** (didn't assume knowledge is current)
- [ ] `description` has concrete trigger examples
- [ ] `mode` discussed and set appropriately
- [ ] System prompt uses second person
- [ ] Asked about tool/permission needs (didn't assume)
- [ ] Output format is specified if relevant
- [ ] **Showed draft to user and got feedback**
- [ ] User confirmed they're happy with result

## References

- `references/agent-patterns.md` - Design patterns and prompt engineering
- `references/opencode-config.md` - Full frontmatter schema, tools, permissions
