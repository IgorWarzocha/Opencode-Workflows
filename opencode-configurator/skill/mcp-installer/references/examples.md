# Common MCP Servers

<context7>

## Context7 - Documentation Search

Remote server for searching library/framework docs. Requires API key.

```jsonc
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"
      }
    }
  }
}
```

- MUST set `CONTEXT7_API_KEY` environment variable

</context7>

<gh_grep>

## gh_grep - GitHub Code Search

Remote server for searching GitHub code. No auth required.

```jsonc
{
  "mcp": {
    "gh_grep": {
      "type": "remote",
      "url": "https://mcp.grep.app"
    }
  }
}
```

</gh_grep>

<sentry>

## Sentry - Error Tracking

Remote server with OAuth authentication.

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

- MUST run `opencode mcp auth sentry` after adding

</sentry>

<filesystem>

## Filesystem - Local File Access

Local server for file operations.

```jsonc
{
  "mcp": {
    "filesystem": {
      "type": "local",
      "command": [
        "npx",
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/allowed/path"
      ]
    }
  }
}
```

- MUST specify allowed paths as arguments
- SHOULD restrict to project directories

</filesystem>

<github>

## GitHub - Repository API

Local server for GitHub API access. High context usage.

```jsonc
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "environment": {
        "GITHUB_TOKEN": "{env:GITHUB_TOKEN}"
      }
    }
  }
}
```

- MUST set `GITHUB_TOKEN` environment variable
- SHOULD disable globally and enable per-agent to manage context

</github>

<finding_more>

## Finding More Servers

- Official registry: https://github.com/modelcontextprotocol/servers
- npm packages: `@modelcontextprotocol/server-*`
- This skill's catalog: `references/mcps/*.md`

</finding_more>
