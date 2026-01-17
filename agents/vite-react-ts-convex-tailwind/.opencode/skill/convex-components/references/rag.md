# RAG Component

<reference>
- https://convex.dev/components/rag
- https://docs.convex.dev/agents/rag
</reference>

<workflow>

### Install and Configure

```bash
npm install @convex-dev/rag
```

`convex/convex.config.ts`:

```ts
import { defineApp } from "convex/server";
import rag from "@convex-dev/rag/convex.config.js";

const app = defineApp();
app.use(rag);
export default app;
```

Instantiate:

```ts
import { RAG } from "@convex-dev/rag";
import { components } from "./_generated/api";
import { openai } from "@ai-sdk/openai";

const rag = new RAG(components.rag, {
  textEmbeddingModel: openai.embedding("text-embedding-3-small"),
  embeddingDimension: 1536,
  filterNames: ["category", "contentType"],
});
```

### Add Content

```ts
await rag.add(ctx, {
  namespace: "global",
  text,
  filterValues: [
    { name: "category", value: "news" },
    { name: "contentType", value: "article" },
  ],
});
```

### Search

```ts
const { results, text, entries, usage } = await rag.search(ctx, {
  namespace: "global",
  query: "convex components",
  limit: 10,
  vectorScoreThreshold: 0.5,
  chunkContext: { before: 2, after: 1 },
});
```

### Generate Text

```ts
const { text, context } = await rag.generateText(ctx, {
  search: { namespace: userId, limit: 10 },
  prompt: "Explain the policy",
  model: openai.chat("gpt-4o-mini"),
});
```

</workflow>

<rules>

### Core Features
- Namespaces for per-user/team isolation.
- Add/replace content with automatic embeddings.
- Semantic search with vector similarity.
- Custom filters with indexed fields.
- Importance weighting (0–1).
- Chunk context for surrounding text.
- Graceful migrations for entries/namespaces.

### RAG Strategies
- Prompt-based RAG: always search and inject context.
- Tool-based RAG: LLM decides when to search; tool returns context.

### Ingestion Tips
- PDFs: You SHOULD prefer client-side parsing (pdf.js).
- Images: You SHOULD use LLM to extract text/description.
- Text: You SHOULD chunk or normalize for better embeddings.

### Best Practices
- You MUST keep namespaces scoped to users/teams.
- You SHOULD use filters to limit search to relevant subsets.
- You SHOULD set `vectorScoreThreshold` to avoid low-signal context.

</rules>
