---
name: opencode-config
description: Configure OpenCode settings and rules. Use when user asks to "configure opencode", "set up opencode", "create opencode config", "edit opencode.json", "set up AGENTS.md", "configure providers", "set up permissions", or needs help with OpenCode configuration files.
---

# OpenCode Configuration

Help users configure OpenCode through guided setup of config files and rules.

<reference>

## File Locations

| Type | Global | Project |
|------|--------|---------|
| **Config** | `~/.config/opencode/opencode.json` | `./opencode.json` |
| **Rules** | `~/.config/opencode/AGENTS.md` | `./AGENTS.md` |

**Precedence:** Project > Global. Configs are merged, not replaced.

</reference>

<workflow>

Ask the user what they want to configure:

1. **"What would you like to set up?"**
   - Config file (models, tools, permissions, theme)
   - Rules (project instructions via AGENTS.md)

Then guide them through the relevant section below.

</workflow>

<config_file>

## Config File (opencode.json)

### Basic Setup

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-20250514",
  "theme": "opencode",
  "autoupdate": true
}
```

### Key Options

| Option | Purpose | Example |
|--------|---------|---------|
| `model` | Default model | `"anthropic/claude-sonnet-4-20250514"` |
| `small_model` | Lightweight tasks | `"anthropic/claude-3-5-haiku-20241022"` |
| `theme` | UI theme | `"opencode"`, `"catppuccin"`, `"dracula"` |
| `autoupdate` | Auto-update OpenCode | `true` / `false` |
| `share` | Session sharing | `"manual"` / `"auto"` / `"disabled"` |

### Permissions

Control what requires approval using the `permission` field.

```jsonc
{
  "permission": {
    "edit": "allow",           // "allow" | "ask" | "deny"
    "bash": {
      "npm *": "allow",        // pattern matching
      "git *": "allow",
      "rm *": "ask",
      "*": "ask"               // default for this tool
    },
    "webfetch": "allow",
    "skill": {
      "*": "allow",
      "dangerous-*": "deny"
    }
  }
}
```

### Legacy Configuration

Agents may occasionally work on legacy projects using outdated configuration fields (e.g., `tools`, `maxSteps`). You MUST correct these to the modern `permission` and `steps` fields when encountered.

### Custom Instructions

Include additional instruction files:

```jsonc
{
  "instructions": [
    "CONTRIBUTING.md",
    "docs/guidelines.md",
    ".cursor/rules/*.md"
  ]
}
```

**Full schema reference:** See `references/config-schema.md`

</config_file>

<rules_file>

## Rules (AGENTS.md)

Project instructions for all agents. Similar to CLAUDE.md or Cursor rules.

### Create with /init

Run `/init` in OpenCode to auto-generate based on project analysis.

### Manual Creation

```markdown
# Project Name

This is a [framework] project using [language].

## Project Structure
- `src/` - Source code
- `tests/` - Test files

## Code Standards
- Use TypeScript strict mode
- Prefer functional patterns
- Write tests for all features

## Commands
- `npm run build` - Build project
- `npm test` - Run tests
```

### Tips

- SHOULD be specific about your project's patterns
- SHOULD include common commands
- SHOULD document any non-obvious conventions
- SHOULD keep it concise (agents have limited context)

</rules_file>

<config_tips>

## Comment Out, Don't Delete

OpenCode supports JSONC (JSON with comments). SHOULD comment out unused configs instead of deleting:

```jsonc
{
  "plugin": [
    "opencode-openai-codex-auth@latest",
    //"@tarquinen/opencode-dcp@latest",     // disabled for now
    //"@howaboua/pickle-thinker@0.4.0",     // only for GLM-4.6
    "@ramtinj95/opencode-tokenscope@latest"
  ]
}
```

**Why:** You might want to re-enable later. Keeps a record of what you've tried.

## Validate After Major Changes

After editing opencode.json, you MUST run this validation (not just suggest it):

```bash
opencode run "test"
```

**Execute it yourself** using the Bash tool before telling the user the change is complete.

If broken, you'll see a clear error with line number:
```
Error: Config file at ~/.config/opencode/opencode.json is not valid JSON(C):
--- Errors ---
CommaExpected at line 464, column 5
   Line 464:     "explore": {
              ^
--- End ---
```

Common JSONC mistakes:
- Missing comma after object (especially after adding new sections)
- Trailing comma before `}`
- Unclosed brackets

</config_tips>

<common_configurations>

## Minimal Safe Config

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-20250514",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```

## Power User Config

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-20250514",
  "autoupdate": true,
  "permission": {
    "edit": "allow",
    "bash": {
      "*": "allow",
      "rm -rf *": "deny",
      "sudo *": "ask"
    }
  },
  "instructions": ["CONTRIBUTING.md"]
}
```

## Team Project Config

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-20250514",
  "share": "auto",
  "instructions": [
    "docs/development.md",
    "docs/api-guidelines.md"
  ]
}
```

</common_configurations>

<troubleshooting>

| Issue | Solution |
|-------|----------|
| Config not loading | Check JSON syntax, ensure valid path |
| Skill not found | Verify `SKILL.md` (uppercase), check frontmatter |
| Permission denied unexpectedly | Check global vs project config precedence |

</troubleshooting>

## References

- `references/config-schema.md` - Full config options
