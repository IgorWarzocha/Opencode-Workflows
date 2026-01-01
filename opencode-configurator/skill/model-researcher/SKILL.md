---
name: model-researcher
description: |
  Research and configure new/custom AI models not yet in models.dev. Use when user mentions a new model release, asks to add a model from a non-standard provider, or wants to configure a custom/self-hosted model. Triggers: "new model", "just released", "configure [model name]", "add [provider] model", "set up [model]", custom endpoints, self-hosted models, bleeding-edge releases.
---

# Model Researcher

Add new or custom AI models to opencode.json with verified specifications.

<when_to_use>

- Model is too new for models.dev
- Non-standard or custom provider (self-hosted, proxy, enterprise)
- User heard about a new release and wants to use it immediately
- Model exists but with non-default configuration needs

</when_to_use>

<critical_rule>

## Verify Before Configure

**MUST NOT hallucinate model specifications.** Models have precise identifiers, context limits, and API requirements. A wrong value means broken requests or wasted tokens.

Before ANY configuration:
1. Confirm the model actually exists
2. Find the exact model identifier (API name, not marketing name)
3. Get verified context and output token limits
4. Identify required provider configuration

</critical_rule>

<workflow>

## Step 1: Clarify What the User Wants

Ask if unclear:
- "Which provider will you access this through?" (direct API, OpenRouter, Together, self-hosted, etc.)
- "Do you have API access already, or do you need setup help?"

## Step 2: Research the Model

Use web search to find authoritative sources:

```
websearch("${MODEL_NAME} API context limit tokens official documentation")
websearch("${MODEL_NAME} model ID API identifier ${PROVIDER}")
```

**Priority sources (most to least trustworthy):**
1. Official provider documentation/blog posts
2. Provider's API reference or changelog
3. Official GitHub repos or release notes
4. OpenRouter/Together model pages (they list specs)
5. Reputable tech news (for very new announcements)

**Red flags - search more if you only find:**
- Reddit speculation
- Tweets without official confirmation
- Your own training data (MAY be outdated)

## Step 3: Confirm Findings with User

Before touching config, MUST present your research:

```
I found the following for [MODEL]:

Provider: [e.g., OpenAI, Anthropic, custom]
Model ID: [exact API identifier, e.g., "gpt-5.1-turbo-2025-06"]
Context limit: [e.g., 200000 tokens]
Output limit: [e.g., 32768 tokens]
Special options: [e.g., reasoning modes, vision support]

Source: [URL]

Does this match what you expected? Should I add this to your config?
```

**MUST NOT proceed without user confirmation.**

## Step 4: Apply Configuration

Read the current config first:
```
read ~/.config/opencode/opencode.json
```

Then apply using surgical edits. Choose the right pattern:

### Pattern A: Built-in Provider, New Model

For new models on existing providers (OpenAI, Anthropic, etc.):

```jsonc
{
  "provider": {
    "openai": {
      "models": {
        "gpt-5.3-turbo-2025-07": {
          "name": "GPT-5.3 Turbo (July 2025)",
          "limit": {
            "context": 256000,
            "output": 65536
          }
        }
      }
    }
  }
}
```

### Pattern B: Custom Provider (OpenAI-compatible)

For self-hosted, proxy, or unlisted providers:

```jsonc
{
  "provider": {
    "my-provider": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "My Provider Display Name",
      "options": {
        "baseURL": "https://api.example.com/v1"
      },
      "models": {
        "model-id": {
          "name": "Model Display Name",
          "limit": {
            "context": 128000,
            "output": 16384
          }
        }
      }
    }
  }
}
```

### Pattern C: Model Variant with Custom Options

For models that need specific options (reasoning, thinking budget, etc.):

```jsonc
{
  "provider": {
    "anthropic": {
      "models": {
        "claude-5-sonnet-thinking": {
          "id": "claude-5-sonnet-20250801",
          "name": "Claude 5 Sonnet (Extended Thinking)",
          "options": {
            "thinking": {
              "type": "enabled",
              "budgetTokens": 32000
            }
          }
        }
      }
    }
  }
}
```

## Step 5: Validate

After editing, remind user to test:

```
Config updated. To verify it works:
1. Restart OpenCode or run: opencode
2. Run /models and select [model name]
3. Send a test message

If you see errors, check:
- API key is set (run /connect if needed)
- Model ID matches provider's documentation exactly
- Context limits aren't higher than the model actually supports
```

</workflow>

<research_queries>

| Scenario | Search Query |
|----------|--------------|
| New OpenAI model | `"gpt-5.3" site:openai.com OR site:platform.openai.com` |
| New Anthropic model | `"claude-4" site:anthropic.com API` |
| New Google model | `"gemini 3" site:ai.google.dev context window` |
| OpenRouter availability | `"${MODEL}" site:openrouter.ai` |
| Together AI availability | `"${MODEL}" site:together.ai` |
| Self-hosted specs | `"${MODEL}" context length output tokens huggingface` |

</research_queries>

<spec_checklist>

Before configuring, ensure you have:

- [ ] **Model ID**: Exact API identifier (not marketing name)
- [ ] **Context limit**: Maximum input tokens
- [ ] **Output limit**: Maximum output/completion tokens
- [ ] **Provider**: Which service hosts it
- [ ] **Base URL**: For custom providers only
- [ ] **Special options**: Vision, reasoning modes, thinking budgets
- [ ] **Availability**: Is it actually accessible (not waitlist-only)?

</spec_checklist>

<handling_uncertainty>

If you cannot verify specifications:

1. **Be honest**: "I couldn't find official documentation for the exact context limit."
2. **Provide best guess with source**: "Based on [source], it appears to be 128k, but this isn't confirmed."
3. **Suggest conservative defaults**: "I'll configure with 100k context as a safe starting point. You can increase it once you confirm the actual limit."
4. **Recommend checking**: "Try the provider's /models endpoint or documentation for exact specs."

</handling_uncertainty>

## References

- `references/provider-patterns.md` - Common provider configuration examples
