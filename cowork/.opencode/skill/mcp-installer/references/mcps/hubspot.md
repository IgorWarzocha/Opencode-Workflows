---
name: hubspot
url: https://developers.hubspot.com/mcp
type: remote
auth: oauth
description: HubSpot CRM integration (beta)
tags: [hubspot, crm, oauth]
---

# HubSpot MCP

Official HubSpot server for CRM data access.

⚠️ **Beta** - Public beta, subject to beta terms.

## Installation

```jsonc
{
  "mcp": {
    "hubspot": {
      "type": "remote",
      "url": "https://api.hubspot.com/mcp",
      "oauth": {}
    }
  }
}
```

## Setup

```bash
opencode mcp auth hubspot
```

Requires HubSpot app with MCP server enabled.

## Usage

"Query HubSpot CRM data using hubspot MCP"

"Create a contact in HubSpot with hubspot"

## Features

- Access CRM data (contacts, deals, companies)
- Object metadata retrieval
- CRUD operations on records
- Integration with Smart CRM

## Links

- [Docs](https://developers.hubspot.com/mcp)
- [Integration guide](https://developers.hubspot.com/docs/apps/developer-platform/build-apps/integrate-with-hubspot-mcp-server)
