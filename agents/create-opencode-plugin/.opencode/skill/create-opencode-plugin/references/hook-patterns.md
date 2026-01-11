# Hook Patterns Reference

> All hook implementation patterns with examples

<patterns>

## 1. Event Hook (Reactive)

Listen to all events, discriminate by `type`:

```typescript
return {
  event: async ({ event }) => {
    switch (event.type) {
      case "session.idle":
        console.log("Session completed:", event.properties.sessionID)
        break
      case "file.edited":
        console.log("File changed:", event.properties.file)
        break
    }
  },
}
```

## 2. Custom Tools

Register tools the LLM can call:

```typescript
import { type Plugin, tool } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async (ctx) => {
  return {
    tool: {
      lint: tool({
        description: "Run ESLint on a file",
        args: {
          file: tool.schema.string().describe("File path to lint"),
          fix: tool.schema.boolean().optional().describe("Auto-fix issues"),
        },
        async execute(args, context) {
          const result = await ctx.$`eslint ${args.fix ? "--fix" : ""} ${args.file}`.quiet()
          return result.text()
        },
      }),
    },
  }
}
```

## 3. Tool Execution Hooks

Intercept before/after tool execution:

```typescript
return {
  // Modify args or throw to block
  "tool.execute.before": async (input, output) => {
    if (input.tool === "read" && output.args.filePath?.includes(".env")) {
      throw new Error("Reading .env files is blocked")
    }
  },

  // Modify output/title/metadata
  "tool.execute.after": async (input, output) => {
    console.log(`Tool ${input.tool} completed`)
    // Modify: output.title, output.output, output.metadata
  },
}
```

## 4. Permission Hook

Override permission decisions:

```typescript
return {
  "permission.ask": async (input, output) => {
    // input: { id, type, pattern, sessionID, messageID, title, metadata }
    // output.status: "ask" | "deny" | "allow"

    if (input.type === "bash" && input.metadata.command?.includes("rm -rf")) {
      output.status = "deny"
    }
  },
}
```

## 5. Chat Hooks

Modify messages or LLM parameters:

```typescript
return {
  // Intercept user messages
  "chat.message": async (input, output) => {
    // input: { sessionID, agent?, model?, messageID? }
    // output: { message: UserMessage, parts: Part[] }
    console.log("User message:", output.message)
  },

  // Modify LLM parameters per request
  "chat.params": async (input, output) => {
    // input: { sessionID, agent, model, provider, message }
    // output: { temperature, topP, topK, options }
    if (input.agent === "creative") {
      output.temperature = 0.9
    }
  },
}
```

## 6. Auth Hook

Add custom provider authentication:

```typescript
return {
  auth: {
    provider: "my-provider",
    methods: [
      {
        type: "api",
        label: "API Key",
        prompts: [
          {
            type: "text",
            key: "apiKey",
            message: "Enter your API key",
            validate: (v) => (v.length < 10 ? "Key too short" : undefined),
          },
        ],
        async authorize(inputs) {
          return { type: "success", key: inputs!.apiKey }
        },
      },
    ],
  },
}
```

## 7. Compaction Hook

Customize session compaction:

```typescript
return {
  "experimental.session.compacting": async (input, output) => {
    // Add context to default prompt
    output.context.push("Remember: user prefers TypeScript")

    // OR replace entire prompt
    output.prompt = "Summarize this session focusing on code changes..."
  },
}
```

## 8. Config Hook

Modify configuration on load:

```typescript
return {
  config: async (config) => {
    // Mutate config object
    config.theme = "dark"
  },
}
```

</patterns>

<quick_reference>

## Hook Signature Quick Reference

| Hook                  | Signature                      | Mutate             |
| --------------------- | ------------------------------ | ------------------ |
| `event`               | `({ event }) => void`          | Read-only          |
| `config`              | `(config) => void`             | Mutate config      |
| `tool`                | Object of `tool()` definitions | N/A                |
| `auth`                | `AuthHook` object              | N/A                |
| `chat.message`        | `(input, output) => void`      | Mutate output      |
| `chat.params`         | `(input, output) => void`      | Mutate output      |
| `permission.ask`      | `(input, output) => void`      | Set output.status  |
| `tool.execute.before` | `(input, output) => void`      | Mutate output.args |
| `tool.execute.after`  | `(input, output) => void`      | Mutate output      |
| `experimental.*`      | `(input, output) => void`      | Mutate output      |

</quick_reference>
