# Tool Helper Reference

> Auto-generated on 2025-12-26T13:17:55.482Z
> Source: `packages/plugin/src/tool.ts`

<api_reference>

## Tool Definition

```typescript
import { z } from "zod"

export type ToolContext = {
  sessionID: string
  messageID: string
  agent: string
  abort: AbortSignal
}

export function tool<Args extends z.ZodRawShape>(input: {
  description: string
  args: Args
  execute(args: z.infer<z.ZodObject<Args>>, context: ToolContext): Promise<string>
}) {
  return input
}
tool.schema = z

export type ToolDefinition = ReturnType<typeof tool>

```

## Usage Pattern

```typescript
import { type Plugin, tool } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async (ctx) => {
  return {
    tool: {
      myTool: tool({
        description: "What this tool does",
        args: {
          input: tool.schema.string().describe("Input parameter"),
          count: tool.schema.number().optional().describe("Optional count"),
          enabled: tool.schema.boolean().default(true),
        },
        async execute(args, context) {
          // args is typed from schema
          // context: { sessionID, messageID, agent, abort }
          return `Result: ${args.input}`
        },
      }),
    },
  }
}
```

</api_reference>

<zod_reference>

## Zod Schema Methods

`tool.schema` is Zod. Common methods:

| Method | Description |
|--------|-------------|
| `.string()` | String argument |
| `.number()` | Number argument |
| `.boolean()` | Boolean argument |
| `.array(schema)` | Array of items |
| `.object({ ... })` | Nested object |
| `.enum(["a", "b"])` | Enum values |
| `.optional()` | Make optional |
| `.default(val)` | Default value |
| `.describe("...")` | Add description for LLM |

</zod_reference>

<tool_context>

## Tool Context

```typescript
type ToolContext = {
  sessionID: string
  messageID: string
  agent: string
  abort: AbortSignal
}
```

</tool_context>
