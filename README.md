# Opencode Workflows

A collection of Opencode-based command templates, global agent prompts, and
workflow patterns for building sophisticated command-driven projects.

![opencode-workflows](https://github.com/user-attachments/assets/72872e42-b388-45a4-9948-5063350fb381)
## Start Here: Opencode Configurator

The **Opencode Configurator** (`opencode-configurator/`) is a meta-configuration system that makes setting up OpenCode effortless. Just ask naturally:

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

See `opencode-configurator/README.md` for full details.

---

## Create OpenCode Plugin

The **Create OpenCode Plugin** (`create-opencode-plugin/`) is a workflow bundle for AI-assisted plugin development in OpenCode. Describe what you want your plugin to do, and the workflow guides you through design, testing, and publishing.

Build custom tools, event handlers, tool interceptors, LLM parameter modifiers, authentication flows, and UI notifications.

**Installation**: Use this bundle inside a cloned OpenCode source repo.

**Usage**: Run `/create-plugin [your idea]`.

See `create-opencode-plugin/README.md` for full details.

---

## Plugins

- **Gemini/GLM Focused Mode** (`plugins/gemini-glm-focused-mode/`) – Injects a rigorous system prompt for GLM-4.7 and Gemini models to enforce precise, grounded, and persistent coding behavior. Activates based on model name matching. Install by copying `index.ts` to a local folder and adding the file path to your global `opencode.json` plugin array.
- **GPT Oath Prompt Enhancer** (`plugins/gpt-oath-prompt-enhancer/`) – Injects OpenCode environment context and CLI formatting guidelines into GPT model conversations. Ensures GPT models follow CLI-specific Markdown rendering conventions and understand the AGENTS.md discovery system. Activates for any model ID containing "gpt". Install by copying `src/` folder locally and adding `index.ts` path to your global `opencode.json` plugin array.

---

## Configuration Examples

- **Thinking Levels Variants** (`thinking-variants config/thinking-levels-opencode.json`) – OpenCode configuration with model variants for Ctrl+T thinking level switching. Supports OpenAI OAuth plugins (GPT-5.2, GPT-5.2 Codex), Mirrorwell's Antigravity Proxy (Gemini 3 Pro/Flash, Claude 4.5), and GLM coding plan (GLM-4.7). Enables dynamic reasoning effort and thinking budget adjustment directly from the UI.

---

## Included Packs

### Commands2Skills Template

A universal command template with:
- **Command Integration Pattern**: 4-part architecture for command-to-tool interfaces (still works, but deprecated - OC now supports skills natively)
- **Template Structure**: Organized framework for command-based projects
- **Documentation System**: Automated maintenance via specialized agents
- **Example Commands**: Repository exploration and mathematical calculation tools

See `commands2skills/README.md` for implementation details, architecture overviews,
and usage guidance.

### Agent Catalog

Agents are organized into two collections under `agents/`:

- **generic/** – Reusable global agents that belong in `~/.config/opencode/agent/`:
  - **agent-architect** – Refines agents with research-backed prompts (best after running `opencode agent create`).
  - **repo-navigator-creator** – Builds lean AGENTS.md navigation guides.
  - **subagent-orchestrator** – Dispatches specialists and enforces scope isolation. (might need some tweaks - dumber models hallucinate agents)
  - **openspec-orchestrator** – Enforces strict OpenSpec formatting/validation and orchestrates subagents for executing OpenSpec proposals (requires [OpenSpec](https://openspec.dev/) installed and `openspec init`).
- **vite-react-ts-convex-tailwind/** – Stack-specific experts for the modern Vite + React 19.2 + TS 5.9 + Tailwind 4.1 + Convex stack (also supports Bun). Each agent references its matching documentation file (`CONVEX.md`, `REACT19.md`, `TAILWIND4.md`, `TS59.MD`, `CODING-TS.md`) so it can cite authoritative answers on demand:
  - **vite-react-convex-expert** – Master coordinator for the entire stack, orchestrating subagents.
  - **convex-database-expert** – Schema/query/mutation/action specialist grounded in Convex docs.
  - **react-19-master** – React 19.2 implementation reviewer focused on Server Components, Actions, and compiler rules.
  - **tailwind-41-architect** – Tailwind CSS 4.1 designer that enforces the CSS-first workflow.
  - **typescript-59-engineer** – Strict TS 5.9 engineer who guards erasable syntax and configuration hygiene.

See `agents/README.md` for full tables, usage details, and the complete directory tree.

### Commands Catalog

The `commands/` directory provides shareable command files for Opencode users.
Currently available:
- **`/howto`** (`commands/.opencode/command/howto.md`): An `/init`-style command that
  scans the cloned repository, searches for official documentation, and generates
  an `AGENTS.md` focused on helping end users set up, operate, and troubleshoot
  the software (not for development work). Run `/howto` right after cloning a repo
  so your assistant knows how to install, run, and support that project.
- **`/improve:run`** (`commands/.opencode/command/improve:run.md`): Transforms any task into a production-ready prompt using official prompt engineering guides from OpenAI GPT-5.1/5.1-Codex, Anthropic Claude 4.5, and Google Gemini 3 Pro, then executes it immediately.
- **`/improve:save`** (`commands/.opencode/command/improve:save.md`): Same enhancement as `/improve:run` but saves the optimized prompt as a markdown file for review and refinement before execution. Runs as a subagent to save context. When finished, @ the prompt file in the main session.
- **`/refactor`** (`commands/.opencode/command/refactor.md`): Refactors code with strict modularity, file headers, and cleanup. Breaks large files into focused modules, removes slop (emojis, chatty comments, console logs), enforces DRY principles, and adds concise 2-3 sentence file headers. Targets files from current session or worst offenders (250+ lines) if unspecified.

### Scripts Catalog

The `scripts/` directory contains utilities that commands or agents can reuse.
- **`perplexica-cli.js`** – Node-based CLI wrapper for Perplexica’s search API
  that handles long-running requests (300s timeout), prints answers with sources,
  and exposes focus modes (web, academic, Reddit, YouTube, Wolfram) via `--mode`
  flags. Point it at your Perplexica instance (default `http://localhost:3000/api/search`).
- **`/perplexica-search`** (`scripts/.opencode/command/perplexica-search.md`) – A specialized 
  command that orchestrates the CLI to perform research with smart mode selection, 
  structured summaries, and full citations.

### @At Reference Files

Use everything inside `at/` as prefix instructions during development sessions:
- **`@coding-ts`** (`at/CODING-TS.MD`): Universal engineering guidelines emphasizing DRY principles,
  type safety, and clean architecture. Reference it in prompts (e.g., “Implement feature X following @coding-ts principles”) before starting any new feature or refactor so the LLM stays aligned. These reference files are meant for direct @ mentions in user instructions and are not invoked by subagents.

### MCP Configurations

- **Authenticated Chrome DevTools MCP** (`mcp-configs/authenticated-chrome-dev-tools-mcp/`) – Enables Chrome DevTools MCP to work with authenticated browser sessions. Normally Chromium blocks Google account login in automated browsers, and concurrent sessions can interfere with existing Chrome processes, potentially closing background windows. This wrapper creates a temporary "shadow profile" that clones your cookies, sessions, and login data, allowing AI agents to access your logged-in context without disrupting your main browser.

**⚠️ Security Warning**: This enables agentic AI to access all your browser's data including logged-in accounts, cookies, and session information. Use with extreme caution.

### Other Opencode Projects

- **Agent Swarm Demo** ([repo](https://github.com/IgorWarzocha/opencode-agent-swarm-demo)) – Shows how to launch a multi-server
  swarm where Claude Code handles background process management while OpenCode runs specialized agents.
  The swarm orchestrator coordinates inter-agent communication across multiple OpenCode instances and
  currently requires Claude Code because it relies on Claude’s background bash processes to spawn the servers.

## Getting Started
1. Clone this repository locally.
2. Explore `commands2skills/` for command templates and tooling patterns.
3. Install desired agents globally (`~/.config/opencode/agent/`) or copy them into
   your project’s `.opencode/agent/` directory.
4. Install [OpenSpec](https://openspec.dev/) and run `openspec init` if you plan to
   use the OpenSpec orchestrator or compatible workflows.

## Additional Documentation
- `commands2skills/README.md` – command architecture, tooling integration, and
  usage instructions.
- `agents/README.md` – agent descriptions, guardrails, and setup guidance.

## About
This repository provides tested Opencode command patterns, global agent prompts,
and workflow templates that demonstrate best practices for creating maintainable,
scalable command-based projects with external tool integration.
