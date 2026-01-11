---
name: playwright
url: https://github.com/microsoft/playwright-mcp
type: local
auth: none
description: Browser automation with Playwright
tags: [browser, automation, testing]
---

# Playwright MCP

Official Microsoft Playwright server for browser automation.

## Installation

```jsonc
{
  "mcp": {
    "playwright": {
      "type": "local",
      "command": ["npx", "@playwright/mcp@latest"]
    }
  }
}
```

## Setup

No authentication required. Browser installs on first use.

## Usage

"Navigate to example.com and take a screenshot using playwright"

"Fill out the login form with playwright"

## Options

```jsonc
{
  "command": [
    "npx",
    "@playwright/mcp@latest",
    "--headless",
    "--browser", "firefox"
  ]
}
```

## Links

- [GitHub](https://github.com/microsoft/playwright-mcp)
- [npm](https://www.npmjs.com/package/@playwright/mcp)
