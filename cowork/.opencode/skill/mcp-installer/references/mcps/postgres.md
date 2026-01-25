---
name: postgres
url: https://github.com/modelcontextprotocol/servers
type: local
auth: none
description: PostgreSQL database access
tags: [database, postgres, sql]
---

# Postgres MCP

PostgreSQL schema inspection and read-only queries.

## Installation

```jsonc
{
  "mcp": {
    "postgres": {
      "type": "local",
      "command": [
        "npx",
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://user:password@localhost:5432/dbname"
      ]
    }
  }
}
```

## Setup

Provide PostgreSQL connection string in command args.

⚠️ Use env var for credentials:
```jsonc
{
  "command": [
    "npx",
    "-y",
    "@modelcontextprotocol/server-postgres",
    "{env:DATABASE_URL}"
  ]
}
```

## Usage

"Inspect database schema with postgres MCP"

"Query all users from postgres"

## Links

- [GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/postgres)
