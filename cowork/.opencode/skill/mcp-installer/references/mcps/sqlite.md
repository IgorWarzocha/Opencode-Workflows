---
name: sqlite
url: https://github.com/modelcontextprotocol/servers
type: local
auth: none
description: SQLite database access
tags: [database, sqlite]
---

# SQLite MCP

SQLite database queries and management.

## Installation

```jsonc
{
  "mcp": {
    "sqlite": {
      "type": "local",
      "command": [
        "npx",
        "-y",
        "@modelcontextprotocol/server-sqlite",
        "--db-path",
        "/path/to/database.db"
      ]
    }
  }
}
```

## Setup

Provide path to SQLite database file in command args.

## Usage

"Query all users from sqlite"

"Create a new table in the database using sqlite"

## Links

- [GitHub](https://github.com/modelcontextprotocol/servers)
