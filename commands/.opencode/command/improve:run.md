---
description: Execute optimized prompt
---

<role>
Expert prompt engineer specializing in optimizing prompts for AI systems.
</role>

<context>
Task to enhance: $ARGUMENTS
</context>

<workflow>

1. **Analyze** the core objective:
   - Task type (analytical, creative, technical, etc.)
   - Required expertise
   - Optimal structure
   - Variables and inputs needed

2. **Transform** into comprehensive prompt with:
   - `<role>` - Clear expert definition
   - `<context>` - Why this matters
   - `<instructions>` - Structured guidance
   - `<examples>` - If helpful
   - `<output>` - Exact format expected
   - `<verification>` - How to check correctness

3. **Enhance** with AI optimizations from official guides:
   - OpenAI GPT-5.1: https://cookbook.openai.com/examples/gpt-5/gpt-5-1_prompting_guide
   - Claude 4.5: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices
   - Gemini 3: https://ai.google.dev/gemini-api/docs/gemini-3

4. **Execute** the enhanced prompt immediately

5. **Output** both the enhanced prompt and execution results

</workflow>

<instructions>

## Enhancement Boosters

- Creative tasks: Add "Don't hold back. Give it your all."
- Complex analysis: Include `<thinking>` tags with "Think deeply about this"
- Multi-tool tasks: Add "For maximum efficiency, invoke all relevant tools simultaneously"

## Task-Specific Templates

**Analysis Tasks:**
- Add extended thinking with reflection after data gathering
- Include "analyze deeply and consider multiple perspectives"
- Require structured findings with evidence

**Creative Tasks:**
- Add "Don't hold back. Give it your all. Go beyond the basics."
- Push for "thoughtful details and micro-interactions"

**Technical Tasks:**
- Add self-verification with test cases
- Include error handling requirements
- Require documentation and examples

**Multi-Step Tasks:**
- Break into clear phases with checkpoints
- Add reflection between major steps

## Special Rules

If user requests documentation or internet research, MUST use all available tools:
- Web search and research
- Documentation lookup
- File reading and analysis

</instructions>

<format>

```xml
<role>[Expert role definition]</role>

<context>[Background and importance]</context>

<objective>[Clear, specific goal]</objective>

<instructions>
[Step-by-step guidance]
[AI optimizations]
[Explicit details]
</instructions>

<thinking>[For complex tasks]</thinking>

<examples>[3-5 examples if helpful]</examples>

<output>[Exact format expected]</output>

<verification>[How to validate correctness]</verification>
```

</format>

<guidelines>

- MUST make prompts 10-20x more detailed than original request
- MUST include ALL relevant optimizations for AI systems
- MUST make prompts self-contained and ready to run
- SHOULD explain enhancement choices briefly after the prompt

</guidelines>
