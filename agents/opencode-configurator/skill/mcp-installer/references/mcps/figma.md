---
name: figma
url: https://help.figma.com/hc/en-us/articles/32132100833559
type: remote
auth: oauth
description: Design-to-code workflow and design context
tags: [figma, design, oauth]
---

# Figma MCP

Official Figma server for design-to-code workflows.

## Installation

**Remote:**
```jsonc
{
  "mcp": {
    "figma": {
      "type": "remote",
      "url": "https://mcp.figma.com/mcp",
      "oauth": {}
    }
  }
}
```

**Desktop (local):**
Runs at `http://127.0.0.1:3845/mcp` when enabled in Figma desktop app.

## Setup

### Remote
```bash
opencode mcp auth figma
```

### Desktop
1. Open Figma desktop app
2. Enable Dev Mode (Shift+D)
3. In MCP server section, click "Enable desktop MCP server"

## Usage

"Generate code from my Figma selection using figma MCP"

"Extract design tokens and variables with figma"

## Features

- Generate code from selected frames
- Extract design context (variables, components, layout)
- Retrieve FigJam and Make resources
- Code Connect integration

## Links

- [Docs](https://help.figma.com/hc/en-us/articles/32132100833559)
- [Developer docs](https://developers.figma.com/docs/figma-mcp-server)
