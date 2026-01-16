# Opencode Workflows

A collection of Opencode-based command templates, global agent prompts, and
workflow patterns for building sophisticated command-driven projects.

![opencode-workflows](https://github.com/user-attachments/assets/72872e42-b388-45a4-9948-5063350fb381)

---

## Start Here: Opencode Configurator

The **Opencode Configurator** (`agents/opencode-configurator/`) is a meta-configuration system that makes setting up OpenCode effortless. Just ask naturally:

- *"Is there a plugin for reducing token usage?"*
- *"Set up permissions so destructive commands require approval"*
- *"Create a /review command that analyzes code without making changes"*
- *"I want to build a skill for working with our internal API"*
- *"Find an MCP server for filesystem access"*

The configurator agent draws on seven specialized skills:

| Skill | What it does |
|-------|--------------|
| **plugin-installer** | Find and install community plugins, maintain a local catalog |
| **opencode-config** | Edit `opencode.json` with guided setup for models, permissions, providers |
| **command-creator** | Build custom `/slash` commands through interactive Q&A |
| **skill-creator** | Scaffold new skills with proper structure, scripts, and references |
| **agent-architect** | Design agents with research-backed prompt engineering patterns |
| **mcp-installer** | Find, install, and configure Model Context Protocol (MCP) servers |
| **model-researcher** | Research and configure new/custom AI models not yet in models.dev, with verified specifications |

**Installation**: Drop the `skill/` and `agent/` folders into `~/.config/opencode/`.

See `agents/opencode-configurator/README.md` for full details.

---

## The Ralph Wiggum Loop (KISS Method)

The **Ralph Wiggum Loop** (`/loop`) is a high-intensity, autonomous "black box" orchestrator that follows the KISS (Keep It Simple, Stupid) principle: **The technique is deterministically bad in an undeterministic world.**

It puts a specialized task tool subagent in an evolving while-loop, pushing it through repeated layers of implementation and hyper-detailed verification until the task is 100% complete.

See `commands/.opencode/command/loop.md` for full details.

---

## Create OpenCode Plugin

The **Create OpenCode Plugin** (`agents/create-opencode-plugin/`) is a workflow bundle for AI-assisted plugin development in OpenCode. Describe what you want your plugin to do, and the workflow guides you through design, testing, and publishing.

**Usage**: Run `/create-plugin [your idea]`.

See `agents/create-opencode-plugin/README.md` for full details.

---

## Plugins

- **Gemini/GLM Focused Mode** (`plugins/gemini-glm-focused-mode/`) – Injects a rigorous system prompt for GLM-4.7 and Gemini models to enforce precise, grounded, and persistent coding behavior.

---

## Security Reviewer

The **Security Reviewer** (`agents/security-reviewer/`) is a specialized agent for auditing codebases against vibecoding vulnerabilities. It bundles 10 framework-specific security skills.

See `agents/security-reviewer/README.md` for full details.

---

## Configuration Examples

- **Thinking Levels Variants** (`thinking-variants config/thinking-levels-opencode.json`) – OpenCode configuration with model variants for Ctrl+T thinking level switching.

---

## included Packs

### Agent Catalog

To optimize model usage, we recommend disabling the legacy generic `general` subagent in your `opencode.json` and using the `fast`/`smart` split instead:

```json
"subagents": {
  "general": {
    "disable": true
  }
}
```

Agents are organized under `agents/`:

 - **generic/** – Reusable global agents that belong in `~/.config/opencode/agent/`:
   - **fast** – High-speed workhorse for trivial edits and file lookups.
   - **smart** – Senior developer for complex bug hunting and refactoring.
   - **repo-navigator** – Supports dual workflows (`/init` for AI navigation, `/howto` for user assistance). Recommended to pair with the two mentioned commands.
   - **subagent-orchestrator** – Dispatches specialists and enforces scope isolation.
   - **openspec-orchestrator** – Enforces strict OpenSpec formatting/validation and orchestrates subagents.
- **parallel-PRD/** – Parallel PRD planning kit with planner subagents and an orchestrator.
- **component-engineer/** – Expert architecture package for professional React components.
- **opencode-configurator/** – Meta-configuration system for OpenCode.
- **security-reviewer/** – Specialized agent for auditing vulnerabilities.
- **create-opencode-plugin/** – Workflow bundle for AI-assisted plugin development.
- **vite-react-ts-convex-tailwind/** – Stack-specific experts for the modern Vite + React 19.2 + TS 5.9 + Tailwind 4.1 + Convex stack.

See `agents/README.md` for full tables, usage details, and the complete directory tree.

### Commands Catalog

The `commands/` directory provides shareable command files for Opencode users.
Currently available:
- **`/howto`**: Scans the cloned repository and generates a user-focused `AGENTS.md`.
- **`/improve-run`**: Transforms any task into a production-ready prompt and executes it immediately.
- **`/improve-save`**: Transforms any task into a production-ready prompt and saves it as a markdown file.
- **`/refactor`**: Refactors code with strict modularity, file headers, and cleanup.
- **`/init`**: Creates or enhances AGENTS.md documentation while preserving human-crafted content.
- **`/refactor-rfc-xml`**: Converts markdown files to RFC 2119 + XML tag structure.
- **`/loop`**: The "Ralph Wiggum" loop orchestrator for verified completion.
- **`/component-review`**: Rigorous, spec-aligned audit of a React component.
- **`/component-create`**: Generates a professional, spec-compliant React component.
- **`/rmslop`**: Removes "AI slop" (emojis, chatty preambles, excessive comments).
- **`/npm`**: Optimized npm command executor with proper error recovery.
- **`/create-pack`**: Bundles related agents, commands, and skills into a shareable Opencode pack.
- **`/permissions-update`**: Modernizes resource permissions configuration from legacy syntax.

### Scripts Catalog

The `scripts/` directory contains utilities that commands or agents can reuse.
- **`perplexica-cli.js`** – Node-based CLI wrapper for Perplexica’s search API.
- **`/perplexica-search`** – A specialized command for research with smart mode selection.

### @At Reference Files

Use everything inside `at/` as prefix instructions during development sessions:
- **`@coding-ts`** (`at/CODING-TS.MD`): Universal engineering guidelines.

### MCP Configurations

- **Authenticated Chrome DevTools MCP** (`mcp-configs/authenticated-chrome-dev-tools-mcp/`) – Enables Chrome DevTools MCP with authenticated sessions via "shadow profiles".

---

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/IgorWarzocha/Opencode-Workflows.git
   ```
2. **Setup the Configurator**:
   Start with the **Opencode Configurator** (`agents/opencode-configurator/`). Follow its README to install meta-configuration skills.
3. **Explore the Catalogs**:
   Browse the [Agent Catalog](#agent-catalog) and [Commands Catalog](#commands-catalog) to find specialized tools for your workflow.
4. **Deploy Globally (Optional)**:
   For universal access across all your projects, copy desired agents to `~/.config/opencode/agent/` and skills to `~/.config/opencode/skill/`.

---

## About

This repository provides tested Opencode command patterns, global agent prompts, and workflow templates that demonstrate best practices for creating maintainable, scalable command-based projects.

---

## RFC 2119 + XML Tag Structure

All agent prompts, skills, and commands in this repository use **RFC 2119 keywords** and **XML tags** for structure.

### Why XML Tags?
XML tags provide clear boundaries that LLMs parse reliably:
- **Clarity**: Distinct separation between instructions, examples, and context.
- **Hierarchy**: Nested tags create logical groupings.
- **Consistency**: Standardized tags work across all models.

### Why RFC 2119 Keywords?
RFC 2119 (BCP 14) defines precise requirement levels:
- **MUST**: Absolute requirement.
- **MUST NOT**: Absolute prohibition.
- **SHOULD**: Strong recommendation.
- **MAY**: Truly optional.

---

> [!CAUTION]
> **INTERNAL USE ONLY**: The root `.opencode/` directory contains maintenance tools (`repo-maintainer`, `repo-maintenance` skill, and `/audit-repo`, `/sync-docs`, `/maintain-repo` commands) that are for **internal repository management only**. These tools are hard-coded for this repository's specific structure and metadata rules. If you wish to use them in your own project, you MUST copy and customize them to match your own file structure and validation standards. **Do not install the root tools globally.**
