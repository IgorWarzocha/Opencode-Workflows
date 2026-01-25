---
name: linear
url: https://github.com/cosmix/linear-mcp
type: local
auth: api-key
description: Linear issue tracking (archived)
tags: [linear, issues, project-management, api-key]
---

# Linear MCP

Linear issue tracking integration.

⚠️ **Archived** - This project is archived and read-only as of July 2025.

## Installation

```jsonc
{
  "mcp": {
    "linear": {
      "type": "local",
      "command": ["node", "/path/to/linear-mcp/build/index.js"],
      "environment": {
        "LINEAR_API_KEY": "{env:LINEAR_API_KEY}"
      }
    }
  }
}
```

## Setup

1. Get Linear API key
2. Build from source: `bun install && bun run build`
3. Set `LINEAR_API_KEY` environment variable

## Usage

"Create a Linear issue using linear MCP"

"Search Linear issues with linear"

## Links

- [GitHub](https://github.com/cosmix/linear-mcp) (archived)
