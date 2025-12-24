---
name: "@franlol/opencode-md-table-formatter"
description: Auto-format markdown tables with concealment mode support
---

# @franlol/opencode-md-table-formatter

**Package:** `@franlol/opencode-md-table-formatter`
**Author:** franlol
**Latest Version:** 0.0.3

## Purpose

Automatically formats markdown tables in AI responses. Correctly calculates column widths when markdown concealment mode is enabled.

## Features

- Automatic table formatting after AI text completion
- Concealment mode compatible (correct widths when markdown symbols hidden)
- Alignment support: left (`:---`), center (`:---:`), right (`---:`)
- Nested markdown handling with multi-pass algorithm
- Code block preservation (`` `**bold**` `` shows literal)
- Handles emojis, unicode, empty cells, long content
- Silent operation - no console logs, errors don't interrupt
- Validation feedback for invalid tables

## Installation

```jsonc
{
  "plugin": ["@franlol/opencode-md-table-formatter@latest"]
}
```

## Example

**Input (unformatted):**
```
| Feature | Description | Status |
|---|---|
| **Bold text** | Has *italic* content | ✅ Done |
| `Code` | With `**bold**` inside | ⏳ Progress |
```

**Output (formatted):**
```
| Feature       | Description            | Status      |
| ------------- | ---------------------- | ----------- |
| **Bold text** | Has *italic* content   | ✅ Done     |
| `Code`        | With `**bold**` inside | ⏳ Progress |
```

## How It Works

Uses OpenCode's `experimental.text.complete` hook to format tables after AI finishes generating text. Strips markdown symbols for width calculation while preserving symbols inside inline code blocks.

## Troubleshooting

**Tables not formatting?**
- Ensure plugin is in config
- Restart OpenCode
- Tables must have separator row (`|---|---|`)

**Invalid table structure comment?**
- All rows must have same number of columns
- Tables need at least 2 rows including separator

## Caveats

- Only works with concealment mode enabled (OpenCode default)
- Requires Node.js >= 18.0.0 or Bun runtime

## Links

- [npm](https://www.npmjs.com/package/@franlol/opencode-md-table-formatter)
- [GitHub](https://github.com/franlol/opencode-md-table-formatter)
