# Opencode Agent Templates

A focused catalog of agent prompts and orchestration patterns designed for Opencode projects. Each agent lives in a `.opencode/agent/` directory with YAML metadata plus a purpose-built instruction block tailored to the workflows it supports.

All agent files use **RFC 2119 keywords** (MUST, SHOULD, MAY) and **XML tags** (`<instructions>`, `<workflow>`, `<rules>`) for precise, unambiguous behavior. See `RFC-XML-STYLE-GUIDE.md` in the repository root for the full specification.

## Architecture Overview

The `agents/` directory contains specialized agent collections, complemented by universal engineering guidelines in the root `at/` directory.

- **generic/** – Canonical, globally useful agents that pair well with any Opencode repo. Install these into `~/.config/opencode/agent/` to make them universally available.
- **vite-react-ts-convex-tailwind/** – A stack-specific toolkit that bundles six specialists plus stack documentation files (`CONVEX.md`, `REACT19.md`, `TAILWIND4.md`, `TS59.MD`, `CODING-TS.md`). Each expert agent explicitly references its matching doc so it can cite authoritative guidance when reasoning.

Each collection demonstrates how to scope agents for a domain, define guardrails in YAML frontmatter, and ship reusable workflows alongside optional documentation.

## Agent Collections

### Generic Global Agents (`agents/generic/.opencode/agent/`)

| Agent | Description |
| --- | --- |
| `repo-navigator-creator` | Produces lean AGENTS.md navigation guides so LLMs can traverse repositories without context overload. |
| `subagent-orchestrator` | Dispatches specialized agents, partitions scopes, and manages parallel/sequential execution plans. |
| `openspec-orchestrator` | Enforces strict OpenSpec formatting, runs validations, and coordinates specialists across proposal, implementation, and archive workflows. Requires [OpenSpec](https://openspec.dev/) plus `openspec init`. |

Install these globally whenever you want standard orchestration helpers available in every session.

### Vite + React + TS + Tailwind + Convex Pack (`agents/vite-react-ts-convex-tailwind/.opencode/agent/`)

| Agent | Description |
| --- | --- |
| `VRTCT-orchestrator` | Master coordinator for the full stack, orchestrating subagents and enforcing React 19.2, Tailwind 4.1, TS 5.9, and Convex best practices. Does not write code. |
| `VRTCT-brain` | Stack knowledge base and implementation lead. Writes code grounded in the stack documentation. |
| `convex-database-expert` | Senior Convex engineer covering schema design, queries/mutations/actions, auth, and operational debugging with references to `CONVEX.md`. |
| `react-19-master` | Deep React 19.2 mentor specializing in Server Components, Server Actions, and new compiler-driven ergonomics, grounded in `REACT19.md`. |
| `tailwind-41-architect` | Tailwind CSS 4.1 strategist that pushes the CSS-first architecture, container queries, and modern utility set, citing `TAILWIND4.md`. |
| `typescript-59-engineer` | Strict TypeScript 5.9 expert who enforces erasable syntax, verbatim module imports, and compiler-aligned patterns informed by `TS59.MD`. |

Each specialist reminds downstream assistants that the relevant reference document is available for consultation, ensuring answers stay aligned with the stack docs.

## Usage Flow

1. Identify the collection that matches your context (Generic vs. stack-specific).
2. Reference the relevant agent file in `.opencode/agent/` and review its YAML frontmatter for `mode`, guardrails, and tool constraints.
3. Follow the instruction block exactly—these steps are tuned for autonomous execution.
4. When using stack-specific experts, open the accompanying doc (`CONVEX.md`, etc.) if you need deeper citations or confirmation.
5. Reference `@coding-ts` (`at/CODING-TS.MD`) for universal engineering standards and clean architecture principles.

## Enabling Skills

> [!IMPORTANT]
> All agents in this repository have **skills disabled by default**. This prevents context pollution and keeps agent behavior predictable. You MUST explicitly enable the skills you want each agent to use.

### How to Enable Skills

Add a `permission: skill:` section to the agent's YAML frontmatter:

```yaml
---
agent: your-agent-name
description: Your agent description
mode: primary
permission:
  skill:
    "skill-name-1": "allow"
    "skill-name-2": "allow"
    "*": "deny"
---
```

- List each skill you want to enable with `"allow"`
- Always end with `"*": "deny"` to block all other skills
- Skills MUST be installed in `~/.config/opencode/skill/` or `.opencode/skill/` for the agent to use them

Refer to each agent's documentation for the specific skills it supports.

## Relationship to Commands

Agents complement Opencode commands:

- **Commands** in `.opencode/command/` describe end-to-end workflows (see `commands2skills/README.md`).
- **Agents** in `.opencode/agent/` provide targeted reasoning, research, or orchestration within those workflows.

Mix and match as needed: commands launch processes, agents keep the reasoning sharp.

## File Structure

```
.
├── at/                      # Global standards (@coding-ts)
└── agents/
    ├── README.md
    ├── generic/
    │   └── .opencode/
    │       └── agent/
    │           ├── repo-navigator-creator.md
    │           ├── subagent-orchestrator.md
    │           └── openspec-orchestrator.md
    └── vite-react-ts-convex-tailwind/
        ├── CODING-TS.md
        ├── CONVEX.md
        ├── REACT19.md
        ├── TAILWIND4.md
        ├── TS59.MD
        └── .opencode/
            └── agent/
                ├── VRTCT-orchestrator.md
                ├── VRTCT-brain.md
                ├── convex-database-expert.md
                ├── react-19-master.md
                ├── tailwind-41-architect.md
                └── typescript-59-engineer.md
```

## Adding New Agents

1. Run `opencode agent create` (or copy an existing pattern) to scaffold proper identifiers and mode/tool constraints.
2. Place the file inside the relevant collection’s `.opencode/agent/` directory.
3. Keep instructions lean: highlight guardrails, workflows, and required reference docs.
4. Update this README’s tables/tree so other contributors know the new agent exists.

## Guidance for LLMs

- Always read the agent’s frontmatter before acting; it defines when to use the agent and any tool restrictions.
- Respect documentation hooks—if the agent mentions a supporting `.MD` file, treat it as available context for authoritative answers.
- Ask clarifying questions when requirements are ambiguous rather than guessing.
- Keep responses concise, implementation-focused, and grounded in the referenced standards (@coding-ts, OpenSpec, React 19, Tailwind 4.1, Convex, etc.).
