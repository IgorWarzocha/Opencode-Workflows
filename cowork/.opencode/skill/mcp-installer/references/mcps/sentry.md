---
name: sentry
url: https://mcp.sentry.dev
type: remote
auth: oauth
description: Sentry error tracking and issues
tags: [monitoring, errors, oauth]
---

# Sentry

Interact with Sentry projects and issues.

## Installation

```jsonc
{
  "mcp": {
    "sentry": {
      "type": "remote",
      "url": "https://mcp.sentry.dev/mcp",
      "oauth": {}
    }
  }
}
```

## Setup

```bash
opencode mcp auth sentry
```

Opens browser for OAuth authorization.

## Usage

"Show latest unresolved issues using sentry"

## Links

- [Docs](https://mcp.sentry.dev)
