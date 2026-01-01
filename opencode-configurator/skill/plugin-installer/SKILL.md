---
name: plugin-installer
description: Help users find and install OpenCode plugins. Use when user asks "is there a plugin for X?", "how do I install Y plugin?", "what plugins are available?", or needs help configuring plugins in opencode.json.
---

# OpenCode Plugin Installer

Help users discover, evaluate, and install OpenCode plugins from the community catalog.

<workflow>

## 1. List Available Plugins

Run the catalog script to see what's available:

```bash
python3 ~/.config/opencode/skill/plugin-installer/scripts/list_plugins.py
```

Output shows `name: description` with path to detailed file.

## 2. Read Plugin Details

For relevant matches, read the full plugin file:

```
references/plugins/<filename>.md
```

Each file contains:
- Installation config (copy-paste JSON)
- Setup steps
- Features and caveats
- Links to docs

## 3. Recommend and Install

Show the user:
- What the plugin does
- Install snippet for `opencode.json`
- Any setup steps (OAuth, config files, etc.)

</workflow>

<installation>

## Installation Format

Add to `plugin` array in opencode.json:

```jsonc
{
  "plugin": [
    "package-name@version"
  ]
}
```

**Config locations:**
- Global: `~/.config/opencode/opencode.json`
- Project: `.opencode/opencode.json`

## Version Pinning

```jsonc
// Pin version (RECOMMENDED)
"plugin": ["package@1.2.3"]

// Auto-update on restart
"plugin": ["package@latest"]

// Locked to first install (never updates)
"plugin": ["package"]
```

Force update when stuck:
```bash
rm -rf ~/.cache/opencode/node_modules ~/.cache/opencode/bun.lock
```

</installation>

<documenting_new_plugins>

## Adding New Plugins to the Catalog

When you discover a new OpenCode plugin (from web search, GitHub, npm, user mention), you MUST document it for future reference.

### Step 1: Gather Plugin Information

Before creating the doc, collect:

| Info | Where to Find |
|------|---------------|
| Package name | npm registry, GitHub repo name |
| Description | README, package.json description |
| Install syntax | Check if scoped (`@org/pkg`) or plain (`pkg`) |
| Version strategy | Does it recommend `@latest` or pinned? |
| Setup steps | OAuth flows, config files, env vars |
| Provider/model requirements | Does it only work with specific providers? |
| Known issues | GitHub issues, compatibility notes |

### Step 2: Create the Plugin File

**Location:** `~/.config/opencode/skill/plugin-installer/references/plugins/<name>.md`

**Naming convention:** Use the npm package name with `/` replaced by `-` for scoped packages:
- `opencode-foo` → `opencode-foo.md`
- `@org/opencode-bar` → `org-opencode-bar.md`

### Step 3: Use This Template

```markdown
---
name: package-name-or-@scope/package-name
description: One-line description for catalog listing (max ~80 chars)
---
# Plugin Display Name

Brief description of what this plugin does and why someone would use it.

## Installation

\`\`\`jsonc
{
  "plugin": ["package-name@latest"]
}
\`\`\`

## Setup

### Prerequisites
- List any requirements (accounts, API keys, other tools)

### Configuration
Step-by-step setup instructions.

## Features
- Key feature 1
- Key feature 2

## Caveats
- Known limitations
- Compatibility notes

## Links
- [GitHub](https://github.com/...)
- [npm](https://www.npmjs.com/package/...)
```

### Step 4: Verify the Catalog

After creating, run the listing script to confirm it appears:

```bash
python3 ~/.config/opencode/skill/plugin-installer/scripts/list_plugins.py
```

</documenting_new_plugins>

<frontmatter_requirements>

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Package name exactly as used in `"plugin": []` |
| `description` | Yes | One-liner shown in catalog listings |

**Important:** The `name` MUST match the npm package name exactly (including scope if any). This is what users will copy into their `opencode.json`.

</frontmatter_requirements>

<example>

## Documenting a New Plugin

Say you found `@cooldev/opencode-metrics` on npm. Create:

**File:** `~/.config/opencode/skill/plugin-installer/references/plugins/cooldev-opencode-metrics.md`

```markdown
---
name: @cooldev/opencode-metrics
description: Track AI usage metrics and export to dashboards
---
# OpenCode Metrics

Export your OpenCode usage data to external dashboards...

## Installation

\`\`\`jsonc
{
  "plugin": ["@cooldev/opencode-metrics@latest"]
}
\`\`\`

...
```

</example>
