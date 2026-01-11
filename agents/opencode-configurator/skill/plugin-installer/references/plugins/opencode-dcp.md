---
name: "@tarquinen/opencode-dcp"
description: Dynamic Context Pruning - reduce tokens by removing obsolete tool outputs
---

# @tarquinen/opencode-dcp

**Package:** `@tarquinen/opencode-dcp`
**Author:** Dan Tarquinen
**Latest Version:** 1.0.4

## Purpose

Dynamic Context Pruning - automatically reduces token usage by removing obsolete tool outputs from conversation history.

## Features

- **Deduplication:** Identifies repeated tool calls, keeps only most recent output (zero LLM cost)
- **Supersede Writes:** Prunes write tool inputs for files that were later read (zero LLM cost)
- **Prune Tool:** AI can manually trigger pruning when needed
- **On Idle Analysis:** LLM analyzes context during idle periods to find irrelevant outputs

Session history is never modified - pruned outputs replaced with placeholder before sending to LLM.

## Installation

```jsonc
{
  "plugin": ["@tarquinen/opencode-dcp@latest"]
}
```

## Configuration

**Config file locations:**
- Global: `~/.config/opencode/dcp.jsonc` (auto-created on first run)
- Custom: `$OPENCODE_CONFIG_DIR/dcp.jsonc`
- Project: `.opencode/dcp.jsonc`

**Precedence:** Defaults → Global → Config Dir → Project

### Example Config

```jsonc
{
  "deduplication": {
    "enabled": true,
    "protectedTools": []
  },
  "supersedeWrites": {
    "enabled": true
  },
  "pruneTool": {
    "enabled": true
  },
  "onIdleAnalysis": {
    "enabled": false,
    "idleThresholdMs": 30000
  }
}
```

## Protected Tools

These tools are always protected from pruning:
- `task`
- `todowrite`
- `todoread`
- `prune`
- `batch`

Add more via `protectedTools` arrays in each strategy.

## Trade-offs

**Prompt Caching Impact:**
Pruning changes message content, which invalidates cached prefixes. You lose some cache read benefits but gain larger token savings from reduced context size.

In most cases, token savings outweigh cache miss cost - especially in long sessions.

## Caveats

- Restart OpenCode after config changes
- Does not modify actual session history
- On Idle Analysis uses LLM calls (has cost)

## Links

- [npm](https://www.npmjs.com/package/@tarquinen/opencode-dcp)
- [GitHub](https://github.com/Tarquinen/opencode-dynamic-context-pruning)
