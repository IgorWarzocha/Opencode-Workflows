---
name: skill-creator
description: Guide for creating effective opencode skills. Use when users want to create a new skill (or update an existing skill) that extends agent capabilities with specialized knowledge, workflows, or tool integrations.
---

# Skill Creator

Create opencode skills that extend agent capabilities with specialized knowledge and workflows.

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
description: What it does + when to trigger it. Be comprehensive.
---
# Instructions here (markdown body)
```

**Critical**: The `description` field determines when the skill triggers. Include:
- What the skill does
- Specific trigger phrases and contexts
- File types or domains it handles

Example: `"Document creation and editing for .docx files. Use for: creating documents, modifying content, tracked changes, adding comments."`

### Bundled Resources

| Directory | Purpose | When to use |
|-----------|---------|-------------|
| `scripts/` | Reusable Python/Bash code | Same code rewritten repeatedly |
| `references/` | Docs, schemas, API specs | Info agent needs while working |
| `assets/` | Templates, images, fonts | Files used in output (not loaded) |

**Do NOT include**: README.md, CHANGELOG.md, INSTALLATION_GUIDE.md, or other auxiliary docs. Skills contain only what the agent needs to do the job.

## Core Principles

### Be Concise

The context window is shared. Only add info the agent doesn't already have.

- Challenge each paragraph: "Does this justify its token cost?"
- Prefer examples over explanations
- Keep SKILL.md under 500 lines

### Match Freedom to Fragility

| Freedom Level | Format | Use When |
|---------------|--------|----------|
| High | Text instructions | Multiple valid approaches |
| Medium | Pseudocode/parameterized scripts | Preferred pattern exists |
| Low | Specific scripts | Fragile ops, consistency critical |

### Progressive Disclosure

1. **Metadata** (name + description) - Always loaded (~100 words)
2. **SKILL.md body** - Loaded when skill triggers
3. **Bundled resources** - Loaded on-demand by agent

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

## Creation Process

1. **Understand** → Gather concrete usage examples
2. **Plan** → Identify reusable scripts/references/assets
3. **Initialize** → `scripts/init_skill.py <name> --path <dir>`
4. **Edit** → Write SKILL.md, add resources, delete unused examples
5. **Package** → `scripts/package_skill.py <skill-folder>`
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

```bash
scripts/init_skill.py my-skill --path .opencode/skill
```

Creates:
- `SKILL.md` template with frontmatter
- Example `scripts/`, `references/`, `assets/` directories
- Example files (delete unused ones)

### Step 4: Edit

**Writing guidelines:**
- Use imperative form ("Run the script", not "You should run")
- Use bullet points over prose
- Link to references for detailed info
- Test all scripts before including

**Design pattern references:**
- `references/workflows.md` - Sequential and conditional workflows
- `references/output-patterns.md` - Template and example patterns

**Frontmatter tips:**
- `name`: lowercase-hyphen format
- `description`: Primary trigger mechanism. Be comprehensive. All "when to use" info goes here, not in body.

### Step 5: Package

```bash
scripts/package_skill.py <skill-folder>
```

Validates:
- YAML frontmatter format
- Required fields present
- Directory structure correct

Creates `.skill` file (zip with .skill extension).

### Step 6: Iterate

After real usage:
1. Notice struggles or inefficiencies
2. Update SKILL.md or resources
3. Re-package and test

## Agent Permissions

Control skill access per-agent in agent config:

```json
{
  "permission": {
    "skill": { "my-skill": "allow", "*": "deny" }
  }
}
```

Values: `"allow"`, `"deny"`, `"ask"`. Use `"*"` as wildcard default.
