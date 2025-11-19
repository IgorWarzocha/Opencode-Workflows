# Opencode Workflows

A collection of Opencode-based command templates, global agent prompts, and
workflow patterns for building sophisticated command-driven projects.

## Currently Included

### Commands2Skills Template

A universal command template with:
- **Command Integration Pattern**: 4-part architecture for command-to-tool interfaces
- **Template Structure**: Organized framework for command-based projects
- **Documentation System**: Automated maintenance via specialized agents
- **Model Compatibility**: Tested with GPT-5.1 series models
- **Example Commands**: Repository exploration and mathematical calculation tools

See `Commands2Skills/README.md` for implementation details, architecture overviews,
and usage guidance.

### Agent Catalog

Reusable agents that pair with Opencode commands:
- **agent-architect** – Refines agents with research-backed prompts (best after running `opencode agent create`).
- **repo-navigator-creator** – Builds lean AGENTS.md navigation guides.
- **subagent-orchestrator** – Dispatches specialists and enforces scope isolation.
- **openspec-orchestrator** – Enforces strict OpenSpec formatting/validation and orchestrates subagents for executing OpenSpec proposals (requires [OpenSpec](https://openspec.dev/) installed and `openspec init`).

All four are designed as primary agents to be installed globally in `~/.config/opencode/agent/`
so they can be reused across projects.

### Commands Catalog

The `Commands/` directory provides shareable command files for Opencode users.
Currently available:
- **`/howto`** (`Commands/.opencode/command/howto.md`): An `/init`-style command that
  scans the cloned repository, searches for official documentation, and generates
  an `AGENTS.md` focused on helping end users set up, operate, and troubleshoot
  the software (not for development work). Run `/howto` right after cloning a repo
  so your assistant knows how to install, run, and support that project.

### Scripts Catalog

The `Scripts/` directory contains utilities that commands or agents can reuse.
- **`perplexica-cli.js`** – Node-based CLI wrapper for Perplexica’s search API
  that handles long-running requests (300s timeout), prints answers with sources,
  and exposes focus modes (web, academic, Reddit, YouTube, Wolfram) via `--mode`
  flags. Point it at your Perplexica instance (default `http://localhost:3000/api/search`). Best used with the `/perplexica-search` command.

### @At Reference Files

Use everything inside `At/` as prefix instructions during development sessions:
- **`@coding-ts`** (`At/CODING-TS.MD`): Universal engineering guidelines emphasizing DRY principles,
  type safety, and clean architecture. Reference it in prompts (e.g., “Implement feature X following @coding-ts principles”) before starting any new feature or refactor so the LLM stays aligned. These reference files are meant for direct @ mentions in user instructions and are not invoked by subagents.

### MCP Configurations

- **Authenticated Chrome DevTools MCP** (`MCP configs/Authenticated Chrome Dev Tools MCP/`) – Enables Chrome DevTools MCP to work with authenticated browser sessions. Normally Chromium blocks Google account login in automated browsers, and concurrent sessions can interfere with existing Chrome processes, potentially closing background windows. This wrapper creates a temporary "shadow profile" that clones your cookies, sessions, and login data, allowing AI agents to access your logged-in context without disrupting your main browser.

**⚠️ Security Warning**: This enables agentic AI to access all your browser's data including logged-in accounts, cookies, and session information. Use with extreme caution.

### Other Opencode Projects

- **Agent Swarm Demo** ([repo](https://github.com/IgorWarzocha/opencode-agent-swarm-demo)) – Shows how to launch a multi-server
  swarm where Claude Code handles background process management while OpenCode runs specialized agents.
  The swarm orchestrator coordinates inter-agent communication across multiple OpenCode instances and
  currently requires Claude Code because it relies on Claude’s background bash processes to spawn the servers.

## Getting Started
1. Clone this repository locally.
2. Explore `Commands2Skills/` for command templates and tooling patterns.
3. Install desired agents globally (`~/.config/opencode/agent/`) or copy them into
   your project’s `.opencode/agent/` directory.
4. Install [OpenSpec](https://openspec.dev/) and run `openspec init` if you plan to
   use the OpenSpec orchestrator or compatible workflows.

## Additional Documentation
- `Commands2Skills/README.md` – command architecture, tooling integration, and
  usage instructions.
- `Agents/README.md` – agent descriptions, guardrails, and setup guidance.

## About
This repository provides tested Opencode command patterns, global agent prompts,
and workflow templates that demonstrate best practices for creating maintainable,
scalable command-based projects with external tool integration.
