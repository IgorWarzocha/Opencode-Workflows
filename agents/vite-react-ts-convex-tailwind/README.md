# Vite + React 19 + TypeScript 5.9 + Convex + Tailwind 4.1 Agents

A specialized collection of Opencode agents for building modern full-stack web applications with the Vite + React 19 + TypeScript 5.9 + Convex + Tailwind 4.1 stack.

## Stack Overview

- **Vite**: Fast build tool and development server
- **React 19**: Latest React with Server Components, Actions, and Compiler
- **TypeScript 5.9**: Modern TypeScript with latest features and strict defaults
- **Convex**: Reactive database and serverless backend
- **Tailwind CSS 4.1**: Utility-first CSS framework with new v4 features

*Note: this will also work with Bun. Just make sure to initialise your project with Bun rather than Vite.*

![VRTCT](VRTCT.jpg)

## Available Agents

### Core Technology Agents
- **`VRTCT-orchestrator.md`** - Master coordinator for the full stack, orchestrating subagents (does not write code)
- **`VRTCT-brain.md`** - Stack knowledge base and implementation lead (writes code)
- **`convex-database-expert.md`** - Deep Convex expertise for schema design, queries, mutations, and backend patterns
- **`react-19-master.md`** - React 19.2 mastery including Server Components, Actions, and the Component Engineering Specification (via `component-engineering` skill)
- **`typescript-59-engineer.md`** - TypeScript 5.9 expertise with advanced typing and modern patterns
- **`tailwind-41-architect.md`** - Tailwind CSS 4.1 expertise including new v4 features and theming

### Reference Documentation
- **`CODING-TS.md`** - Universal engineering guidelines for TypeScript projects
- **`CONVEX.md`** - Comprehensive Convex development guide and best practices
- **`REACT19.md`** - Complete React 19+ reference with modern patterns
- **`TS59.MD`** - TypeScript 5.9+ language reference and configuration
- **`TAILWIND4.md`** - Tailwind CSS 4.1 complete reference and migration guide

### Specialized Skills
The pack includes five specialized Convex skills for deep backend implementation:
- **`convex-core`** - Base data modeling, functions, and validation patterns.
- **`convex-runtime`** - HTTP actions, file storage, search indexes, and scheduling.
- **`convex-auth`** - Authentication (Clerk/WorkOS/Auth0) and Convex Auth patterns.
- **`convex-deploy`** - Deployment workflows, CI/CD, and environment management.
- **`convex-components`** - Isolated backend components (Agent, RAG, Workpool, Workflow).

## Spec-Driven Component Engineering

This stack incorporates a formal Component Engineering Specification via the `component-engineering` skill.

### Commands
- `/component-review [file]`: Audits a React component against a11y, composition, and styling pillars.
- `/component-create [name] [intent]`: Generates professional, spec-compliant UI artifacts.

### Key Principles
- **Semantic First**: Uses native elements for built-in a11y.
- **asChild Pattern**: Composable APIs via Radix Slot.
- **Data-Driven Styling**: Stable `data-slot` and `data-state` hooks for Tailwind v4.
- **Artifact Taxonomy**: Standard classification (Primitive, Component, Block).

## Usage

These agents are designed for:
- **Global installation** in `~/.config/opencode/agent/` for reuse across projects
- **Project-specific installation** in `.opencode/agent/` directories
- **Specialized development** when working with this specific tech stack

Each agent includes YAML frontmatter with usage guidance, mode constraints, and when to invoke the agent. Agent instructions use RFC 2119 keywords and XML tags for unambiguous behavior.

By default, `VRTCT-orchestrator.md` is set up to only be the primary agent (coordination only, no code), while `VRTCT-brain.md` handles implementation. The rest can be used either as main agents or subagents. This separation prevents your orchestrator from getting bogged down in implementation details.

## Scoped Skills and Isolation

> [!IMPORTANT]
> To prevent context pollution and ensure predictable behavior, VRTCT agents follow the **Principle of Least Privilege**. Every agent MUST have all irrelevant skills disabled, only enabling the specific skills required for its domain.

- **`convex-database-expert.md`**: Only allows `convex-core`, `convex-runtime`, `convex-auth`, `convex-deploy`, and `convex-components`.
- **`VRTCT-brain.md`**: Only allows `component-engineering`.
- **Others**: Explicitly set to `"*": "deny"` to ensure zero external skill interference.

## Recommended changes to frontmatters

Select your preferred model for the agents. I highly recommend putting a high-context model as the `vite-react-convex-expert.md` agent, since this will be your main subagent orchestrator. Theoretically it should only delegate tasks and verify the outputs, so by using a big context model your session can go for a while without interruption. Consider Gemini 3 Pro for this. Opus or a GPT model for Convex. Gemini 3 Pro knows a bit of Tailwind 4.1, so it's a good contender. GLM is surprisingly good for frontend. The "cheapstack" is the free tier Gemini CLI and GLM for subagents.

```
(...)
  </commentary>
</example>
mode: primary
model: google/gemini-3-pro-preview
---
(...)
```

## Recommended AGENTS.md inclusions

To avoid the agents constantly trying to start new Vite/Bun/Convex processes, you should include the following in your `AGENTS.md` file:

```

Vite/Bun/Convex will be running at all times. You are to NEVER start a new process for these. Your main interactions with them should be through linters and convex codegen command.

```
