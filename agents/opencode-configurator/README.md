# OpenCode ConFIGurator Pack

A meta-configuration system for [OpenCode](https://opencode.ai). Ask questions about plugins, create custom commands, build agents, design skills — all through natural conversation.

## The ConFIGurator Agent

Your OpenCode power user on demand. It knows the official documentation and will fetch the latest when needed. It can validate your `opencode.json`, explain options, and fix issues. When hunting for plugins, it searches the web and npm, then documents discoveries for future sessions.

## The Skills

The agent draws on seven specialized skills:

| Skill | What it does |
|-------|--------------|
| **plugin-installer** | Find and install community plugins, maintain a local catalog of discoveries |
| **opencode-config** | Edit your `opencode.json` with guided setup for models, permissions, and providers |
| **command-creator** | Build custom `/slash` commands through interactive Q&A |
| **skill-creator** | Scaffold new skills with proper structure, scripts, and references |
| **agent-architect** | Design agents with research-backed prompt engineering patterns |
| **mcp-installer** | Find, install, and configure Model Context Protocol (MCP) servers |
| **model-researcher** | Research and configure new/custom AI models not yet in models.dev |

## The Commands

| Command | What it does |
|---------|-------------|
| **refactor-rfc-xml** | Convert markdown files to RFC 2119 + XML tag structure |

## Installation

Drop the `skill/`, `agent/`, and `command/` folders into `~/.config/opencode/`.

> [!NOTE]
> The opencode-configurator agent has **7 skills enabled by default**: `plugin-installer`, `opencode-config`, `command-creator`, `skill-creator`, `agent-architect`, `mcp-installer`, and `model-researcher`. All other skills are blocked with `"*": "deny"`. This allows the configurator to dynamically load the appropriate skill for each task without context pollution.

### Skill Configuration

The agent's YAML frontmatter controls skill access:

```yaml
permission:
  skill:
    plugin-installer: allow
    opencode-config: allow
    command-creator: allow
    skill-creator: allow
    agent-architect: allow
    mcp-installer: allow
    model-researcher: allow
    '*': deny
```

## Usage

Just ask naturally:

- *"Is there a plugin for reducing token usage?"*
- *"Set up permissions so destructive commands require approval"*
- *"Create a /review command that analyzes code without making changes"*
- *"I want to build a skill for working with our internal API"*
- *"Make me an agent for deployment that can only run git and npm commands"*
- *"Find an MCP server for filesystem access"*

The configurator figures out which skill to load and walks you through it.

## Contributing

Found a useful plugin that isn't in the catalog? The plugin-installer skill can document it for future sessions. Discovered patterns worth sharing? Submit a PR.
