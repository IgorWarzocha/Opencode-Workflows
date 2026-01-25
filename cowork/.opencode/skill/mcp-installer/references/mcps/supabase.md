---
name: supabase
url: https://github.com/supabase-community/supabase-mcp
type: local
auth: api-key
description: Supabase database and project management
tags: [database, supabase, api-key]
---

# Supabase MCP

Official Supabase server for database queries, schema management, and project operations.

## Installation

```jsonc
{
  "mcp": {
    "supabase": {
      "type": "local",
      "command": ["npx", "-y", "@supabase/mcp-server"],
      "environment": {
        "SUPABASE_ACCESS_TOKEN": "{env:SUPABASE_ACCESS_TOKEN}"
      }
    }
  }
}
```

## Setup

1. Get access token from Supabase dashboard
2. Set `SUPABASE_ACCESS_TOKEN` environment variable

## Usage

"Query users table from Supabase using supabase MCP"

"Create a new table in Supabase with supabase"

## Links

- [GitHub](https://github.com/supabase-community/supabase-mcp)
- [Docs](https://supabase.com/docs/guides/getting-started/mcp)
