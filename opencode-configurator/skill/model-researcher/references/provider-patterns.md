# Provider Configuration Patterns (Q4 2025 Verified)

<instructions>
This document lists the ONLY verified configuration patterns for the current frontier model market. You MUST NOT deviate from these patterns unless authorized by deep research and user confirmation.
</instructions>

<builtin_providers>

These providers are pre-configured in OpenCode. Just add the model.

## OpenAI

GPT-5.2 is the primary model family.

### Direct API Patterns

```jsonc
{
  "provider": {
    "openai": {
      "whitelist": ["gpt-5.2", "gpt-5.2-codex"],
      "models": {
        "gpt-5.2": {
          "limit": { "context": 400000, "output": 128000 },
        },
        "gpt-5.2-codex": {
          "limit": { "context": 400000, "output": 128000 },
        },
      },
    },
  },
}
```

### OAuth Plugin Patterns

Models configured via OAuth plugins (e.g., `opencode-openai-codex-auth`) often have different enforced limits and settings.

```jsonc
{
  "provider": {
    "openai": {
      "whitelist": ["gpt-5.2", "gpt-5.2-codex"],
      "models": {
        "gpt-5.2": {
          "name": "GPT 5.2 (OAuth)",
          "limit": { "context": 272000, "output": 128000 },
        },
        "gpt-5.2-codex": {
          "name": "GPT 5.2 Codex (OAuth)",
          "limit": { "context": 272000, "output": 128000 },
        },
      },
    },
  },
}
```

## Anthropic

Claude 4.5 family is the current standard. You MUST NOT use Claude 3.5.

```jsonc
{
  "provider": {
    "anthropic": {
      "models": {
        "claude-4-5-opus": {
          "id": "claude-4-5-opus-20251124",
          "limit": { "context": 200000, "output": 64000 },
        },
        "claude-4-5-sonnet": {
          "id": "claude-4-5-sonnet-20250929",
          "limit": { "context": 200000, "output": 64000 },
        },
      },
    },
  },
}
```

## Google (Generative AI)

Gemini 3 family is the current standard. You MUST NOT use Gemini 1.5 or 2.

```jsonc
{
  "provider": {
    "google": {
      "models": {
        "gemini-3-pro": {
          "limit": { "context": 1048576, "output": 64000 },
        },
        "gemini-3-flash": {
          "limit": { "context": 1048576, "output": 64000 },
        },
      },
    },
  },
}
```

## xAI

```jsonc
{
  "provider": {
    "xai": {
      "models": {
        "grok-4.1": {
          "limit": { "context": 256000, "output": 64000 },
        },
      },
    },
  },
}
```

## DeepSeek

```jsonc
{
  "provider": {
    "deepseek": {
      "models": {
        "deepseek-v3.2": {
          "name": "DeepSeek V3.2",
          "limit": { "context": 128000, "output": 32768 }
        },
        "deepseek-v3.2-speciale": {
          "name": "DeepSeek V3.2 Speciale",
          "limit": { "context": 128000, "output": 32768 }
        }
      }
    },
    "zhipu": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.z.ai/api/paas/v4" },
      "models": {
        "glm-4.7": {
          "limit": { "context": 200000, "output": 128000 }
        },
        "glm-4.6v": {
          "limit": { "context": 128000, "output": 128000 }
        }
      }
    },
    "moonshot": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.moonshot.cn/v1" },
      "models": {
        "kimi-k2-thinking": {
          "limit": { "context": 256000, "output": 64000 }
        },
        "kimi-k2-instruct": {
          "limit": { "context": 256000, "output": 64000 }
        }
      }
    },
    "minimax": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.minimax.chat/v1" },
      "models": {
        "minimax-m2.1": {
          "limit": { "context": 204800, "output": 128000 }
        },
        "minimax-m2": {
          "limit": { "context": 196608, "output": 65536 }
        }
      }
    }

        "deepseek-v3.2-speciale": {
          "name": "DeepSeek V3.2 Speciale",
          "limit": { "context": 128000, "output": 32768 }
        }
      }
    },
    "zhipu": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.z.ai/api/anthropic/v1" },
      "models": {
        "glm-4.7": {
          "limit": { "context": 200000, "output": 128000 }
        },
        "glm-4.6v": {
          "limit": { "context": 128000, "output": 128000 }
        }
      }
    },
    "moonshot": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.moonshot.cn/v1" },
      "models": {
        "kimi-k2-thinking": {
          "limit": { "context": 256000, "output": 64000 }
        },
        "kimi-k2-instruct": {
          "limit": { "context": 256000, "output": 64000 }
        }
      }
    },
    "minimax": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.minimax.chat/v1" },
      "models": {
        "minimax-m2.1": {
          "limit": { "context": 204800, "output": 128000 }
        },
        "minimax-m2": {
          "limit": { "context": 196608, "output": 65536 }
        }
      }
    }
    "zhipu": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.z.ai/api/anthropic/v1" },
      "models": {
        "glm-4.7": {
          "limit": { "context": 200000, "output": 128000 },
        },
        "glm-4.6v": {
          "limit": { "context": 128000, "output": 128000 },
        },
      },
    },
    "moonshot": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.moonshot.cn/v1" },
      "models": {
        "kimi-k2-thinking": {
          "limit": { "context": 256000, "output": 64000 },
        },
        "kimi-k2-instruct": {
          "limit": { "context": 256000, "output": 64000 },
        },
      },
    },
    "minimax": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "https://api.minimax.chat/v1" },
      "models": {
        "minimax-m2.1": {
          "limit": { "context": 204800, "output": 128000 },
        },
        "minimax-m2": {
          "limit": { "context": 196608, "output": 65536 },
        },
      },
    },
  },
}
```

</builtin_providers>

<aggregator_providers>

Route through model aggregators for access to many models.

## OpenRouter

```jsonc
{
  "provider": {
    "openrouter": {
      "models": {
        "anthropic/claude-4-5-opus": {
          "name": "Claude 4.5 Opus (via OpenRouter)",
        },
        "openai/gpt-5.2": {
          "name": "GPT-5.2",
        },
        "moonshotai/kimi-k2-thinking": {
          "name": "Kimi K2 Thinking",
        },
      },
    },
  },
}
```

With provider routing:

```jsonc
{
  "provider": {
    "openrouter": {
      "models": {
        "moonshotai/kimi-k2-thinking": {
          "name": "Kimi K2 Thinking",
        },
      },
    },
  },
}
```

## Together AI

```jsonc
{
  "provider": {
    "together": {
      "models": {
        "deepseek-ai/DeepSeek-V3.2": {
          "name": "DeepSeek V3.2",
          "limit": { "context": 128000, "output": 32768 },
        },
        "mistralai/Mistral-Large-3-2512": {
          "name": "Mistral Large 3 (2512)",
          "limit": { "context": 262144, "output": 65536 },
        },
      },
    },
  },
}
```

</aggregator_providers>

<custom_providers>

## Generic OpenAI-Compatible

```jsonc
{
  "provider": {
    "my-server": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "My Local Server",
      "options": {
        "baseURL": "http://localhost:8080/v1",
      },
      "models": {
        "my-model": {
          "name": "My Custom Model",
          "limit": { "context": 32000, "output": 4096 },
        },
      },
    },
  },
}
```

## Ollama (Local)

```jsonc
{
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1",
      },
      "models": {
        "llama3.3:70b": {
          "name": "Llama 3.3 70B",
          "limit": { "context": 128000, "output": 8192 },
        },
      },
    },
  },
}
```

## LM Studio

```jsonc
{
  "provider": {
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio",
      "options": {
        "baseURL": "http://127.0.0.1:1234/v1",
      },
      "models": {
        "loaded-model": {
          "name": "Currently Loaded Model",
        },
      },
    },
  },
}
```

## vLLM Server

```jsonc
{
  "provider": {
    "vllm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "vLLM Server",
      "options": {
        "baseURL": "http://localhost:8000/v1",
      },
      "models": {
        "NousResearch/Hermes-3-Llama-3.1-70B": {
          "name": "Hermes 3 70B",
          "limit": { "context": 131072, "output": 16384 },
        },
      },
    },
  },
}
```

</custom_providers>

<enterprise_setups>

## Azure OpenAI

```jsonc
{
  "provider": {
    "azure": {
      "models": {
        "gpt-5.2": {
          "limit": { "context": 400000, "output": 128000 },
        },
      },
    },
  },
}
```

Note: Requires `AZURE_RESOURCE_NAME` env var and model deployment matching model name.

## Cloudflare AI Gateway

```jsonc
{
  "provider": {
    "cloudflare-ai-gateway": {
      "models": {
        "openai/gpt-5.2": {},
        "anthropic/claude-4-5-sonnet": {},
      },
    },
  },
}
```

Note: Requires `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_GATEWAY_ID` env vars.

## Custom Headers (e.g., auth proxy)

```jsonc
{
  "provider": {
    "corp-proxy": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Corporate Proxy",
      "options": {
        "baseURL": "https://ai-proxy.corp.internal/v1",
        "headers": {
          "X-Corp-Auth": "Bearer ${env:CORP_AI_TOKEN}",
          "X-Team-ID": "engineering",
        },
      },
      "models": {
        "gpt-5.2": { "name": "GPT-5.2 (via proxy)" },
      },
    },
  },
}
```

</enterprise_setups>

<model_options>

## Reasoning / Thinking Modes

Models with reasoning capabilities should be configured via `variants` to allow cycling modes.

### OpenAI Specific Options

- `reasoningEffort`: "minimal" | "low" | "medium" | "high" | "xhigh"
- `reasoningSummary`: "auto" | "detailed"
- `include`: `["reasoning.encrypted_content"]`

### Anthropic Specific Options

- `thinking`: `{ type: "enabled", budgetTokens: number }`

### Google Specific Options

- `includeThoughts`: boolean
- `thinkingLevel`: "low" | "high"

### Native OpenCode Options (OpenAI Compatible)

- `textVerbosity`: "low" | "medium" | "high" (Controls response length)

```jsonc
{
  "variants": {
    "thinking": {
      "reasoningEffort": "high",
      "reasoningSummary": "detailed",
    },
    "instant": {
      "reasoningEffort": "low",
      "textVerbosity": "low",
    },
  },
}
```

Anthropic extended thinking:

```jsonc
{
  "options": {
    "thinking": {
      "type": "enabled",
      "budgetTokens": 32000,
    },
  },
}
```

## Variant Configuration (Cycle with ctrl+t)

You SHOULD define variants to expose model specific capabilities like "Thinking" or "Instant" response modes.

```jsonc
{
  "variants": {
    "thinking": {
      // OpenAI / Azure / Bedrock
      "reasoningEffort": "high",
      "reasoningSummary": "auto",
      // Anthropic
      "thinking": { "type": "enabled", "budgetTokens": 16000 },
      // Google
      "includeThoughts": true,
      "thinkingLevel": "high",
    },

    "instant": {
      "reasoningEffort": "low",
      "textVerbosity": "low", // Native OpenCode field for OpenAI Compatible
    },
  },
}
```

## Token Limits

Common context window sizes:

| Size  | Tokens     | Notes             |
| ----- | ---------- | ----------------- |
| Large | 128,000    | DeepSeek V3.2     |
| XL    | 200,000    | Claude 4.5 family |
| XXL   | 1,000,000+ | Gemini 3 family   |

MUST verify actual limits from official docs - these change frequently.

</token_limits>
