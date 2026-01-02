# Testing Plugins

> How to test plugins during development

<workflow>

## Step 1: Create Test Environment

Create a test folder with an `opencode.json` that loads your plugin from source.

### If developing within opencode source folder:

```bash
mkdir -p /path/to/opencode/test-my-plugin
```

```jsonc
// /path/to/opencode/test-my-plugin/opencode.json
{
  "plugin": ["file:///path/to/opencode/.opencode/plugin/my-plugin/index.ts"],
}
```

### If developing in a standalone folder:

```bash
mkdir -p ~/my-plugin-project/test
```

```jsonc
// ~/my-plugin-project/test/opencode.json
{
  "plugin": ["file:///home/user/my-plugin-project/my-plugin/index.ts"],
}
```

The `file://` prefix tells OpenCode to load the plugin directly from source (TypeScript or JavaScript) without requiring npm publish.

## Step 2: Verify Plugin Loads

Run a quick command to verify the plugin initializes without errors:

```bash
cd /path/to/test-folder
opencode run hi
```

This will:

- Start OpenCode
- Load all plugins (including yours)
- Run "hi" prompt
- Exit

**Watch for:**

- Plugin initialization errors in output
- Missing dependencies
- TypeScript compilation errors

## Step 3: Interactive Testing

Run OpenCode interactively in the test folder:

```bash
cd /path/to/test-folder
opencode
```

### Test checklist based on hook type:

| Hook                  | How to Test                                                  |
| --------------------- | ------------------------------------------------------------ |
| `event`               | Perform actions that trigger events, check console logs      |
| `tool`                | Ask the LLM to use your custom tool                          |
| `tool.execute.before` | Run the tool being intercepted, verify blocking/modification |
| `tool.execute.after`  | Run tools, check output modifications                        |
| `permission.ask`      | Trigger permission prompts, verify overrides                 |
| `chat.params`         | Check LLM behavior changes (temperature, etc.)               |
| `config`              | Verify config mutations take effect                          |
| `auth`                | Run `/auth` command for your provider                        |

## Step 4: Testing Toasts and UI Feedback

If your plugin shows toasts or inline messages:

1. Trigger the condition that shows the notification
2. Verify toast appears with correct variant/message
3. Check duration is appropriate
4. Test error cases (TUI unavailable) - plugin MUST NOT crash

</workflow>

<example>

## Example Test Session

```bash
# Create test folder
mkdir -p ~/test-env-plugin
cd ~/test-env-plugin

# Create config pointing to plugin source
cat > opencode.json << 'EOF'
{
  "plugin": [
    "file:///home/user/my-plugins/env-protection/index.ts"
  ]
}
EOF

# Verify plugin loads
opencode run hi

# If no errors, test interactively
opencode

# In opencode, test the functionality:
# > Read the .env file
# (Should be blocked if env-protection plugin works)
```

</example>

<unit_testing>

## Unit Testing (Optional)

For complex plugins, MAY create unit tests with mocked context:

```typescript
// test-plugin.ts
import { MyPlugin } from "./my-plugin"

const mockClient = {
  tui: {
    showToast: async (params: any) => {
      console.log("Toast:", params.body)
      return true
    },
  },
  session: {
    prompt: async (params: any) => {
      console.log("Inline message:", params.body.parts[0].text)
    },
  },
}

const mockContext = {
  project: { id: "test", worktree: "/tmp", time: { created: 0, updated: 0 } },
  client: mockClient as any,
  $: Bun.$ as any,
  directory: "/tmp",
  worktree: "/tmp",
}

const hooks = await MyPlugin(mockContext)

// Test event hook
await hooks.event?.({
  event: { type: "session.idle", properties: { sessionID: "123" } },
})

// Test tool execution hook
await hooks["tool.execute.before"]?.({ tool: "read", sessionID: "123", callID: "abc" }, { args: { filePath: ".env" } })
```

Run with:

```bash
bun run test-plugin.ts
```

</unit_testing>
