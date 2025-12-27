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