---
name: brave-search
url: https://github.com/modelcontextprotocol/servers
type: local
auth: api-key
description: Web search using Brave Search API
tags: [search, web, api-key]
---

# Brave Search MCP

Web and local search using Brave Search API.

## Installation

```jsonc
{
  "mcp": {
    "brave-search": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-brave-search"],
      "environment": {
        "BRAVE_API_KEY": "{env:BRAVE_API_KEY}"
      }
    }
  }
}
```

## Setup

1. Get API key from https://search.brave.com/api
2. Set `BRAVE_API_KEY` environment variable

Free tier: 2,000 queries/month

## Usage

"Search for latest TypeScript 5.0 features using brave-search"

"Find tutorials about React hooks with brave-search"

## Links

- [GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/brave-search)
