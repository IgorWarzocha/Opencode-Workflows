## Repository Overview

This is the **Opencode Workflows** repository - a collection of Opencode-based command templates and workflow patterns for building sophisticated command-based projects. The repository contains multiple workflow examples and templates that demonstrate different approaches to command architecture and tool integration.

## Current Workflows

### Agent Templates Catalog
A focused collection of reusable agent prompts and orchestration patterns:
- **repo-maintainer**: Repository health custodian (audits, doc sync). **NOTE: This root agent is specific to the Opencode-Workflows repo.**
- **fast**: High-speed workhorse for trivial edits, running known commands, and simple file lookups.
- **smart**: Senior developer and architect for complex bug hunting, codebase refactoring, and verified implementation.
- **repo-navigator-creator**: Produces lean AGENTS.md navigation guides
- **subagent-orchestrator**: Dispatches specialized agents and manages execution plans
- **openspec-orchestrator**: Enforces strict OpenSpec formatting/validation and orchestrates subagents

Agents are designed for global installation in `~/.config/opencode/agent/` for reuse across projects.

### AI Research Tools
- `scripts/perplexica-cli.js` - External tool for AI search integration with proper timeout handling
- `scripts/.opencode/command/perplexica-search.md` - Command for AI search with smart mode selection
- Demonstrates integration with external AI services and APIs

## Architecture Patterns

### Command Structure
Commands follow Opencode's built-in `/commands` patterns (see opencode.ai/docs/commands):
- YAML frontmatter with descriptions
- Arguments section explaining $ARGUMENTS handling
- Step-by-step execution instructions
- Integration with external utilities

### Tool Integration
Commands can integrate with various external tools:
- **Script files**: JavaScript, Python, Bash executables
- **Bash tools**: System utilities, package managers, development tools
- **API endpoints**: Any curlable REST APIs or webhooks
- **Natural language workflows**: Pure LLM-driven processes

### Agent Structure
Agents follow Opencode's agent patterns with YAML frontmatter:
- **Description**: Clear guidance on when to use each agent
- **Mode**: Operation mode and tool constraints (read-only vs write)
- **Instruction Blocks**: LLM-optimized checklists and workflows
- **Global Installation**: Designed for reuse across projects via `~/.config/opencode/agent/`

### Configuration System
- `example-opencode.json` templates for Opencode configuration. Demonstrates disabling the legacy `general` subagent in favor of `fast`/`smart` splitting to optimize model usage:
  ```json
  "subagents": {
    "general": {
      "disable": true
    }
  }
  ```
- References to `AGENTS.md` in instructions arrays
- `package.json` in `.opencode/` for Opencode plugin dependencies
- Follows Opencode schema standards

## Model Requirements

Repository intelligence requires models with strong:
- **Context Management**: Maintaining project-level instructions throughout session
- **Instruction Following**: Precise execution of multi-step workflows
- **Agentic Capabilities**: Understanding when/how to use available commands and agents

**Recommended Models**: GPT-5.2, Claude 4.5, Gemini 3.

## Repository Structure

```
at/                          # Universal engineering guidelines (@coding-ts)
├── CODING-TS.MD             # Core development principles and standards

.opencode/                   # Root-level maintenance tools
├── agent/
│   └── repo-maintainer.md   # Health custodian
├── command/
│   ├── audit-repo.md        # Quality audit
│   ├── maintain-repo.md     # Full maintenance cycle
│   └── sync-docs.md         # Doc synchronization
└── skill/
    └── repo-maintenance/    # Maintenance logic & scripts

thinking-variants config/    # Thinking-level configurations

agents/                      # Agent templates catalog
├── README.md               # Agent overview and usage guidance
├── component-engineer/      # Expert architecture package
├── create-opencode-plugin/  # Plugin creation workflow
├── generic/                # Globally useful agents
│   └── .opencode/
│       └── agent/
│           ├── fast.md                     # High-speed workhorse
│           ├── smart.md                    # Complex architecture expert
│           ├── repo-navigator-creator.md   # AGENTS.md generation
│           ├── subagent-orchestrator.md    # Multi-agent coordination
│           └── openspec-orchestrator.md    # OpenSpec workflow enforcement
├── opencode-configurator/   # Configurator skills, agents, and commands
├── parallel-PRD/           # Parallel PRD planning kit
├── security-reviewer/       # Security review tooling
└── vite-react-ts-convex-tailwind/ # Stack-specific expert pack
    ├── CONVEX.md           # Convex documentation
    ├── REACT19.md          # React 19 documentation
    ├── TAILWIND4.md        # Tailwind 4 documentation
    ├── TS59.MD             # TypeScript 5.9 documentation
    └── .opencode/
        └── agent/
            ├── VRTCT-orchestrator.md       # Stack orchestrator
            ├── VRTCT-brain.md              # Stack knowledge base
            ├── convex-database-expert.md   # Backend/DB specialist
            ├── react-19-master.md          # RSC/Actions expert
            ├── tailwind-41-architect.md    # Utility-first designer
            └── typescript-59-engineer.md   # Strict TS 5.9 engineer

commands/                    # Additional command examples

scripts/                     # External utility tools
├── perplexica-cli.js       # AI search integration tool
└── .opencode/
    └── command/
        └── perplexica-search.md # Search workflow with citations
```

## Working with This Repository

### For Template Usage
1. Review available workflow templates in agents/ and commands/
2. Copy template elements selectively for your projects
3. Create your own `opencode.json` based on examples
4. Adapt commands and tools to specific needs
5. Install desired agents globally in `~/.config/opencode/agent/` for reuse across projects

### For Agent Usage
- Agents are designed for global installation but can be copied to project-specific `.opencode/agent/` directories
- Check YAML frontmatter to understand when to use each agent and any tool constraints
- Agents complement commands by providing specialized reasoning, research, or coordination
- Reference the relevant agent file before acting to respect mode and tool constraints

### For Workflow Development
- Commands follow Opencode `/commands` rules and patterns
- External tools should handle errors gracefully
- Documentation maintenance via specialized agents
- Model compatibility considerations for context management

## Future Development

This repository is designed to expand with additional workflow templates and patterns. Future workflows may include:
- Different command architectures and integration patterns
- Additional external tool integrations
- Alternative documentation systems
- Enhanced model compatibility patterns
- More specialized agent templates for different domains

## Key Insights

- This is a **workflow repository**, not a traditional application - no build/test/lint commands
- Focus on **reusable patterns** and **template architectures**
- Commands follow **Opencode standards** for compatibility
- Context injection currently limited to session-start (future enhancement possible)
