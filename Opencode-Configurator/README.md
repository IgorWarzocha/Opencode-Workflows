# OpenCode ConFIGurator Pack

A meta-configuration system for [OpenCode](https://opencode.ai). Ask questions about plugins, create custom commands, build agents, design skills — all through natural conversation.

![opencode-configurator](https://github.com/user-attachments/assets/6b93df7d-a870-431c-829d-59afd765ce98)

## The ConFIGurator Agent

Your OpenCode power user on demand. It knows the official documentation and will fetch the latest when it needs to. It can validate your `opencode.json`, explain what options do, and fix issues. When you're hunting for plugins, it'll search the web and npm, then document anything useful for next time.

## The Skills

The agent draws on five specialized skills:

| Skill | What it does |
|-------|--------------|
| **plugin-installer** | Find and install community plugins, maintain a local catalog of discoveries |
| **opencode-config** | Edit your `opencode.json` with guided setup for models, permissions, and providers |
| **command-creator** | Build custom `/slash` commands through interactive Q&A |
| **skill-creator** | Scaffold new skills with proper structure, scripts, and references |
| **agent-architect** | Design agents with research-backed prompt engineering patterns |

## Installation

Drop the `skill/` and `agent/` folders into `~/.config/opencode/`.

## Usage

Just ask naturally:

- *"Is there a plugin for reducing token usage?"*
- *"Set up permissions so destructive commands require approval"*
- *"Create a /review command that analyzes code without making changes"*
- *"I want to build a skill for working with our internal API"*
- *"Make me an agent for deployment that can only run git and npm commands"*

The configurator figures out which skill to load and walks you through it.

## Contributing

Found a useful plugin that isn't in the catalog? The plugin-installer skill can document it for future sessions. Discovered patterns worth sharing? Submit a PR.
