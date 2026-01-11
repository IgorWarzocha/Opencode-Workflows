# Opencode Workflows

A collection of Opencode-based command templates, global agent prompts, and
workflow patterns for building sophisticated command-driven projects.

![opencode-workflows](https://github.com/user-attachments/assets/72872e42-b388-45a4-9948-5063350fb381)

---

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

## The Ralph Wiggum Loop (KISS Method)

The **Ralph Wiggum Loop** (`/loop`) is a high-intensity, autonomous "black box" orchestrator that follows the KISS (Keep It Simple, Stupid) principle: **The technique is deterministically bad in an undeterministic world.**

It puts a specialized task tool subagent in an evolving while-loop, pushing it through repeated layers of implementation and hyper-detailed verification until the task is 100% complete.

See `commands/.opencode/command/loop.md` for full details.

**Key Features:**
- **Dynamic Checklist Evolution**: As features are implemented, the loop appends granular "Deep Dive" items to the hidden checklist to test for edge cases, polish, and integration.
- **Autonomous Verification**: No user interaction is allowed until the subagent explicitly reports 100% completion AND the orchestrator verifies it.
- **Stateful Resumption**: Leverages native `task` tool session persistence (session IDs starting with `ses`) to maintain continuity across dozens of iterations.
- **Loop Intensity Control**:
  - `/loop AUTO 5 "Implement feature X"`: Executes 5 evolving verification loops immediately.
  - `/loop 10 "Implement feature X"`: Presents a hyper-detailed checklist for approval, then attempts 10 autonomous loops.

Ralph will test you. Every time Ralph takes a wrong direction, don't blame the tools; tune the signs. Eventually, all Ralph thinks about is the signs.

---

## Create OpenCode Plugin

The **Create OpenCode Plugin** (`create-opencode-plugin/`) is a workflow bundle for AI-assisted plugin development in OpenCode. Describe what you want your plugin to do, and the workflow guides you through design, testing, and publishing.

Build custom tools, event handlers, tool interceptors, LLM parameter modifiers, authentication flows, and UI notifications.

**Installation**: Use this bundle inside a cloned OpenCode source repo.

**Usage**: Run `/create-plugin [your idea]`.

See `create-opencode-plugin/README.md` for full details.

---

## Plugins

- **Gemini/GLM Focused Mode** (`plugins/gemini-glm-focused-mode/`) – Injects a rigorous system prompt for GLM-4.7 and Gemini models to enforce precise, grounded, and persistent coding behavior. Activates based on model name matching. Install by adding `@howaboua/opencode-glm-gemini-prompt-enhancer@latest` to your global `opencode.json` plugin array.
- **GPT OAuth Prompt Enhancer** (`plugins/gpt-oauth-prompt-enhancer/`) – Injects OpenCode environment context and CLI formatting guidelines into GPT model conversations. Ensures GPT models follow CLI-specific Markdown rendering conventions and understand the AGENTS.md discovery system. Activates for any model ID containing "gpt". Install by copying `src/` folder locally and adding `index.ts` path to your global `opencode.json` plugin array.

---

## Security Reviewer

The **Security Reviewer** (`security-reviewer/`) is a specialized agent for auditing codebases against vibecoding vulnerabilities. It bundles 10 framework-specific security skills:

| Skill | Focus |
|-------|-------|
| **security-ai-keys** | AI API key leakage detection |
| **security-bun** | Bun runtime security patterns |
| **security-convex** | Convex auth/validators review |
| **security-django** | Django security settings audit |
| **security-docker** | Docker/container hardening |
| **security-express** | Express.js middleware security |
| **security-fastapi** | FastAPI auth/CORS validation |
| **security-nextjs** | Next.js Server Actions review |
| **security-secrets** | 25+ secret type detection |
| **security-vite** | Vite env var exposure checks |

**Installation**: Copy `.opencode/agent/` and `.opencode/skill/` to your global config or project.

See `security-reviewer/README.md` for full details.

---

## Configuration Examples

- **Thinking Levels Variants** (`thinking-variants config/thinking-levels-opencode.json`) – OpenCode configuration with model variants for Ctrl+T thinking level switching. Sup Mirrorwell's Antigravity Proxy (Gemini 3 Pro/Flash, Claude 4.5), and GLM coding plan (GLM-4.7). Enables dynamic reasoning effort and thinking budget adjustment directly from the UI.

---

## Included Packs

### Agent Catalog

Agents are organized under `agents/`:

- **generic/** – Reusable global agents that belong in `~/.config/opencode/agent/`:
  - **repo-navigator-creator** – Builds lean AGENTS.md navigation guides.
  - **subagent-orchestrator** – Dispatches specialists and enforces scope isolation.
  - **openspec-orchestrator** – Enforces strict OpenSpec formatting/validation and orchestrates subagents for executing OpenSpec proposals.
- **parallel-PRD/** – Parallel PRD planning kit with planner subagents, an orchestrator, and a PRD authoring skill. Produces a final mashup PRD at `/prd/[feat][final].md`.
- **component-engineer/** – Expert architecture package for building professional React components. Includes specialized commands for `/component-review` and `/component-create`, and a deep knowledge-base skill covering accessibility, composition, and attribute-driven styling.
- **opencode-configurator/** – Meta-configuration system for OpenCode (plugins, commands, agents, skills, models, MCP).
- **security-reviewer/** – Specialized agent for auditing codebases against vibecoding vulnerabilities.
- **create-opencode-plugin/** – Workflow bundle for AI-assisted plugin development.
- **vite-react-ts-convex-tailwind/** – Stack-specific experts for the modern Vite + React 19.2 + TS 5.9 + Tailwind 4.1 + Convex stack (also supports Bun). Includes the **Component Engineering Specification** internalized into core agent workflows:
  - **VRTCT-orchestrator** – Master coordinator for the entire stack, orchestrating subagents (does not write code).
  - **VRTCT-brain** – Stack knowledge base and implementation lead (writes code).
  - **convex-database-expert** – Schema/query/mutation/action specialist grounded in Convex docs.
  - **react-19-master** – React 19.2 implementation reviewer focused on Server Components, Actions, and the Component Engineering Specification (via `component-engineering` skill).
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
- **`/init`** (`commands/.opencode/command/init.md`): Creates or enhances AGENTS.md documentation while preserving human-crafted content. Analyzes repository structure and generates navigation guides for LLMs.
- **`/refactor-rfc-xml`** (`commands/.opencode/command/refactor-rfc-xml.md`): Converts markdown files to RFC 2119 + XML tag structure for precise, machine-readable documentation.
- **`/loop`** (`commands/.opencode/command/loop.md`): The "Ralph Wiggum" loop. An autonomous, multi-stage orchestrator that uses stateful task tool subagent sessions and dynamic checklist evolution to achieve 100% verified completion through sheer persistence.
- **`/component-review`** (`agents/component-engineer/.opencode/command/component-review.md`): Performs a rigorous, spec-aligned audit of a React component for a11y, composition, and professional patterns.
- **`/component-create`** (`agents/component-engineer/.opencode/command/component-create.md`): Generates a professional, spec-compliant React component or block based on high-level intent.

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

### Commands2Skills Template

> [!NOTE]
> **Partially Deprecated**: OpenCode now supports [Skills](https://opencode.ai/docs/skills/) natively. This template remains useful if you want agents to discover and execute `/commands` agentically via a COMMANDS.md index file injected at session start. For new projects, consider using Skills instead.

A universal command template with:
- **Command Integration Pattern**: 4-part architecture for command-to-tool interfaces (still works, but deprecated - OC now supports skills natively)
- **Template Structure**: Organized framework for command-based projects
- **Example Commands**: Repository exploration and mathematical calculation tools

See `commands2skills/README.md` for implementation details, architecture overviews,
and usage guidance.

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

## Enabling Skills

> [!IMPORTANT]
> All agents in this repository have **skills disabled by default**. This prevents context pollution and keeps agent behavior predictable. You MUST explicitly enable the skills you want each agent to use.

> [!IMPORTANT]
> **Skills Permission System (OC 1.1.2)**: As of OpenCode 1.1.2, the `permission: skill:` filtering system is currently non-functional. Agents can access all installed skills regardless of frontmatter settings. Do not rely on this for security or context isolation until a fix is released.

### How to Disable Skills

Add a `permission: skill:` section to the agent's YAML frontmatter:

```yaml
---
agent: your-agent-name
description: Your agent description
mode: primary
permission:
  skill:
    "*": "deny"
    "skill-name-1": "allow"
    "skill-name-2": "allow"
    
---
```

- List each skill you want to enable with `"allow"`
- Always end with `"*": "deny"` to block all other skills
- Skills MUST be installed in `~/.config/opencode/skill/` or `.opencode/skill/` for the agent to use them

Refer to each agent's documentation for the specific skills it supports.

## Additional Documentation
- `commands2skills/README.md` – command architecture, tooling integration, and
  usage instructions.
- `agents/README.md` – agent descriptions, guardrails, and setup guidance.

## About

This repository provides tested Opencode command patterns, global agent prompts,
and workflow templates that demonstrate best practices for creating maintainable,
scalable command-based projects with external tool integration.

---

## RFC 2119 + XML Tag Structure

All agent prompts, skills, and commands in this repository use **RFC 2119 keywords** and **XML tags** for structure. This isn't arbitrary formatting—it's research-backed prompt engineering.

### Why XML Tags?

XML tags provide clear boundaries that LLMs parse reliably:

- **Clarity**: Distinct separation between instructions, examples, and context reduces misinterpretation
- **Hierarchy**: Nested tags create logical groupings (e.g., `<workflow>` containing numbered steps)
- **Consistency**: Standardized tags like `<instructions>`, `<rules>`, `<examples>` work across all models
- **Parseability**: Structured output can be extracted programmatically when needed

```xml
<instructions>
1. Read the file
2. Apply changes
</instructions>

<rules>
- MUST preserve existing formatting
- SHOULD use surgical edits
</rules>
```

### Why RFC 2119 Keywords?

RFC 2119 (BCP 14) defines precise requirement levels used in internet standards since 1997:

| Keyword | Meaning |
|---------|---------|
| **MUST** | Absolute requirement. No exceptions. |
| **MUST NOT** | Absolute prohibition. |
| **SHOULD** | Strong recommendation, but valid reasons may exist to deviate. |
| **SHOULD NOT** | Discouraged, but acceptable in specific circumstances. |
| **MAY** | Truly optional. |

This eliminates ambiguity. "You should validate input" is vague. "The agent SHOULD validate input before processing" is precise—it's strongly recommended but not a hard failure if skipped with reason.

### Style Guide

See `RFC-XML-STYLE-GUIDE.md` for the complete reference, including tag catalogs, keyword definitions, and before/after examples. Use `/refactor-rfc-xml` to convert existing files.
