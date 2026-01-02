# Inline Status Messages

> Reference for displaying persistent status messages in OpenCode chat

<overview>

Plugins can display **inline message boxes** in the chat using the SDK's `session.prompt` API with special flags. This creates visible status updates that persist in the chat without triggering LLM responses.

</overview>

<guidelines>

## When to Use

Use inline messages when your plugin needs to:

- Show detailed progress or statistics
- Display multi-line status information
- Provide data the user MAY want to reference later
- Confirm actions with details (files processed, tokens saved, etc.)

**SHOULD NOT use for:**

- Brief alerts (use toast notifications instead - see `toast-notifications.md`)
- High-frequency updates (will spam the chat)
- Critical errors requiring immediate attention (use toasts)

</guidelines>

<api_reference>

## The Technique

### Core API Call

```typescript
await client.session.prompt({
  path: {
    id: sessionID,
  },
  body: {
    noReply: true, // Prevents LLM from responding
    agent: agent, // Optional: specify agent
    model: model, // Optional: specify model
    parts: [
      {
        type: "text",
        text: message, // Your status message
        ignored: true, // Message won't be included in context
      },
    ],
  },
})
```

### Key Flags

| Flag            | Purpose                                                         |
| --------------- | --------------------------------------------------------------- |
| `noReply: true` | Prevents the LLM from generating a response to this message     |
| `ignored: true` | Message appears in UI but is excluded from conversation context |

Both flags are REQUIRED for status-only messages.

</api_reference>

<examples>

## Complete Example

```typescript
import type { Plugin } from "@opencode-ai/plugin"

async function sendStatusMessage(
  client: any,
  sessionID: string,
  text: string,
  agent?: string,
  model?: { providerID: string; modelID: string },
): Promise<void> {
  try {
    await client.session.prompt({
      path: { id: sessionID },
      body: {
        noReply: true,
        agent,
        model,
        parts: [
          {
            type: "text",
            text,
            ignored: true,
          },
        ],
      },
    })
  } catch (error: any) {
    console.error("Failed to send status message:", error.message)
  }
}

export const StatusPlugin: Plugin = async ({ client }) => {
  let currentSessionID: string | null = null

  return {
    "chat.params": async (input, output) => {
      currentSessionID = input.sessionID
    },

    event: async ({ event }) => {
      if (event.type === "session.idle" && currentSessionID) {
        await sendStatusMessage(client, currentSessionID, "▣ MyPlugin | Session completed successfully")
      }
    },
  }
}
```

</examples>

<formatting>

## Message Formatting Best Practices

### Use Visual Prefixes

SHOULD use Unicode symbols as visual markers to distinguish plugin messages:

```typescript
const message = "▣ MyPlugin | Status message here"
```

Common prefixes:

- `▣` - Filled square (general status)
- `→` - Arrow (list items)
- `─` - Horizontal line (separators)

### Format Statistics

```typescript
function formatTokenCount(tokens: number): string {
  if (tokens >= 1000) {
    return `${(tokens / 1000).toFixed(1)}K`.replace(".0K", "K") + " tokens"
  }
  return tokens.toString() + " tokens"
}

const message = `▣ MyPlugin | ~${formatTokenCount(savedTokens)} saved total`
```

### Multi-line Messages

```typescript
const lines = [
  "▣ MyPlugin | Operation Complete",
  "",
  "▣ Details:",
  "→ Files processed: 5",
  "→ Items removed: 12",
  "→ Time: 230ms",
]
const message = lines.join("\n")
```

### Truncate Long Paths

```typescript
function truncate(str: string, maxLen: number = 60): string {
  if (str.length <= maxLen) return str
  return str.slice(0, maxLen - 3) + "..."
}

function shortenPath(path: string, workingDirectory?: string): string {
  if (workingDirectory && path.startsWith(workingDirectory + "/")) {
    return path.slice(workingDirectory.length + 1)
  }
  return path
}

// Usage
const displayPath = truncate(shortenPath(fullPath, ctx.directory), 60)
```

</formatting>

<patterns>

## Capturing Session Context

To send messages, you need the `sessionID`. Capture it from hooks:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async ({ client }) => {
  let currentSessionID: string | null = null
  let currentAgent: string | undefined
  let currentModel: { providerID: string; modelID: string } | undefined

  return {
    // Capture session info from chat.params
    "chat.params": async (input, output) => {
      currentSessionID = input.sessionID
      currentAgent = input.agent
      currentModel = {
        providerID: input.model.providerID,
        modelID: input.model.id,
      }
    },

    // Now you can send messages from other hooks
    "tool.execute.after": async (input, output) => {
      if (currentSessionID && input.tool === "bash") {
        await sendStatusMessage(
          client,
          currentSessionID,
          `▣ Command completed: ${output.title}`,
          currentAgent,
          currentModel,
        )
      }
    },
  }
}
```

## Detailed Status Pattern

For plugins that track statistics across a session:

```typescript
type PluginStats = {
  itemsProcessed: number
  tokensSaved: number
  errors: number
}

export const TrackingPlugin: Plugin = async ({ client }) => {
  let sessionID: string | null = null
  const stats: PluginStats = { itemsProcessed: 0, tokensSaved: 0, errors: 0 }

  function formatStats(): string {
    const lines = [
      `▣ MyPlugin | ${formatTokenCount(stats.tokensSaved)} saved total`,
      "",
      `▣ Session Stats:`,
      `→ Items processed: ${stats.itemsProcessed}`,
      `→ Errors: ${stats.errors}`,
    ]
    return lines.join("\n")
  }

  return {
    "chat.params": async (input) => {
      sessionID = input.sessionID
    },

    "tool.execute.after": async (input, output) => {
      stats.itemsProcessed++
      // ... track other stats
    },

    event: async ({ event }) => {
      if (event.type === "session.idle" && sessionID) {
        await sendStatusMessage(client, sessionID, formatStats())
      }
    },
  }
}
```

</patterns>

<comparison>

## Inline Messages vs Toasts

| Aspect             | Inline Message            | Toast                  |
| ------------------ | ------------------------- | ---------------------- |
| **Visibility**     | Persistent in chat        | Temporary popup        |
| **Duration**       | Stays until scrolled away | Auto-dismisses         |
| **Detail level**   | Multi-line, detailed      | Brief (1-3 lines)      |
| **History**        | Visible in session        | Not saved              |
| **Context impact** | None (`ignored: true`)    | None                   |
| **Use case**       | Stats, detailed status    | Quick alerts, warnings |

Use **inline messages** for detailed status with data. Use **toasts** (see `toast-notifications.md`) for ephemeral alerts.

</comparison>

<constraints>

## Limitations

| Limitation       | Details                                       |
| ---------------- | --------------------------------------------- |
| No styling       | Plain text only, no colors or formatting      |
| No interactivity | MUST NOT receive user input                   |
| Rate limiting    | SHOULD avoid sending too frequently           |
| Session required | MUST have valid sessionID                     |
| No persistence   | Messages only visible in current session view |

</constraints>
