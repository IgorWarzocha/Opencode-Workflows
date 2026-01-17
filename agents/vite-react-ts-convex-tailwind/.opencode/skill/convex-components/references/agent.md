# Agent Component (Extensive)

Sources:
- https://convex.dev/components/agent
- https://docs.convex.dev/agents
- https://docs.convex.dev/agents/agent-usage
- https://docs.convex.dev/agents/threads
- https://docs.convex.dev/agents/messages
- https://docs.convex.dev/agents/context
- https://docs.convex.dev/agents/tools
- https://docs.convex.dev/agents/workflows
- https://docs.convex.dev/agents/files
- https://docs.convex.dev/agents/debugging
- https://docs.convex.dev/agents/usage-tracking
- https://docs.convex.dev/agents/rate-limiting

## Install and Configure

```bash
npm install @convex-dev/agent
```

`convex/convex.config.ts`:

```ts
import { defineApp } from "convex/server";
import agent from "@convex-dev/agent/convex.config.js";

const app = defineApp();
app.use(agent);
app.use(agent, { name: "agent2" });
export default app;
```

- Run `npx convex dev` to generate component API.
- Instantiate with `components.agent` in app code.

## Core Concepts

- Agents = LLM-powered behaviors (model + prompt + tools).
- Threads persist conversation history and can be shared by multiple users/agents.
- Messages are stored and reactive; streaming updates are synced via websockets.
- Built-in hybrid search (text + vector) over thread messages for context.

## Typical Flow

```ts
import { Agent } from "@convex-dev/agent";
import { openai } from "@ai-sdk/openai";
import { components } from "./_generated/api";
import { action } from "./_generated/server";

const supportAgent = new Agent(components.agent, {
  name: "Support Agent",
  chat: openai.chat("gpt-4o-mini"),
  instructions: "You are a helpful assistant.",
  tools: { accountLookup, fileTicket },
});

export const startThread = action({
  args: { prompt: v.string() },
  handler: async (ctx, { prompt }) => {
    const { threadId, thread } = await supportAgent.createThread(ctx);
    const result = await thread.generateText({ prompt });
    return { threadId, text: result.text };
  },
});

export const continueThread = action({
  args: { prompt: v.string(), threadId: v.string() },
  handler: async (ctx, { prompt, threadId }) => {
    const { thread } = await supportAgent.continueThread(ctx, { threadId });
    const result = await thread.generateText({ prompt });
    return result.text;
  },
});
```

## Tools

- Define tools with `createTool` and validated args.
- Tool outputs are added to the message history.
- Prefer deterministic tools; avoid side effects unless required.

## Context and Retrieval

- Thread history is automatically included.
- Context search can include thread-only or cross-thread data.
- RAG can be prompt-based or tool-based; integrates with RAG component.

## Files

- Files can be attached to threads; stored in Convex file storage.
- Automatic ref-counting and retrieval in thread history.

## Workflows

- Workflows enable multi-step agentic operations across agents/users.
- Prefer workflows for long-running or multi-stage tasks.

## Debugging and Observability

- Agent playground for prompt/context tuning.
- Debugging hooks to inspect tool calls and metadata.
- Usage tracking for per-agent/model/user attribution.
- Rate limiting via Rate Limiter component.

## Best Practices

- Keep tool set minimal and well-scoped.
- Use separate agents for distinct roles.
- Store workflow IDs in app tables for UI tracking.
- Scope context retrieval to least-privilege data.
