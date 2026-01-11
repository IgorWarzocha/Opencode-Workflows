---
name: slack
url: https://docs.slack.dev/ai/mcp-server
type: remote
auth: oauth
description: Slack workspace integration (limited rollout)
tags: [slack, communication, oauth]
---

# Slack MCP

Official Slack server for workspace access.

⚠️ **Limited availability** - Currently in partner rollout only.

## Installation

```jsonc
{
  "mcp": {
    "slack": {
      "type": "remote",
      "url": "https://slack-mcp.slack.dev",
      "oauth": {}
    }
  }
}
```

## Setup

```bash
opencode mcp auth slack
```

Requires Slack partner approval for access.

## Usage

"Search Slack messages using slack MCP"

"Send a message to a channel with slack"

## Features

- Search messages and files
- Send messages to channels
- Read channels and threads
- Manage canvases
- Fetch user profiles

## Links

- [Docs](https://docs.slack.dev/ai/mcp-server)
