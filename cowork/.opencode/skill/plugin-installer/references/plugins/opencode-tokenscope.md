---
name: "@ramtinj95/opencode-tokenscope"
description: Token usage analytics, cost tracking, and cache efficiency reports
---

# @ramtinj95/opencode-tokenscope

**Package:** `@ramtinj95/opencode-tokenscope`
**Author:** ramtinJ95
**Latest Version:** Check npm

## Purpose

Comprehensive token usage analysis and cost tracking for OpenCode sessions. Track and optimize token usage across system prompts, user messages, tool outputs, and more.

## Features

- Token breakdown by category (system, user, tools, assistant)
- Tool usage breakdown with call counts and percentages
- Top token contributors identification
- Cache efficiency analysis (hit rate, cost savings)
- Cost estimation with model-specific pricing
- Subagent (Task tool) cost tracking across child sessions
- Context breakdown (system prompt, tool definitions, project tree)
- Visual ASCII charts

## Installation

```jsonc
{
  "plugin": ["@ramtinj95/opencode-tokenscope@latest"]
}
```

## Usage

Adds a `tokenscope` tool that can be called by the AI or requested by user.

**Example output:**
```
═══════════════════════════════════════════════════════════════
Token Analysis: Session ses_abc123
Model: claude-opus-4-5
═══════════════════════════════════════════════════════════════

TOKEN BREAKDOWN BY CATEGORY
───────────────────────────────────────────────────────────────
Input Categories:
  SYSTEM    ██████████████░░░░░░░░░░░░░░░░    45.8% (22,367)
  USER      ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░        0.8% (375)
  TOOLS     ████████████████░░░░░░░░░░░░░░    53.5% (26,146)

CACHE EFFICIENCY
───────────────────────────────────────────────────────────────
  Cache Hit Rate:      86.2%
  Cost Savings:        $1.44  (77.6% reduction)

SUBAGENT COSTS (4 child sessions, 23 API calls)
───────────────────────────────────────────────────────────────
  Subagent Total:      $1.39  (566,474 tokens)

TOTAL:                 $1.96  (942,160 tokens, 38 calls)
```

## Configuration

Optional config to hide sections:

```jsonc
{
  "showBreakdown": true,
  "showToolUsage": true,
  "showCacheEfficiency": true,
  "showSubagents": true,
  "showCost": true
}
```

## Updating

```bash
opencode --update
```

The `--update` flag skips dependency installation for faster updates.

## Caveats

- Token counts are estimated using tokenizer analysis
- Cost estimates use standard API pricing from models.json
- Free/open models marked with zero pricing

## Links

- [npm](https://www.npmjs.com/package/@ramtinj95/opencode-tokenscope)
- [GitHub](https://github.com/ramtinJ95/opencode-tokenscope)
