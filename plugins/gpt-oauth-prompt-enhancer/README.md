# GPT Oath Prompt Enhancer

Injects OpenCode environment context and CLI formatting guidelines into GPT model conversations.

## What It Does

Prepends a system reminder with essential OpenCode context:
- **CLI Output Format**: Markdown rendering guidelines, header formatting, bullet structure, code reference patterns
- **AGENTS.md Discovery**: How AGENTS.md files are discovered and prioritized in directory trees
- **Working Style**: Autonomy guidance, Task/Skill tool usage, testing by approval mode

The injected prompt ensures GPT models follow OpenCode's CLI-specific formatting conventions and understand the AGENTS.md discovery system.

## Targeting

Activates based on model name matching:
- Matches any model ID containing `gpt` (case-insensitive)

Other models are unaffected.

## Installation

1. Copy this plugin folder to a local location, e.g.:
   ```
   ~/.config/opencode/plugin/gpt-oauth-prompt-enhancer/
   ```

2. Add the `src/index.ts` file path to your global `opencode.json` plugin array:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "file:///home/your-user/.config/opencode/plugin/gpt-oauth-prompt-enhancer/src/index.ts"
  ]
}
```

Adjust the path to match your actual installation location.

## Implementation Details

- Uses the `chat.message` hook to intercept all outgoing messages
- Checks model providerID/modelID for "gpt" substring match
- Wraps reminder content in `<system_reminder>` tags for proper parsing
- Skips injection if reminder already present in message parts
- Injects as synthetic text part to distinguish from user content
