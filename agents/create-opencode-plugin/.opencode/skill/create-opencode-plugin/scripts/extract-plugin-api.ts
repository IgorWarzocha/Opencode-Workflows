#!/usr/bin/env bun
/**
 * Extracts current plugin API from SDK source files.
 * Generates reference docs in ../references/
 *
 * Usage: bun run extract-plugin-api.ts [--workspace /path/to/opencode]
 */

import { existsSync } from "node:fs"
import { join, dirname } from "node:path"

const args = process.argv.slice(2)
const workspaceIdx = args.indexOf("--workspace")
const workspace = workspaceIdx !== -1 ? args[workspaceIdx + 1] : findWorkspace()

function findWorkspace(): string {
  let dir = process.cwd()
  while (dir !== "/") {
    if (existsSync(join(dir, "packages/plugin/src/index.ts"))) return dir
    dir = dirname(dir)
  }
  throw new Error("Could not find opencode workspace. Use --workspace flag.")
}

const PLUGIN_INDEX = join(workspace, "packages/plugin/src/index.ts")
const PLUGIN_TOOL = join(workspace, "packages/plugin/src/tool.ts")
const SDK_TYPES = join(workspace, "packages/sdk/js/src/v2/gen/types.gen.ts")
const REFERENCES_DIR = join(dirname(import.meta.dir), "references")

async function extractHooksInterface(): Promise<string> {
  const content = await Bun.file(PLUGIN_INDEX).text()
  const hooksMatch = content.match(/export interface Hooks \{[\s\S]*?\n\}/m)
  if (!hooksMatch) throw new Error("Could not find Hooks interface")
  return hooksMatch[0]
}

async function extractPluginInput(): Promise<string> {
  const content = await Bun.file(PLUGIN_INDEX).text()
  const match = content.match(/export type PluginInput = \{[\s\S]*?\n\}/m)
  if (!match) throw new Error("Could not find PluginInput type")
  return match[0]
}

async function extractToolDefinition(): Promise<string> {
  const content = await Bun.file(PLUGIN_TOOL).text()
  return content
}

type EventInfo = { name: string; type: string; fullType: string }

async function extractEvents(): Promise<EventInfo[]> {
  const content = await Bun.file(SDK_TYPES).text()
  const events: EventInfo[] = []

  // Find Event union to get all event type names
  const unionMatch = content.match(/export type Event =\s*([\s\S]*?)(?=\n\nexport|\n\n\/\*\*)/m)
  if (!unionMatch) return events

  const eventTypeNames = unionMatch[1].match(/Event\w+/g) || []

  // For each event type, extract its full definition
  for (const typeName of eventTypeNames) {
    const typeRegex = new RegExp(`export type ${typeName} = \\{([\\s\\S]*?)\\n\\}`, "m")
    const typeMatch = content.match(typeRegex)

    if (typeMatch) {
      // Extract the event type string from the type definition
      const typeStringMatch = typeMatch[1].match(/type:\s*"([^"]+)"/)
      if (typeStringMatch) {
        events.push({
          name: typeName,
          type: typeStringMatch[1],
          fullType: `export type ${typeName} = {${typeMatch[1]}\n}`,
        })
      }
    }
  }

  return events
}

async function extractEventUnion(): Promise<string[]> {
  const content = await Bun.file(SDK_TYPES).text()
  const match = content.match(/export type Event =\s*([\s\S]*?)(?=\n\nexport|\n\n\/\*\*)/m)
  if (!match) return []
  const types = match[1].match(/Event\w+/g) || []
  return types
}

async function extractAuthHook(): Promise<string> {
  const content = await Bun.file(PLUGIN_INDEX).text()
  const authHookMatch = content.match(/export type AuthHook = \{[\s\S]*?\n\}\n/m)
  const authResultMatch = content.match(/export type AuthOuathResult[\s\S]*?\n\)\n/m)
  return [authHookMatch?.[0] || "", authResultMatch?.[0] || ""].join("\n")
}

function generateHooksReference(hooks: string, pluginInput: string, authHook: string): string {
  const timestamp = new Date().toISOString()
  return `# Plugin Hooks Reference

> Auto-generated on ${timestamp}
> Source: \`packages/plugin/src/index.ts\`

## Plugin Function Signature

\`\`\`typescript
${pluginInput}

export type Plugin = (input: PluginInput) => Promise<Hooks>
\`\`\`

## Hooks Interface

\`\`\`typescript
${hooks}
\`\`\`

## Hook Categories

### Event Hook
- \`event\`: Receives all events, use \`event.type\` to discriminate

### Tool Hook
- \`tool\`: Register custom tools (see tool-helper.md)

### Chat Hooks
- \`chat.message\`: Intercept/modify user messages before processing
- \`chat.params\`: Modify LLM parameters (temperature, topP, topK)

### Permission Hook
- \`permission.ask\`: Override permission decisions (allow/deny/ask)

### Tool Execution Hooks
- \`tool.execute.before\`: Intercept before tool runs, modify args
- \`tool.execute.after\`: Process tool output, modify title/metadata

### Config Hook
- \`config\`: Modify configuration on load

### Auth Hook
- \`auth\`: Custom provider authentication (OAuth or API key)

### Experimental Hooks
- \`experimental.chat.messages.transform\`: Transform message history
- \`experimental.chat.system.transform\`: Modify system prompt
- \`experimental.session.compacting\`: Customize compaction context
- \`experimental.text.complete\`: Post-process text output

## Auth Hook Types

\`\`\`typescript
${authHook}
\`\`\`
`
}

function generateEventsReference(events: EventInfo[], eventTypes: string[]): string {
  const timestamp = new Date().toISOString()

  const byCategory = new Map<string, EventInfo[]>()
  for (const event of events) {
    const category = event.type.split(".")[0]
    if (!byCategory.has(category)) byCategory.set(category, [])
    byCategory.get(category)!.push(event)
  }

  let content = `# Events Reference

> Auto-generated on ${timestamp}
> Source: \`packages/sdk/js/src/v2/gen/types.gen.ts\`

## Event Union (${eventTypes.length} types)

\`\`\`typescript
export type Event =
${eventTypes.map((t) => `  | ${t}`).join("\n")}
\`\`\`

## Quick Reference

| Event Type | TypeScript Type |
|------------|-----------------|
${events.map((e) => `| \`${e.type}\` | \`${e.name}\` |`).join("\n")}

## Events by Category

`

  const sortedCategories = [...byCategory.keys()].sort()
  for (const category of sortedCategories) {
    const categoryEvents = byCategory.get(category)!
    content += `### ${category}\n\n`

    for (const event of categoryEvents) {
      content += `#### \`${event.type}\`\n\n`
      content += `\`\`\`typescript\n${event.fullType}\n\`\`\`\n\n`
    }
  }

  return content
}

function generateToolReference(toolDef: string): string {
  const timestamp = new Date().toISOString()
  return `# Tool Helper Reference

> Auto-generated on ${timestamp}
> Source: \`packages/plugin/src/tool.ts\`

## Tool Definition

\`\`\`typescript
${toolDef}
\`\`\`

## Usage Pattern

\`\`\`typescript
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
          return \`Result: \${args.input}\`
        },
      }),
    },
  }
}
\`\`\`

## Zod Schema Methods

\`tool.schema\` is Zod. Common methods:

| Method | Description |
|--------|-------------|
| \`.string()\` | String argument |
| \`.number()\` | Number argument |
| \`.boolean()\` | Boolean argument |
| \`.array(schema)\` | Array of items |
| \`.object({ ... })\` | Nested object |
| \`.enum(["a", "b"])\` | Enum values |
| \`.optional()\` | Make optional |
| \`.default(val)\` | Default value |
| \`.describe("...")\` | Add description for LLM |

## Tool Context

\`\`\`typescript
type ToolContext = {
  sessionID: string
  messageID: string
  agent: string
  abort: AbortSignal
}
\`\`\`
`
}

async function main() {
  console.log("Extracting plugin API from:", workspace)

  const [hooks, pluginInput, authHook, events, eventTypes, toolDef] = await Promise.all([
    extractHooksInterface(),
    extractPluginInput(),
    extractAuthHook(),
    extractEvents(),
    extractEventUnion(),
    extractToolDefinition(),
  ])

  console.log(`Found ${events.length} events, ${eventTypes.length} in union`)

  const hooksRef = generateHooksReference(hooks, pluginInput, authHook)
  const eventsRef = generateEventsReference(events, eventTypes)
  const toolRef = generateToolReference(toolDef)

  await Promise.all([
    Bun.write(join(REFERENCES_DIR, "hooks.md"), hooksRef),
    Bun.write(join(REFERENCES_DIR, "events.md"), eventsRef),
    Bun.write(join(REFERENCES_DIR, "tool-helper.md"), toolRef),
  ])

  console.log("Generated references:")
  console.log("  - references/hooks.md")
  console.log("  - references/events.md")
  console.log("  - references/tool-helper.md")
  console.log("\nDone!")
}

main().catch((e) => {
  console.error("Error:", e.message)
  process.exit(1)
})
