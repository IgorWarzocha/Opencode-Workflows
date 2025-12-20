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
- **`vite-react-convex-expert.md`** - Integration patterns for the full stack, with focus on orchestrating subagents
- **`convex-database-expert.md`** - Deep Convex expertise for schema design, queries, mutations, and backend patterns
- **`react-19-master.md`** - React 19.2 mastery including Server Components, Actions, and Compiler patterns
- **`typescript-59-engineer.md`** - TypeScript 5.9 expertise with advanced typing and modern patterns
- **`tailwind-41-architect.md`** - Tailwind CSS 4.1 expertise including new v4 features and theming

### Reference Documentation
- **`CONVEX.md`** - Comprehensive Convex development guide and best practices
- **`REACT19.md`** - Complete React 19+ reference with modern patterns
- **`TS59.MD`** - TypeScript 5.9+ language reference and configuration
- **`TAILWIND4.md`** - Tailwind CSS 4.1 complete reference and migration guide

## Usage

These agents are designed for:
- **Global installation** in `~/.config/opencode/agent/` for reuse across projects
- **Project-specific installation** in `.opencode/agent/` directories
- **Specialized development** when working with this specific tech stack

Each agent includes YAML frontmatter with usage guidance, mode constraints, and when to invoke the agent.

By default, `vite-react-convex-expert.md` is set up to only be the primary agent, while the rest of them can be used either as main agents or subagents. Otherwise, you're risking all your subagents to be delegated as VRCE.

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
