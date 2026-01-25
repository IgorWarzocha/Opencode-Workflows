# MCP Configuration Reference

<config_structure>

MCP servers are configured in `opencode.json` under the `mcp` key:

```jsonc
{
  "mcp": {
    "mcp-name": {
      // config here
    }
  }
}
```

</config_structure>

<local_mcp>

## Local MCP Servers

Run a local process as an MCP server.

```jsonc
{
  "type": "local",
  "command": ["npx", "-y", "@package/name", "args"],
  "environment": {
    "VAR": "{env:VAR}"
  },
  "enabled": true,
  "timeout": 5000
}
```

- MUST use array format for `command` (not string)
- SHOULD set `timeout` for slow-starting servers
- MAY use `{env:VAR}` syntax for environment variables

</local_mcp>

<remote_mcp>

## Remote MCP Servers

Connect to a remote MCP endpoint.

```jsonc
{
  "type": "remote",
  "url": "https://example.com/mcp",
  "headers": {
    "Authorization": "Bearer {env:API_KEY}"
  },
  "oauth": {},
  "enabled": true,
  "timeout": 5000
}
```

- MUST include full URL with protocol
- SHOULD use `{env:VAR}` for secrets in headers
- MAY use `oauth: {}` to enable automatic OAuth

</remote_mcp>

<oauth>

## OAuth Configuration

**Automatic** (most servers):
```bash
opencode mcp auth server-name
```

**Pre-registered credentials**:
```jsonc
{
  "oauth": {
    "clientId": "{env:CLIENT_ID}",
    "clientSecret": "{env:CLIENT_SECRET}",
    "scope": "tools:read"
  }
}
```

**Disable OAuth**:
```jsonc
{
  "oauth": false
}
```

- MUST run `opencode mcp auth` after adding OAuth-enabled servers
- SHOULD use environment variables for credentials

</oauth>

<tool_management>

## Tool Visibility

Control which MCP tools are available:

```jsonc
{
  "tools": {
    "my-mcp": false,
    "my-mcp*": false
  },
  "agent": {
    "my-agent": {
      "tools": {
        "my-mcp": true
      }
    }
  }
}
```

- SHOULD disable high-context MCPs globally, enable per-agent
- MAY use wildcards (`*`) to match multiple tools

</tool_management>

<environment_variables>

## Environment Variables

Use `{env:VAR_NAME}` syntax in config. Set variables via:

```bash
export VAR_NAME=value
```

Or in `.env` file in project root.

- MUST NOT commit secrets to config files
- SHOULD use `.env` for project-specific variables

</environment_variables>
