---
name: context7
url: https://mcp.context7.com
type: remote
auth: api-key
description: AI-powered documentation search
tags: [docs, search]
---

# Context7

Search documentation with AI-powered semantic search.

## Installation

```jsonc
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"
      }
    }
  }
}
```

## Setup

1. Sign up at https://context7.com
2. Get API key from dashboard
3. Set `CONTEXT7_API_KEY` environment variable

## Usage

"Search Cloudflare Workers docs using context7"

## Links

- [Website](https://context7.com)
