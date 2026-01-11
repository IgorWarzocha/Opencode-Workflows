---
name: LLM-API-Key-Proxy
description: Universal LLM gateway with Antigravity, Gemini CLI, key rotation (use dev/beta)
---

# LLM-API-Key-Proxy

**Type:** External Tool (not npm plugin)
**Author:** Mirrowel
**Status:** Use dev/beta release for latest features

## Purpose

Universal LLM Gateway - one OpenAI-compatible API endpoint for all providers. Self-hosted proxy with automatic key rotation, failover, and exclusive provider support.

## Features

- Single `/v1/chat/completions` endpoint for all providers
- Automatic key rotation and load balancing
- Rate limit handling with intelligent cooldowns
- Escalating cooldowns per model (10s → 30s → 60s → 120s)
- OAuth support: Gemini CLI, Antigravity, Qwen Code, iFlow
- Interactive TUI for configuration
- Detailed request logging

## Exclusive Providers

Providers not available elsewhere:

| Provider | Models | Notes |
|----------|--------|-------|
| **Antigravity** | Gemini 3 Pro, Claude Opus 4.5, Claude Sonnet 4.5 | thinkingLevel support |
| **Gemini CLI** | All Gemini models | Higher rate limits via internal API |
| **Qwen Code** | Qwen coder models | `<think>` tag parsing |
| **iFlow** | Various | Hybrid auth |

## Installation

1. Download from [GitHub Releases](https://github.com/Mirrowel/LLM-API-Key-Proxy/releases)
   - **Use dev/beta release for Antigravity and latest features**
2. Extract and run:
   - Windows: `proxy_app.exe`
   - macOS/Linux: `chmod +x proxy_app && ./proxy_app`
3. Configure credentials via TUI

### From Source

```bash
git clone https://github.com/Mirrowel/LLM-API-Key-Proxy.git
cd LLM-API-Key-Proxy
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python src/proxy_app/main.py
```

## OpenCode Configuration

```jsonc
{
  "provider": {
    "local": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LLM Proxy",
      "options": {
        "baseURL": "http://127.0.0.1:8000/v1",
        "apiKey": "your-PROXY_API_KEY-from-env"
      },
      "models": {
        "gemini-2.5-flash": {
          "id": "gemini/gemini-2.5-flash",
          "name": "Gemini 2.5 Flash"
        },
        "antigravity-gemini-3": {
          "id": "antigravity/gemini-3-pro-preview",
          "name": "Gemini 3 Pro (Antigravity)",
          "reasoning": true
        },
        "antigravity-claude-opus": {
          "id": "antigravity/claude-opus-4-5",
          "name": "Claude Opus 4.5 (Antigravity)",
          "reasoning": true
        },
        "gemini-cli-pro": {
          "id": "gemini_cli/gemini-2.5-pro",
          "name": "Gemini 2.5 Pro (CLI)"
        }
      }
    }
  }
}
```

## Model Format

**Important:** Models must be `provider/model_name`:

```
gemini/gemini-2.5-flash          # Gemini API
openai/gpt-4o                    # OpenAI API
anthropic/claude-3-5-sonnet      # Anthropic API
openrouter/anthropic/claude-3-opus  # OpenRouter
gemini_cli/gemini-2.5-pro        # Gemini CLI (OAuth)
antigravity/gemini-3-pro-preview # Antigravity
antigravity/claude-opus-4-5      # Claude Opus 4.5
antigravity/claude-sonnet-4-5    # Claude Sonnet 4.5
```

## Credential Setup

### API Keys

Create `.env` file:
```bash
PROXY_API_KEY="your-secret-proxy-key"
GEMINI_API_KEY_1="key1"
GEMINI_API_KEY_2="key2"
OPENAI_API_KEY_1="sk-..."
ANTHROPIC_API_KEY_1="sk-ant-..."
```

### OAuth (Antigravity, Gemini CLI)

```bash
python -m rotator_library.credential_tool
# Select "Add OAuth Credential" → provider
# Complete browser authentication
```

## API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /` | Status check |
| `POST /v1/chat/completions` | Chat completions (main) |
| `POST /v1/embeddings` | Text embeddings |
| `GET /v1/models` | List available models |
| `GET /v1/providers` | List configured providers |

## Advanced Config

```bash
# Concurrency per provider
MAX_CONCURRENT_REQUESTS_PER_KEY_OPENAI=3

# Rotation mode
ROTATION_MODE_GEMINI=sequential  # or balanced

# Model filtering
IGNORE_MODELS_OPENAI="*-preview*"
WHITELIST_MODELS_GEMINI="gemini-2.5-pro,gemini-2.5-flash"
```

## Caveats

- Requires running separate proxy process
- **Use dev/beta release** for Antigravity and Gemini 3 support
- OAuth credentials need browser authentication
- Gemini 3 models require paid-tier Google Cloud project

## Links

- [GitHub](https://github.com/Mirrowel/LLM-API-Key-Proxy)
- [Releases](https://github.com/Mirrowel/LLM-API-Key-Proxy/releases)
