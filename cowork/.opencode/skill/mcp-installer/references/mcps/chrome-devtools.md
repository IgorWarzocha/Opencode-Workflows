---
name: chrome-devtools
url: https://github.com/ChromeDevTools/chrome-devtools-mcp
type: local
auth: none
description: Chrome DevTools with performance tracing
tags: [chrome, devtools, debugging, performance]
---

# Chrome DevTools MCP

Official Chrome DevTools server for debugging, performance analysis, and automation.

## Installation

```jsonc
{
  "mcp": {
    "chrome-devtools": {
      "type": "local",
      "command": ["npx", "-y", "chrome-devtools-mcp@latest"]
    }
  }
}
```

## Setup

No authentication required. Chrome installs on first use.

## Usage

"Check the performance of https://example.com using chrome-devtools"

"Debug network requests and console errors with chrome-devtools"

## Options

```jsonc
{
  "command": [
    "npx",
    "-y",
    "chrome-devtools-mcp@latest",
    "--headless",
    "--channel=canary"
  ]
}
```

## Links

- [GitHub](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- [npm](https://www.npmjs.com/package/chrome-devtools-mcp)
