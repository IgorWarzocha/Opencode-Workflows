# OpenCode Plugin Generator

This workflow pack enables OpenCode to generate its own TypeScript plugins. It bundles the SDK documentation, a slash command that triggers the workflow, and a required agent profile.

![plugin-creator](https://github.com/user-attachments/assets/9b9e7c64-cd2c-4136-8133-e41d020db914)

## Installation

Clone the OpenCode source repo and copy this pack into it. The scripts and paths assume the OpenCode repo layout and will not work as a global install.

```bash
git clone https://github.com/sst/opencode/
# place this pack inside the cloned repo
```

## Usage

Use the slash command to generate a new plugin:

```
/create-plugin "block any bash command that contains 'rm -rf'"
```

The command triggers the workflow, loading the agent and skill to look up the correct SDK hooks and generate the TypeScript code.

## Components

*   **Command (`/create-plugin`)**: Triggers the workflow and passes your description to the agent.
*   **Skill (`create-opencode-plugin`)**: Contains the API reference, event types, and TypeScript definitions. This ensures the generated code compiles.
*   **Agent (`Plugin Creator`)**: Required specialized agent profile tuned for plugin development.

## Skill Configuration

> [!NOTE]
> The Plugin Creator agent has **1 skill enabled by default**: `create-opencode-plugin`. All other skills are blocked with `"*": "deny"`. This ensures the agent focuses on plugin development without context pollution.

The agent's YAML frontmatter controls skill access:

```yaml
permission:
  skill:
    create-opencode-plugin: allow
    '*': deny
```
