# Agent Design Patterns

<single_agent_patterns>

| Pattern | How it works | Best for |
|---------|--------------|----------|
| ReAct | Reason → Act → Observe → Repeat | Tool use with reasoning |
| Self-Refine | Generate → Critique → Refine | Quality-focused (writing, review) |
| Reflexion | Reflect on failures → Improve | Adaptive/learning tasks |

</single_agent_patterns>

<multi_agent_patterns>

| Pattern | How it works | Best for |
|---------|--------------|----------|
| Lead Agent | Orchestrator delegates to specialists | Multiple expertise domains |
| Router | Analyze request → Route to right agent | Diverse request types |
| Subagents/Other | Main agent spawns focused sub-agents | Long-horizon tasks, parallel exploration |

</multi_agent_patterns>

<agentic_behavior_levels>

1. **Output** - Agent decides what to output
2. **Task** - Agent decides how (tool selection, ordering)
3. **Process** - Agent decides overall approach and strategy

</agentic_behavior_levels>

<prompt_structure>

From OpenAI/Anthropic research, this structure works well:

```markdown
# Role and Objective

# Instructions

## Sub-categories for detailed guidance

# Workflow / Reasoning Steps

# Output Format

# Examples

# Context

# Final reminders
```

</prompt_structure>

<xml_tags>

XML outperforms JSON for long context and complex prompts:

```xml
<role>Expert code reviewer</role>

<instructions>
1. Analyze code for bugs
2. Check for security issues
3. Suggest improvements
</instructions>

<examples>
<example type="bug">
<input>for i in range(len(lst)): lst.pop(i)</input>
<output>Bug: Modifying list while iterating</output>
</example>
</examples>

<output_format>
Return findings as JSON: {"bugs": [], "security": [], "suggestions": []}
</output_format>
```

</xml_tags>

<agentic_reminders>

For tool-using agents, SHOULD include these:

| Reminder | Purpose | Example |
|----------|---------|---------|
| Persistence | Keep going until done | "Only yield when task is fully resolved" |
| Tool-calling | Use tools, don't guess | "If unsure, use tools to verify" |
| Planning | Think between actions | "Plan before each tool call, reflect after" |

</agentic_reminders>

<context_engineering>

| Principle | Bad | Good |
|-----------|-----|------|
| Be specific | "Review the code" | "Review for null pointer errors in auth module" |
| Right altitude | Hardcoded if-else | Clear heuristics with flexibility |
| Minimal context | Dump everything | Only what's needed for the task |
| Clear structure | Wall of text | XML tags or markdown sections |

</context_engineering>

<prompt_techniques>

| Technique | When to use |
|-----------|-------------|
| Few-shot examples | When format/style matters |
| Chain-of-thought | Complex reasoning tasks |
| XML structure | Multi-part prompts, long context |
| Step-by-step workflow | Procedural tasks |
| Self-verification | High-stakes outputs |
| Output format spec | Structured responses needed |

</prompt_techniques>

<failure_modes>

| Problem | Cause | Fix |
|---------|-------|-----|
| Hallucinated tool inputs | Forced to call tool without info | Add "ask user if unsure" |
| Repetitive phrasing | Sample phrases used verbatim | "Vary phrases naturally" |
| Over-explaining | No brevity instruction | "Be concise, no prose" |
| Wrong format | Format not specified | Add explicit format section |
| Premature completion | No persistence reminder | Add "keep going until done" |

</failure_modes>
