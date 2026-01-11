---
name: "@howaboua/pickle-thinker"
description: Enable thinking mode for GLM-4.6 / Big Pickle via Ultrathink injection
---

# @howaboua/pickle-thinker

**Package:** `@howaboua/pickle-thinker`
**Author:** howaboua
**Latest Version:** 0.4.0

## Purpose

Reliably injects the magic keyword `Ultrathink` so GLM-4.6 / Big Pickle models consistently enter "thinking mode".

## Features

- Forces `Ultrathink` as first token in every user message
- Injects synthetic "continue + ultrathink" after tool results
- Appends `Ultrathink` block to tool outputs as safety net
- Re-injects on session compaction (when conversations are summarized)
- Two modes: `lite` (prefix only) or `tool` (redundant injection - recommended)

## Installation

```jsonc
{
  "plugin": ["@howaboua/pickle-thinker@0.4.0"]
}
```

## Configuration

**Config file locations:**
- Global: `~/.config/opencode/pickle-thinker.jsonc` (auto-created)
- Project: `.opencode/pickle-thinker.jsonc`

### Example Config

```jsonc
{
  "mode": "tool",  // "lite" or "tool" (default: tool)
  "prefix": "Ultrathink"  // Can customize but Ultrathink required for GLM-4.6
}
```

## How It Works

Only activates for target models (GLM-4.6 + Big Pickle):

1. **User messages:** Forced to start with `Ultrathink` as dedicated leading text part
2. **After tool results:** Synthetic user "continue + ultrathink" message injected
3. **Tool outputs/errors:** Appended with `Ultrathink` block as extra safety
4. **Session compaction:** Re-injects instructions to maintain thinking mode

Duplication is intentional - missing `Ultrathink` is the bug.

## Caveats

- Only activates for GLM-4.6 and Big Pickle models
- `tool` mode increases turns/tokens (may affect subscription usage)
- `Ultrathink` keyword required - custom prefix still ensures it's first

## Acknowledgments

Based on the Dynamic Context Pruning plugin architecture by Dan Tarquinen.

## Links

- [npm](https://www.npmjs.com/package/@howaboua/pickle-thinker)
