# Gemini/GLM Focused Mode

Injects a rigorous system prompt for GLM and Gemini models to enforce focused, deterministic coding behavior.

## What It Does

Prepends a strict execution framework to improve:
- **Precision**: Execute immediately, output first, rationale second
- **Grounding**: Verify claims with tools before stating them
- **Persistence**: Try 3 approaches before escalating to user
- **Completeness**: Only report done when verified working

The injected prompt enforces concise responses, complete implementations, and proper error recovery.

## Targeting

Activates based on model name matching:
- Matches any model ID containing `glm-4.7`
- Matches any model ID containing `gemini`

Other models are unaffected.

## Installation

1. Copy the `index.ts` file to a local folder, e.g.:
   ```
   ~/.config/opencode/plugin/gemini-glm-focused-mode/
   ```

2. Add the file path to your global `opencode.json` plugin array:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "file:///home/your-user/.config/opencode/plugin/gemini-glm-focused-mode/index.ts"
  ]
}
```

Adjust the path to match your actual installation location.

## Bonus: Provider Configuration

The `opencode.json` file included here is my personal setup. It configures GLM models to use the Anthropic adapter endpoint, which I've found to be faster and more reliable with tool calls - the model just seems smarter through this adapter.

**Quirks I've run into:**

- Token counting is broken, so you need to manually control session lenght compaction (best used for subagents with specific tasks)
- If you stay within OpenCode's normal limits (max output is always 32k, so the reasonable thinking budget would be 24k), everything's compliant but GLM won't attempt hard thinking
- It could theoretically overextend into deep thinking modes and cause issues, but that's never happened to me

The default thinking budget is set to 64000 tokens since I use GLM for my `general`, `compaction`, and `explore` subagents where I prefer thinking enabled. The issue here is that you can't use variants in this part of the config. You define models for these agents in your `opencode.json` file, e.g.:

```"agent": {
    "plan": { "model": "local/antigravity/gemini-3-pro" },
    "general": {
      "model": "zai-coding-plan/glm-4.7"
    },
    "explore": {
      "model": "zai-coding-plan/glm-4.7"
    },
    "compaction": {
      "model": "zai-coding-plan/glm-4.7"
    }
```

Your mileage may vary, but I've found this tradeoff worth it. Adapt the config to your own risk tolerance.
