---
name: skill-creator
description: |-
  Architect and refine OpenCode skills to extend agent capabilities. Handles directory scaffolding, SKILL.md authoring, frontmatter optimization, and resource organization (scripts/references/assets). Use proactively for creating new skills, updating existing workflows, or fixing skill discovery issues.

  Examples:
  - user: "Create a new skill for database management" → scaffold directory and initial SKILL.md
  - user: "My skill isn't triggering correctly" → analyze and refine frontmatter description
  - user: "Add a python script to the image-processing skill" → structure scripts/ directory
  - user: "How should I structure a skill for API docs?" → design references/ layout
---

# Skill Creator

Create opencode skills that extend agent capabilities with specialized knowledge and workflows.

<overview>

## What Skills Provide

- **Specialized workflows** - Multi-step procedures for specific domains
- **Tool integrations** - Instructions for file formats, APIs, libraries
- **Domain expertise** - Company-specific knowledge, schemas, business logic
- **Bundled resources** - Reusable scripts, references, and assets

## Skill Locations

| Scope | Path |
|-------|------|
| Project | `.opencode/skill/<name>/SKILL.md` |
| Global | `~/.config/opencode/skill/<name>/SKILL.md` |

- **Project skills**: Team-shared, repo-specific (e.g., `our-api-patterns`, `project-deploy`)
- **Global skills**: Personal tools for all projects (e.g., `pdf-editor`, `commit-helper`)

For project paths, OpenCode walks up from cwd to git worktree root.

</overview>

<structure>

## Skill Structure

```
skill-name/
├── SKILL.md              # Required - frontmatter + instructions
├── scripts/              # Optional - executable code (Python/Bash)
├── references/           # Optional - docs loaded on-demand
└── assets/               # Optional - templates, images, fonts
```

### SKILL.md Format

```yaml
---
name: skill-name
description: [Self-contained workflow summary — see guidelines below]
---
# Instructions here (markdown body)
```

**Name**: Short, hyphen-case identifier. Should be descriptive but concise (max 64 chars).

**Description**: Agent sees this + the name before loading. Must be self-contained with:
- What workflow/capabilities it provides
- "Use proactively when" trigger contexts
- 3-5 concrete examples


**CRITICAL: The `description` field is the primary trigger mechanism.**

Skills are **SOPs/workflows**, NOT agents. DO NOT use role descriptions like "You are a..." or "[Role] expert."

Before loading, the agent sees only the **name** and **description** in `<available_skills>`:

```
<available_skills>
  <skill>
    <name>skill-name</name>
    <description>...</description>
  </skill>
</available_skills>
```

The description must be self-contained — agents won't load a skill just to "see what it does."

**Name + description should work together:**
- **Name**: Short, hyphen-case identifier (e.g., `typescript-advanced`)
- **Description**: Self-contained workflow summary with capabilities, triggers, and examples

**Description pattern (LLM-optimized):**
```yaml
---
name: skill-name
description: |-
  [Action verb/capabilities]. Use for [specific cases]. Use proactively when [contexts].
  
  Examples:
  - user: "query" → action
  - user: "query" → action
---
```

Dense, machine-parseable, specific. Avoid prose.

**CRITICAL YAML SYNTAX:** Multi-line descriptions with examples MUST use literal block scalar (`|-`). The hyphen strips the trailing newline. Do NOT use plain YAML with unquoted colons or lists:

```yaml
# ❌ WRONG - breaks YAML parsing
description: Handle plugins. Examples:
- user: "..." → action

# ✅ CORRECT - use |- for multi-line
description: |-
  Handle plugins.
  
  Examples:
  - user: "..." → action
```

**Example:**
```yaml
---
name: typescript-advanced
description: |-
  Handle TypeScript 5.9 advanced typing, generics, strict configs, type errors, migrations,
  erasable syntax compliance, and test writing. Use proactively for complex generics,
  conditional types, utility types, TS compiler config, or test authoring.
  
  Examples:
  - user: "Create a type-safe event emitter" → implement with generics and mapped types
  - user: "Migrate to strict TypeScript" → add discriminated unions, exhaustive checks
  - user: "Build typed API client from OpenAPI" → generate request/response types with inference
  - user: "Write unit tests" → create strict, typed tests with realistic fixtures
---
```

**Requirements:**
- Start with action verb (NOT "You are" or "[Role] expert")
- List specific capabilities (vague "helps with X" = ignored)
- Include "Use proactively when" trigger contexts
- Provide 3-5 concrete `user: "..." → ...` examples
- Use `|-` literal block scalar for multi-line descriptions (plain YAML with lists/colons breaks parsing)
- Dense, LLM-parseable — description alone must justify loading

**Reduce redundancy:** Don't repeat description content in SKILL.md body.

### Bundled Resources

| Directory | Purpose | When to use |
|-----------|---------|-------------|
| `scripts/` | Reusable Python/Bash code | Same code rewritten repeatedly |
| `references/` | Docs, schemas, API specs | Info agent needs while working |
| `assets/` | Templates, images, fonts | Files used in output (not loaded) |

**MUST NOT include**: README.md, CHANGELOG.md, INSTALLATION_GUIDE.md, or other auxiliary docs. Skills contain only what the agent needs to do the job.

</structure>

<principles>

## Core Principles

### Be Concise

The context window is shared. Only add info the agent doesn't already have.

- Challenge each paragraph: "Does this justify its token cost?"
- Prefer examples over explanations
- SHOULD keep SKILL.md under 500 lines

### Match Freedom to Fragility

| Freedom Level | Format | Use When |
|---------------|--------|----------|
| High | Text instructions | Multiple valid approaches |
| Medium | Pseudocode/parameterized scripts | Preferred pattern exists |
| Low | Specific scripts | Fragile ops, consistency critical |

### Progressive Disclosure

1. **Metadata** (name + description) - Always loaded (~100 words)
   - The `description` is the PRIMARY discovery mechanism
   - Agents see this and decide whether to load the skill
   - If description is vague, the skill will never be used

2. **SKILL.md body** - Loaded when skill triggers
   - Core workflow and detailed instructions
   - Keep focused on what the agent needs to do the work

3. **Bundled resources** - Loaded on-demand by agent
   - Move variant-specific details to `references/`

Keep core workflow in SKILL.md. Move variant-specific details to `references/`.

**Example structure:**
```
cloud-deploy/
├── SKILL.md (workflow + provider selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```
Agent loads only the relevant provider file.

</principles>

<workflow>

## Creation Process

1. **Understand** → Gather concrete usage examples
2. **Plan** → Identify reusable scripts/references/assets
3. **Initialize** → Create directory and SKILL.md manually
4. **Edit** → Write SKILL.md frontmatter + body, add resources
5. **Validate** → Verify the skill loads and triggers correctly
6. **Iterate** → Test, improve, repeat

### Step 1: Understand

Gather concrete examples of how the skill will be used. Ask:
- "What should this skill do?"
- "What requests should trigger it?"
- "Can you give example user queries?"

Skip only if usage patterns are already clear.

### Step 2: Plan

For each use case, identify reusable resources:

| If you find yourself... | Add to... |
|-------------------------|-----------|
| Rewriting same code | `scripts/` |
| Re-discovering schemas/docs | `references/` |
| Copying same templates | `assets/` |

**Examples:**
- `pdf-editor`: "Rotate this PDF" → `scripts/rotate_pdf.py`
- `bigquery`: "How many users today?" → `references/schema.md`
- `frontend-builder`: "Build me a todo app" → `assets/react-template/`

### Step 3: Initialize

Create the skill directory and SKILL.md manually:

```bash
# Global skill (personal tools)
mkdir -p ~/.config/opencode/skill/my-skill

# Project skill (team-specific)
mkdir -p .opencode/skill/my-skill
```

Create `SKILL.md` with frontmatter:

```yaml
---
name: my-skill
description: |-
  [Workflow/capabilities]. Use for [specific cases]. Use proactively when [contexts].
  
  Examples:
  - user: "query" → action
  - user: "query" → action
---
# [Skill Name]

[Instructions start here]
```

**Description template example:**
```yaml
---
name: typescript-advanced
description: |-
  Handle TypeScript 5.9 advanced typing, generics, strict configs, type errors, migrations,
  and test writing. Use proactively for complex generics, conditional types, utility types, TS compiler
config, or test authoring.

Examples:
- user: "Create a type-safe event emitter" → implement with generics and mapped types
- user: "Migrate to strict TypeScript" → add discriminated unions, exhaustive checks
- user: "Build typed API client from OpenAPI" → generate request/response types with inference
- user: "Write unit tests" → create strict, typed tests with realistic fixtures
---
```

Add optional directories as needed:
```bash
cd my-skill
mkdir scripts references assets  # only create what you'll actually use
```

### Step 4: Edit

**Writing guidelines:**
- MUST use imperative form ("Run the script", not "You should run")
- SHOULD use bullet points over prose
- SHOULD link to references for detailed info
- MUST test all scripts before including

**Frontmatter requirements:**
- `name`: lowercase-hyphen format, must match directory name exactly
- `description`: CRITICAL — follow the format specified in <structure> above. This is how agents discover your skill.

### Step 5: Validate

Verify the skill is discoverable:

1. **Check structure:**
   - `SKILL.md` exists in skill directory
   - Directory name matches `name:` in frontmatter exactly
   - YAML frontmatter is valid

2. **Test discovery:**
   - The skill should appear in agent's `<available_skills>` section
   - Description should be specific enough to match relevant queries

3. **Verify triggers:**
   - Read your description — would you know when to use this skill based solely on it?
   - Do the examples cover the main use cases?

**Note:** Skills are used directly from their directories. No packaging or installation step required.

### Step 6: Iterate

After real usage:
1. Notice where the skill fails to trigger or provides unclear guidance
2. Update the `description` to include missing trigger contexts
3. Add more examples to the description or SKILL.md body
4. Re-validate discovery and triggers

</workflow>

<permissions>

## Agent Permissions

Control skill access per-agent in agent config:

```json
{
  "permission": {
    "skill": { "*": "deny", "my-skill": "allow" }
  }
}
```

Values: `"allow"`, `"deny"`, `"ask"`. Use `"*"` as wildcard default.

</permissions>

<question_tool>

**Batching:** Use the `question` tool for 2+ related questions. Single questions → plain text.

**Syntax:** `header` ≤12 chars, `label` 1-5 words, add "(Recommended)" to default.

When to ask: Ambiguous request, multiple skill patterns apply, or scope unclear.

</question_tool>

<bundled_references>

## Available References

This skill includes reference documents for advanced patterns. Load on-demand:

| Reference | When to Load |
|-----------|--------------|
| `references/output-patterns.md` | Designing template outputs, example-based guidance |
| `references/workflows.md` | Sequential or conditional workflow structures |

**Usage:** Read the relevant reference file when you need detailed patterns beyond the core workflow.

</bundled_references>
