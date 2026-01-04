# Parallel PRD Generation Agents

Parallel PRD workflow: one command dispatches multiple planners and writes a final mashup PRD.

## Contents

- `.opencode/command/parallel-prd.md` orchestrator command
- `.opencode/agent/` planners plus `parallel-prd-orchestrator.md` and `TEMPLATE-planner.md`
- `.opencode/skill/prd-authoring/` PRD guidance and example

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/1f2f5e58-c9c3-4ab8-9713-6255712eb84a" />

## Usage

Drop into your global ./config/opencode/ folder or your repository. Run `opencode models` to find precise identifiers for the template. Copy the template as many times as you want to create your parallel planners. Select the Orchestrator agent in Opencode and invoke `/parallel-prd command`. Watch it fly.

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
