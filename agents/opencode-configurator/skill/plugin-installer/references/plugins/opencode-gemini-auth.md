---
name: opencode-gemini-auth
description: Google OAuth for Gemini models - use free tier or paid plan quotas
---

# opencode-gemini-auth

**Package:** `opencode-gemini-auth`
**Author:** jenslys
**Latest Version:** Check npm

## Purpose

Authenticate with your Google account to use Gemini models via OAuth. Use your existing Gemini plan and quotas (including free tier) without separate API billing.

## Features

- OAuth with Google account
- Use existing Gemini quotas (free tier included)
- Thinking config support:
  - `thinkingLevel` (low/high) for Gemini 3
  - `thinkingBudget` (token count) for Gemini 2.5
- Zero-config Google Cloud project discovery
- Auto-provisions suitable GCP project

## Installation

```jsonc
{
  "plugin": ["opencode-gemini-auth@latest"]
}
```

## Setup

1. Add plugin to config
2. Restart OpenCode
3. Run `opencode auth login`
4. Select "Google" → "OAuth with Google (Gemini CLI)"
5. Complete browser authentication

## Configuration

### Specify Project ID

```jsonc
{
  "provider": {
    "google": {
      "options": {
        "projectId": "your-specific-project-id"
      }
    }
  }
}
```

### Gemini 3 Thinking (thinkingLevel)

```jsonc
{
  "provider": {
    "google": {
      "models": {
        "gemini-3-pro-preview": {
          "options": {
            "thinkingConfig": {
              "thinkingLevel": "high",
              "includeThoughts": true
            }
          }
        }
      }
    }
  }
}
```

### Gemini 2.5 Thinking (thinkingBudget)

```jsonc
{
  "provider": {
    "google": {
      "models": {
        "gemini-2.5-flash": {
          "options": {
            "thinkingConfig": {
              "thinkingBudget": 8192,
              "includeThoughts": true
            }
          }
        }
      }
    }
  }
}
```

## Troubleshooting

### Manual Google Cloud Setup

If auto-provisioning fails:
1. Go to Google Cloud Console
2. Create or select a project
3. Enable **Gemini for Google Cloud API** (`cloudaicompanion.googleapis.com`)
4. Set `projectId` in config

### Debug Mode

```bash
OPENCODE_GEMINI_DEBUG=1 opencode
```

Generates `gemini-debug-<timestamp>.log` files.

## Updating

```bash
rm -rf ~/.cache/opencode/node_modules/opencode-gemini-auth
opencode
```

## Links

- [npm](https://www.npmjs.com/package/opencode-gemini-auth)
- [GitHub](https://github.com/jenslys/opencode-gemini-auth)
