# OpenCode ConFIGurator Pack

A meta-configuration system for [OpenCode](https://opencode.ai). Ask questions about plugins, create custom commands, build agents, design skills — all through natural conversation.

All skills use **RFC 2119 keywords** and **XML tags** for structured, unambiguous instructions.

All skills use **RFC 2119 keywords** and **XML tags** for structured, unambiguous instructions.

![opencode-configurator](https://github.com/user-attachments/assets/6b93df7d-a870-431c-829d-59afd765ce98)

<overview>

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

</overview>

<commands>

## The Commands

| Command | What it does |
|---------|-------------|
| **refactor-rfc-xml** | Convert markdown files to RFC 2119 + XML tag structure |

</commands>

<installation>

## Installation

Drop the `skill/`, `agent/`, and `command/` folders into `~/.config/opencode/`.

</installation>

<usage>

## Usage

Just ask naturally:

- *"Is there a plugin for reducing token usage?"*
- *"Set up permissions so destructive commands require approval"*
- *"Create a /review command that analyzes code without making changes"*
- *"I want to build a skill for working with our internal API"*
- *"Make me an agent for deployment that can only run git and npm commands"*
- *"Find an MCP server for filesystem access"*

The configurator figures out which skill to load and walks you through it.

</usage>

<contributing>

## Contributing

Found a useful plugin that isn't in the catalog? The plugin-installer skill can document it for future sessions. Discovered patterns worth sharing? Submit a PR.

</contributing>
