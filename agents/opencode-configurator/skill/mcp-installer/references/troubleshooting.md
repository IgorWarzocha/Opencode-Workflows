# Troubleshooting

<mcp_not_appearing>

## MCP Not Appearing

1. Check `"enabled": true` in MCP config
2. Verify not disabled in `"tools"` section
3. Test connectivity:

```bash
# Remote
curl https://mcp.example.com/mcp

# Local
npx -y @package/name
```

- MUST restart OpenCode after config changes

</mcp_not_appearing>

<auth_failures>

## Authentication Failures

```bash
opencode mcp list          # Check status
opencode mcp debug name    # Debug specific server
opencode mcp logout name   # Clear credentials
opencode mcp auth name     # Re-authenticate
```

- SHOULD clear and re-auth if tokens are stale

</auth_failures>

<oauth_issues>

## OAuth Issues

- Verify server supports RFC 7591 (Dynamic Client Registration)
- Use pre-registered OAuth if automatic fails
- Check browser console for popup errors
- Clear tokens manually:

```bash
rm ~/.local/share/opencode/mcp-auth.json
```

- SHOULD use pre-registered credentials for enterprise servers

</oauth_issues>

<context_limits>

## Context Limit Issues

MCPs add tool definitions to context. Solutions:

- Disable unused: `"tools": { "my-mcp": false }`
- Enable per-agent: `agent.my-agent.tools`
- Use lightweight alternatives (gh_grep vs github)

- SHOULD prefer remote MCPs over local for lower context
- SHOULD disable high-context MCPs globally

</context_limits>

<env_variables>

## Environment Variable Issues

```bash
echo $MY_VAR              # Check if set
export MY_VAR=value       # Set in shell
```

Or add to `.env` file in project root.

- MUST set variables before starting OpenCode
- SHOULD use `.env` for project-specific values

</env_variables>

<local_command_issues>

## Local Command Issues

```bash
which npx                 # Check in PATH
npx -y @package/name      # Test manually
```

- SHOULD use absolute paths if PATH issues persist
- MAY increase timeout for slow-starting servers

</local_command_issues>

<remote_connection>

## Remote Connection Issues

```bash
curl https://mcp.example.com/mcp  # Test URL
```

Increase timeout if slow:
```jsonc
{
  "timeout": 30000
}
```

- SHOULD check firewall/proxy settings
- MAY need VPN for enterprise servers

</remote_connection>
