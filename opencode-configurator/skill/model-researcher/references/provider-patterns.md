# Provider Configuration Patterns

Quick reference for common provider setups.

<builtin_providers>

These providers are pre-configured in OpenCode. Just add the model.

## OpenAI

```jsonc
{
  "provider": {
    "openai": {
      "models": {
        "gpt-5.3-turbo": {
          "name": "GPT-5.3 Turbo",
          "limit": { "context": 256000, "output": 65536 }
        }
      }
    }
  }
}
```

## Anthropic

```jsonc
{
  "provider": {
    "anthropic": {
      "models": {
        "claude-5-opus-20250901": {
          "name": "Claude 5 Opus",
          "limit": { "context": 400000, "output": 32768 }
        }
      }
    }
  }
}
```

## Google (Generative AI)

```jsonc
{
  "provider": {
    "google": {
      "models": {
        "gemini-3-ultra": {
          "name": "Gemini 3 Ultra",
          "limit": { "context": 2000000, "output": 65536 }
        }
      }
    }
  }
}
```

## xAI

```jsonc
{
  "provider": {
    "xai": {
      "models": {
        "grok-3.5": {
          "name": "Grok 3.5",
          "limit": { "context": 131072, "output": 32768 }
        }
      }
    }
  }
}
```

## DeepSeek

```jsonc
{
  "provider": {
    "deepseek": {
      "models": {
        "deepseek-r2": {
          "name": "DeepSeek R2",
          "limit": { "context": 128000, "output": 32768 }
        }
      }
    }
  }
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
        "anthropic/claude-5-opus": {
          "name": "Claude 5 Opus (via OpenRouter)"
        },
        "meta/llama-4-maverick": {
          "name": "Llama 4 Maverick"
        }
      }
    }
  }
}
```

With provider routing:

```jsonc
{
  "provider": {
    "openrouter": {
      "models": {
        "moonshotai/kimi-k3": {
          "name": "Kimi K3",
          "options": {
            "provider": {
              "order": ["fireworks", "together"],
              "allow_fallbacks": true
            }
          }
        }
      }
    }
  }
}
```

## Together AI

```jsonc
{
  "provider": {
    "together": {
      "models": {
        "meta-llama/Llama-4-Maverick-17Bx128E-Instruct-Turbo": {
          "name": "Llama 4 Maverick",
          "limit": { "context": 524288, "output": 32768 }
        }
      }
    }
  }
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
        "baseURL": "http://localhost:8080/v1"
      },
      "models": {
        "my-model": {
          "name": "My Custom Model",
          "limit": { "context": 32000, "output": 4096 }
        }
      }
    }
  }
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
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "llama3.3:70b": {
          "name": "Llama 3.3 70B",
          "limit": { "context": 128000, "output": 8192 }
        }
      }
    }
  }
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
        "baseURL": "http://127.0.0.1:1234/v1"
      },
      "models": {
        "loaded-model": {
          "name": "Currently Loaded Model"
        }
      }
    }
  }
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
        "baseURL": "http://localhost:8000/v1"
      },
      "models": {
        "NousResearch/Hermes-3-Llama-3.1-70B": {
          "name": "Hermes 3 70B",
          "limit": { "context": 131072, "output": 16384 }
        }
      }
    }
  }
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
        "gpt-5": {
          "name": "GPT-5 (Azure)"
        }
      }
    }
  }
}
```

Note: Requires `AZURE_RESOURCE_NAME` env var and model deployment matching model name.

## Cloudflare AI Gateway

```jsonc
{
  "provider": {
    "cloudflare-ai-gateway": {
      "models": {
        "openai/gpt-5.3": {},
        "anthropic/claude-5-sonnet": {}
      }
    }
  }
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
          "X-Team-ID": "engineering"
        }
      },
      "models": {
        "gpt-5": { "name": "GPT-5 (via proxy)" }
      }
    }
  }
}
```

</enterprise_setups>

<model_options>

## Reasoning / Thinking Modes

OpenAI reasoning models:

```jsonc
{
  "options": {
    "reasoningEffort": "high",      // "low" | "medium" | "high"
    "textVerbosity": "low",
    "reasoningSummary": "auto"
  }
}
```

Anthropic extended thinking:

```jsonc
{
  "options": {
    "thinking": {
      "type": "enabled",
      "budgetTokens": 32000
    }
  }
}
```

## Custom Variants

Create named variants of the same model:

```jsonc
{
  "provider": {
    "openai": {
      "models": {
        "o3-high": {
          "id": "o3",
          "name": "O3 (High Effort)",
          "options": { "reasoningEffort": "high" }
        },
        "o3-low": {
          "id": "o3",
          "name": "O3 (Low Effort)", 
          "options": { "reasoningEffort": "low" }
        }
      }
    }
  }
}
```

</model_options>

<token_limits>

Common context window sizes:

| Size | Tokens | Notes |
|------|--------|-------|
| Standard | 8,192 | Older models |
| Extended | 32,768 | GPT-4 original |
| Large | 128,000 | Claude 3, GPT-4 Turbo |
| XL | 200,000 | Claude 3.5/4 |
| XXL | 1,000,000+ | Gemini 1.5/2 Pro |

MUST verify actual limits from official docs - these change frequently.

</token_limits>
