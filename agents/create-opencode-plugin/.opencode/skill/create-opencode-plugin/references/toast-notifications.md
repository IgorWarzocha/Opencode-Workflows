# Toast Notifications

> Reference for showing toast notifications in OpenCode TUI

<overview>

Plugins can display **toast notifications** - temporary popup messages that appear in the TUI corner. These are ideal for brief status updates, confirmations, warnings, or alerts that don't need to persist in the chat.

</overview>

<guidelines>

## When to Use

Use toasts for:

- Success confirmations ("Settings saved", "File exported")
- Configuration errors or warnings
- Model/provider fallback notices
- Brief status updates
- Non-critical alerts

**SHOULD NOT use for:**

- Detailed information (use inline messages instead - see `ui-feedback.md`)
- Persistent status that user needs to reference later
- High-frequency updates (will spam the user)

</guidelines>

<api_reference>

## The API

### SDK Method

```typescript
await client.tui.showToast({
  body: {
    title: "Optional Title", // Optional heading
    message: "Toast message", // Required message text
    variant: "success", // "info" | "success" | "warning" | "error"
    duration: 5000, // Optional: milliseconds
  },
})
```

### Parameters

| Parameter  | Type                                          | Required | Description                       |
| ---------- | --------------------------------------------- | -------- | --------------------------------- |
| `title`    | `string`                                      | No       | Optional heading for the toast    |
| `message`  | `string`                                      | Yes      | The main message content          |
| `variant`  | `"info" \| "success" \| "warning" \| "error"` | Yes      | Visual style and icon             |
| `duration` | `number`                                      | No       | Auto-dismiss time in milliseconds |

### Variants

| Variant   | Use Case                              | Visual                       |
| --------- | ------------------------------------- | ---------------------------- |
| `info`    | Neutral information, fallback notices | Blue/neutral styling         |
| `success` | Successful operations                 | Green styling with checkmark |
| `warning` | Configuration issues, caution notices | Yellow/orange styling        |
| `error`   | Failures or critical problems         | Red styling                  |

</api_reference>

<examples>

## Complete Example

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const ToastPlugin: Plugin = async ({ client }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        try {
          await client.tui.showToast({
            body: {
              title: "Session Complete",
              message: "All tasks finished successfully",
              variant: "success",
              duration: 4000,
            },
          })
        } catch {
          // Ignore toast errors - TUI may not be available
        }
      }
    },
  }
}
```

## Error Handling

MUST wrap toast calls in try/catch - the TUI MAY not be available (e.g., in headless mode):

```typescript
async function showToast(
  client: any,
  message: string,
  variant: "info" | "success" | "warning" | "error" = "info",
  title?: string,
  duration?: number,
): Promise<void> {
  try {
    await client.tui.showToast({
      body: {
        title,
        message,
        variant,
        duration,
      },
    })
  } catch {
    // Ignore - TUI may not be available
  }
}
```

</examples>

<patterns>

## Practical Patterns

### Delayed Toast (Avoid Blocking Init)

When showing toasts during plugin initialization, SHOULD use `setTimeout` to avoid blocking:

```typescript
export const ConfigPlugin: Plugin = async ({ client }) => {
  const config = loadConfig()

  if (config.hasErrors) {
    // Delay toast to avoid blocking plugin init
    setTimeout(async () => {
      try {
        await client.tui.showToast({
          body: {
            title: "Plugin: Invalid config",
            message: `${config.path}\n${config.errorMessage}\nUsing default values`,
            variant: "warning",
            duration: 7000,
          },
        })
      } catch {}
    }, 7000) // Delay allows TUI to fully initialize
  }

  return {
    // ... hooks
  }
}
```

### Multi-line Messages

Use `\n` for line breaks in toast messages:

```typescript
await client.tui.showToast({
  body: {
    title: "Model Fallback",
    message: `anthropic/claude-3-opus failed\nUsing openai/gpt-4 instead`,
    variant: "info",
    duration: 5000,
  },
})
```

### Notification on Session Events

```typescript
return {
  event: async ({ event }) => {
    switch (event.type) {
      case "session.idle":
        try {
          await client.tui.showToast({
            body: {
              message: "Session completed",
              variant: "success",
            },
          })
        } catch {}
        break

      case "session.error":
        try {
          await client.tui.showToast({
            body: {
              title: "Error",
              message: "Session encountered an error",
              variant: "error",
            },
          })
        } catch {}
        break
    }
  },
}
```

### Configuration Validation Warnings

```typescript
function showConfigWarning(client: any, configPath: string, errors: string[]): void {
  const message = [configPath, ...errors.slice(0, 2), errors.length > 2 ? `(+${errors.length - 2} more errors)` : ""]
    .filter(Boolean)
    .join("\n")

  setTimeout(async () => {
    try {
      await client.tui.showToast({
        body: {
          title: "MyPlugin: Invalid config",
          message,
          variant: "warning",
          duration: 7000,
        },
      })
    } catch {}
  }, 7000)
}
```

### Model/Provider Fallback Notice

```typescript
return {
  "chat.params": async (input, output) => {
    const preferredModel = getPreferredModel()
    const actualModel = input.model

    if (preferredModel && actualModel.id !== preferredModel.id) {
      try {
        await client.tui.showToast({
          body: {
            title: "Model Fallback",
            message: `${preferredModel.provider}/${preferredModel.id} unavailable\nUsing ${actualModel.providerID}/${actualModel.id}`,
            variant: "info",
            duration: 5000,
          },
        })
      } catch {}
    }
  },
}
```

</patterns>

<comparison>

## Toast vs Inline Messages

| Aspect           | Toast                  | Inline Message            |
| ---------------- | ---------------------- | ------------------------- |
| **Visibility**   | Temporary popup corner | Persistent in chat        |
| **Duration**     | Auto-dismisses         | Stays until scrolled away |
| **Detail level** | Brief (1-3 lines)      | Can be multi-line         |
| **History**      | Not saved              | Visible in session        |
| **Use case**     | Quick alerts, warnings | Detailed status with data |

Use **toasts** for ephemeral alerts and warnings. Use **inline messages** (see `ui-feedback.md`) for detailed status that users might want to reference.

</comparison>

<constraints>

## Limitations

| Limitation         | Details                              |
| ------------------ | ------------------------------------ |
| No interactivity   | MUST NOT include buttons or inputs   |
| Brief content only | SHOULD keep to 1-3 lines             |
| No custom styling  | Limited to predefined variants       |
| TUI only           | Won't appear in web or headless mode |
| May fail silently  | MUST wrap in try/catch               |
| Rate limiting      | SHOULD avoid rapid-fire toasts       |

</constraints>
