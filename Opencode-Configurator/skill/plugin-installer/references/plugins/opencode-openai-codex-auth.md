---
name: opencode-openai-codex-auth
description: Use ChatGPT Plus/Pro subscription for GPT 5.x Codex models via OAuth
---

# opencode-openai-codex-auth

**Package:** `opencode-openai-codex-auth`
**Author:** numman-ali
**Latest Version:** 4.2.0

## Purpose

Use your ChatGPT Plus/Pro subscription instead of OpenAI API credits. OAuth authentication via ChatGPT using the same method as the official Codex CLI.

## Features

- OAuth authentication via ChatGPT Plus/Pro
- 22 pre-configured model variants (GPT 5.2, GPT 5.1 Codex, Codex Max, Codex Mini)
- Reasoning levels: none/low/medium/high/xhigh
- Prompt caching support
- Full image input support for all models
- Auto-refreshing tokens
- CODEX_MODE bridge prompt with Task tool & MCP awareness

## Installation

```jsonc
{
  "plugin": ["opencode-openai-codex-auth@4.2.0"]
}
```

## Full Configuration (Recommended)

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-openai-codex-auth@4.2.0"],
  "provider": {
    "openai": {
      "options": {
        "reasoningEffort": "medium",
        "reasoningSummary": "auto",
        "textVerbosity": "medium",
        "include": ["reasoning.encrypted_content"],
        "store": false
      },
      "models": {
        "gpt-5.2-high": {
          "name": "GPT 5.2 High (OAuth)",
          "limit": { "context": 272000, "output": 128000 },
          "options": {
            "reasoningEffort": "high",
            "reasoningSummary": "detailed"
          }
        }
      }
    }
  }
}
```

## Setup

1. Add plugin to config
2. Restart OpenCode
3. Run `opencode auth login`
4. Select "OpenAI" → "ChatGPT Plus/Pro (Codex Subscription)"
5. Complete browser OAuth flow

## Available Models

| Model ID | Reasoning | Best For |
|----------|-----------|----------|
| `gpt-5.2-none` | None | Fastest responses |
| `gpt-5.2-low` | Low | Fast responses |
| `gpt-5.2-medium` | Medium | Balanced tasks |
| `gpt-5.2-high` | High | Complex reasoning |
| `gpt-5.2-xhigh` | xHigh | Deep analysis |
| `gpt-5.2-codex-*` | Low-xHigh | Coding tasks |
| `gpt-5.1-codex-max-*` | Low-xHigh | Large refactors |
| `gpt-5.1-codex-*` | Low-High | General code |
| `gpt-5.1-codex-mini-*` | Medium-High | Lightweight |

## Caveats

- **Personal use only** - not for commercial/multi-user applications
- Must use full config from `config/full-opencode.json` in the repo
- GPT 5 models can be temperamental - stick to presets
- Stop Codex CLI if running (both use port 1455)

## Updating

Change version number in config and restart. If stuck on old version:
```bash
rm -rf ~/.cache/opencode/node_modules ~/.cache/opencode/bun.lock
```

## Troubleshooting

- **401 Unauthorized:** Run `opencode auth login` again
- **Model not found:** Add `openai/` prefix (e.g., `--model=openai/gpt-5.2-codex-high`)

## Links

- [npm](https://www.npmjs.com/package/opencode-openai-codex-auth)
- [GitHub](https://github.com/numman-ali/opencode-openai-codex-auth)
- [Documentation](https://numman-ali.github.io/opencode-openai-codex-auth/)
