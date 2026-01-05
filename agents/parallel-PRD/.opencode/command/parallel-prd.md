---
description: Run a multimodel PRD process
---

<arguments>
$ARGUMENTS contains the problem statement or feature request to analyze.

Examples:
- "Build a real-time collaborative document editor"
- "Create an authentication system with OAuth providers"
- "Design a scalable e-commerce inventory management system"

If empty, prompt the user for the problem statement.
</arguments>

<context>
You are running a parallel PRD generation process to:
- Compare different analytical approaches
- Synthesize the best ideas across planners
- Identify blind spots through diverse viewpoints
- Create a comprehensive, well-considered PRD
</context>

<workflow>

<phase name="validate_input">
1. Confirm you have a clear problem statement in $ARGUMENTS.
2. If empty or vague, ask the user: "What problem or feature should I analyze?"
3. You MUST NOT proceed until you have a specific problem statement.
</phase>

<phase name="gather_context">
1. You MUST use the `prd-authoring` skill guidance as the primary reference for structure, depth, and task formatting.
2. If the user provided repo files or docs, read them.
3. You SHOULD use websearch and webfetch to resolve missing facts or validate assumptions, even if no URLs were supplied.
4. You MAY proactively pull official docs or standards when they materially improve the PRD.
5. Keep context strictly relevant to the PRD.
</phase>

<phase name="prepare_prompt">
Create a single, detailed prompt that includes:
- The problem statement from $ARGUMENTS.
- Any relevant context (tech stack, constraints, goals).
- A directive to follow the `prd-authoring` skill guidance closely.
- Request for a comprehensive PRD following the template.

<example>
Prompt structure:
```
Please create a comprehensive PRD for the following feature:

[Problem statement from $ARGUMENTS]

Context:
- Tech stack: [if provided]
- Constraints: [if provided]
- Goals: [if provided]

Follow the PRD template structure exactly. Focus on architecture, requirements, and technical strategy.
```
</example>
</phase>

<phase name="dispatch_agents">
<critical_instruction>
You MUST dispatch all planner subagents with the EXACT SAME PROMPT. You MUST NOT customize the prompt for each model.
</critical_instruction>

Use the Task tool to launch all planner agents concurrently (in a single message).
Each subagent will:
- Receive the same prompt.
- Output a .md PRD file in `/prd/` directory using `[feat][<suffix>].md`.
- Not write any code (documentation only).
</phase>

<phase name="wait_for_completion">
- All planners run in parallel.
- You MUST wait for all planners to complete before proceeding.
- Each planner should produce one .md file.
</phase>

<phase name="synthesize_results">
1. Read each generated PRD file.
2. Use the `prd-authoring` skill guidance to validate section completeness and task formatting.
3. Synthesize a single best-of PRD that merges the strongest parts.
4. Save the mashup to `/prd/[feat][final].md`.
5. Provide a brief comparison summary in your response.
</phase>

</workflow>

<constraints>
You MUST NOT:
- Modify the prompt between agents.
- Write code yourself (focus on synthesis).
- Skip the mashup step.
- Edit other agent's PRD files.

You MUST:
- Ensure identical prompts for all planner agents.
- Launch all Task calls in one message.
- Wait for completion before synthesizing.
- Write the final mashup file at `/prd/[feat][final].md`.
</constraints>

<output>
Final deliverables:
1. N PRD markdown files in `/prd/` directory (one per planner).
2. One final mashup PRD at `/prd/[feat][final].md`.

The PRD files MUST use the naming convention: `[feat][<suffix>].md`.
</output>
