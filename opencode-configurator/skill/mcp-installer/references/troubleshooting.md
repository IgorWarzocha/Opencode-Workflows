# Troubleshooting

<mcp_not_appearing>

- Check `"enabled": true` in MCP config
- Check not disabled in `"tools"` section
- Test remote URL: `curl https://mcp.example.com/mcp`
- Test local command: `npx -y @package/name`

</mcp_not_appearing>

<auth_failures>

```bash
opencode mcp list
opencode mcp debug server-name
opencode mcp logout server-name
opencode mcp auth server-name
```

</auth_failures>

<oauth_issues>

- Verify server supports RFC 7591
- Use pre-registered OAuth if auto fails
- Check browser console for errors
- Clear tokens: `rm ~/.local/share/opencode/mcp-auth.json`

</oauth_issues>

<context_limits>

MCPs add to context. Solutions:

- Disable unused: `"tools": { "my-mcp": false }`
- Per-agent enable: `agent.my-agent.tools`
- Use lightweight alternatives (gh_grep vs github)

</context_limits>

<env_variables>

```bash
echo $MY_VAR  # Check if set
export MY_VAR=value  # Set in shell
```

Or add to `.env` file in project root.

</env_variables>

<local_command_issues>

```bash
which npx  # Check in PATH
npx -y @package/name  # Test manually
```

Use absolute paths if needed.

</local_command_issues>

<remote_connection>

```bash
curl https://mcp.example.com/mcp  # Test URL
```

Increase timeout if slow:
```jsonc
{
  "timeout": 30000
}
```

</remote_connection>
