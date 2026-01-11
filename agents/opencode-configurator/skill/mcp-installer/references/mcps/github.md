---
name: github
url: https://github.com/modelcontextprotocol/servers
type: local
auth: api-key
description: GitHub API access
tags: [github, git, api-key]
---

# GitHub MCP

Full GitHub API access.

⚠️ **High context usage** - use per-agent config.

## Installation

```jsonc
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "environment": {
        "GITHUB_TOKEN": "{env:GITHUB_TOKEN}"
      }
    }
  }
}
```

## Setup

1. Create token at https://github.com/settings/tokens
2. Set `GITHUB_TOKEN` environment variable

## Usage

"List open PRs using github"

## Context Management

Disable globally, enable per-agent:

```jsonc
{
  "tools": {
    "github": false
  },
  "agent": {
    "github-agent": {
      "tools": {
        "github": true
      }
    }
  }
}
```

## Links

- [GitHub](https://github.com/modelcontextprotocol/servers)
