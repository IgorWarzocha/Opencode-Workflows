# Complete Plugin Examples

> Ready-to-use plugin examples for common use cases

<examples>

## Notifications Plugin

Send OS notifications when sessions complete:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const NotifyPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`osascript -e 'display notification "Done!" with title "OpenCode"'`
      }
    },
  }
}
```

## .env Protection Plugin

Block reading of sensitive environment files:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const EnvProtection: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      const isRead = input.tool === "read"
      const isEnv = output.args.filePath?.match(/\.env($|\.)/)
      if (isRead && isEnv) {
        throw new Error("Blocked: .env files cannot be read")
      }
    },
  }
}
```

## Temperature Override Plugin

Force specific LLM parameters:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const TempPlugin: Plugin = async () => {
  return {
    "chat.params": async (input, output) => {
      output.temperature = 0.3 // More deterministic
      output.topP = 0.9
    },
  }
}
```

## Session Logger Plugin

Log all session events:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const LoggerPlugin: Plugin = async () => {
  return {
    event: async ({ event }) => {
      console.log(`[${new Date().toISOString()}] ${event.type}`, event.properties)
    },
  }
}
```

## Command Blocker Plugin

Block dangerous bash commands:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

const BLOCKED_PATTERNS = [/rm\s+-rf\s+\//, /sudo\s+rm/, />\s*\/dev\/sd/]

export const CommandBlocker: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "bash") return

      const command = output.args.command as string
      for (const pattern of BLOCKED_PATTERNS) {
        if (pattern.test(command)) {
          throw new Error(`Blocked dangerous command: ${command}`)
        }
      }
    },
  }
}
```

## Auto-Approve Plugin

Auto-approve specific permission types:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const AutoApprove: Plugin = async () => {
  return {
    "permission.ask": async (input, output) => {
      // Auto-approve read operations
      if (input.type === "read") {
        output.status = "allow"
      }
      // Auto-approve specific tools
      if (input.type === "tool" && input.metadata.tool === "glob") {
        output.status = "allow"
      }
    },
  }
}
```

## Custom Tool Plugin

Add a custom tool for the LLM:

```typescript
import { type Plugin, tool } from "@opencode-ai/plugin"

export const CustomTool: Plugin = async ({ $ }) => {
  return {
    tool: {
      wordcount: tool({
        description: "Count words in a file",
        args: {
          file: tool.schema.string().describe("Path to file"),
        },
        async execute(args) {
          const result = await $`wc -w ${args.file}`.quiet()
          return result.text().trim()
        },
      }),
    },
  }
}
```

</examples>
