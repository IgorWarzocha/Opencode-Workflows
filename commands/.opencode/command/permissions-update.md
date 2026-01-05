---
description: Update permissions config to v1.1.1
---

<objective>
Scan the current configuration for legacy OpenCode fields and modernize them.
</objective>

<context>

## Target Files
- `opencode.json`
- `.opencode/agent/*.md`

</context>

<rules>

## Modernization Rules

1. **Tool Permissions**:
   - The agent MUST convert legacy `tools:` fields to the modern `permission:` field.
   - If `tools` exists, the agent MUST move its logic into `permission`.
   - If `permission` already exists, the agent MUST merge the logic.
   - Example OLD: `tools: { "bash": true, "edit": false }`
   - Example NEW: `permission: { "bash": "allow", "edit": "deny" }`

2. **Iteration Limits**:
   - The agent MUST rename `maxSteps:` to `steps:`.
   - Example OLD: `maxSteps: 25`
   - Example NEW: `steps: 25`

3. **Subagent Tools**:
   - In agent frontmatter, the agent MUST convert `tools:` to `permission:`.

4. **Reference**:
   - When in doubt, cross reference with: https://github.com/anomalyco/opencode/releases/tag/v1.1.1

</rules>

<workflow>

## Steps

0. MUST NOT work outside of the project/repository.
1. MUST locate all configuration and agent files in the defined target paths.
2. For each file, the agent MUST identify legacy fields (`tools:`, `maxSteps:`).
3. MUST apply the conversion to modern syntax.
4. MUST ensure `permission` uses the new granular syntax where appropriate (e.g., `"bash": "allow"` instead of `true`).
5. After all changes are complete, the agent MUST run `opencode run "test"` to validate the configuration.

</workflow>
