---
name: redis
url: https://github.com/redis/mcp-redis
type: local
auth: none
description: Redis database access and management
tags: [database, redis, cache]
---

# Redis MCP

Official Redis server for data management and search.

## Installation

```jsonc
{
  "mcp": {
    "redis": {
      "type": "local",
      "command": ["npx", "-y", "@redis/mcp-redis"],
      "environment": {
        "REDIS_URI": "redis://localhost:6379"
      }
    }
  }
}
```

## Setup

Set `REDIS_URI` to your Redis connection string.

## Usage

"Query Redis for session data using redis MCP"

"Search vector embeddings in Redis with redis"

## Links

- [GitHub](https://github.com/redis/mcp-redis)
- [Blog](https://redis.io/blog/introducing-model-context-protocol-mcp-for-redis)
