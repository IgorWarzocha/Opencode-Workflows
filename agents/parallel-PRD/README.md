# Parallel PRD Generation Agents

Parallel PRD workflow: one command dispatches multiple planners and writes a final mashup PRD.

## Contents

- `.opencode/command/parallel-prd.md` orchestrator command
- `.opencode/agent/` planners plus `parallel-prd-orchestrator.md` and `TEMPLATE-planner.md`
- `.opencode/skill/prd-authoring/` PRD guidance and example

## Usage

```bash
opencode run "parallel-prd <problem statement>"
```

Outputs:
- `/prd/[feat][<suffix>].md` for each planner
- `/prd/[feat][final].md` mashup PRD
- Synthesis report printed to the terminal

## Add a Custom Planner

1. Copy `TEMPLATE-planner.md` into `.opencode/agent/` with a new filename.
2. Update the frontmatter `model` field (use precise output from `opencode models`).
3. Replace `YOUR-SUFFIX-HERE` in the template (required_output + instructions section).
4. Update `.opencode/command/parallel-prd.md` to include the new agent in dispatch + synthesis.

## Default Planners

- `gemini-pro-planner`
- `glm-planner`
- `gemini-flash-planner`
