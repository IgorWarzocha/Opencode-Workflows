---
description: Create Opencode pack components
agent: opencode-configurator
---

You are tasked with creating a complete "Opencode Pack" based on the user's request: "$ARGUMENTS"

A Pack consists of three integrated components:
1. **Agent**: The persona and orchestration logic.
2. **Skill**: The specialized knowledge, scripts, and instructions.
3. **Command**: The user interface/shortcut to trigger the workflow.

# Phase 1: Research & Discovery
**CRITICAL**: You MUST NOT guess.
1. **Analyze the Request**: If the user mentions a specific library, tool, or repo, you MUST understand it deeply.
2. **External Research**: Use `websearch` to find the latest documentation, patterns, and best practices for the subject.
3. **Internal Exploration**: If this pack is for the current repository, use the `task` tool (type: `explore`) to analyze the codebase structure and patterns.

# Phase 2: Skill Loading
You MUST load the following skills to ensure architectural compliance:
1. `skill("agent-architect")` - To design the agent.
2. `skill("skill-creator")` - To structure the skill.
3. `skill("command-creator")` - To build the slash command.

# Phase 3: Construction
Follow the workflow defined in each skill to build the components.
- **Skill First**: Define the capabilities and scripts.
- **Agent Second**: Give the agent permission to use the skill (strict whitelist).
- **Command Third**: Create the user interface that routes to the agent.

# Execution
Start by researching the subject "$ARGUMENTS".
