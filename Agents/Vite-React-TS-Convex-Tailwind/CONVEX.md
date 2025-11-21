# Convex.md

Definition file for AI agents working on a Convex app.

This file describes **how to write, organize and use Convex code**.  
If something isn’t covered in detail, follow the linked docs rather than guessing.

- Full docs: https://docs.convex.dev/
- AI / agents & rules: https://docs.convex.dev/ai
- Convex llms.txt (rules overview): https://www.convex.dev/llms.txt

---

## 1. Mental model

- Convex is a **reactive, transactional database + server function runtime**, all in TypeScript.
- The backend lives in the `convex/` directory. Client code typically lives in `src/`.
- **No SQL, no ORMs.** All reads/writes go through `ctx.db` inside Convex functions.
- Data sync, caching, realtime updates, and transactions are handled by Convex.
- Functions are **file-routed**: file path + export name ⇒ function reference used in `api.*` or `internal.*`.

Read “The Zen of Convex” for architectural principles:  
(https://docs.convex.dev/understanding/zen)

---

## 2. Project structure (server side)

Assume a standard project layout:

- `convex/schema.ts` – schema and indexes.
- `convex/*.ts` – server functions (queries, mutations, actions, http, crons, etc).
- `convex/http.ts` – HTTP routes via `httpRouter` and `httpAction`.
- `convex/crons.ts` – cron jobs via `cronJobs`.
- `convex/_generated/api.ts` – auto-generated `api` and `internal` function references.
- `convex/_generated/server.ts` – imports for `query`, `mutation`, `action`, `internalQuery`, etc.
- `convex/_generated/dataModel.d.ts` – `Doc<T>`, `Id<T>`, etc.

Do **not** edit `_generated/*` files; they are created and updated by `npx convex dev` or `npx convex codegen`.

---

## 3. Function types & registration

### 3.1 Always use the “new function syntax”

- Functions are declared with an options object:

~~~ts
import { query } from "./_generated/server";
import { v } from "convex/values";

export const example = query({
  args: { name: v.string() },
  returns: v.string(),
  handler: async (ctx, args) => {
    return "Hello " + args.name;
  },
});
~~~

Rules:

- **Always** provide `args` with validators from `convex/values`.
- **Always** provide `returns` with a validator, including `v.null()` when returning `null`.
- If the TS implementation doesn’t explicitly return, Convex returns `null`. Prefer explicit `return null`.

Reference: function docs (https://docs.convex.dev/functions)

### 3.2 Public vs internal functions

Imports:

- Public: `query`, `mutation`, `action` from `./_generated/server`.
- Internal (private): `internalQuery`, `internalMutation`, `internalAction` from `./_generated/server`.

Rules:

- Public functions are part of your **public API** and reachable via the internet and clients.
- Internal functions are **only callable from other Convex functions**, via `internal.*` references.
- Do **not** expose sensitive logic or system operations via public functions; use internal ones.

### 3.3 Function references

- Convex uses **file-based routing**:

  - File `convex/example.ts`, export `f` (public) ⇒ `api.example.f`
  - File `convex/example.ts`, export `g` via `internalQuery` ⇒ `internal.example.g`
  - Nested file `convex/messages/access.ts`, export `h` ⇒ `api.messages.access.h` or `internal.messages.access.h`.

- Use these typed references for:
  - Client calls (`api.example.f` via generated clients/hooks).
  - Server-to-server calls via `ctx.runQuery`, `ctx.runMutation`, `ctx.runAction`.

Never pass bare function implementations into `ctx.runQuery` / `ctx.runMutation` / `ctx.runAction`. Always use `api.*` or `internal.*` references.

---

## 4. Calling functions from server code

From inside another Convex function:

- `ctx.runQuery(api.some.file.fn, args)`
- `ctx.runMutation(api.some.file.fn, args)`
- `ctx.runAction(api.some.file.fn, args)`

Rules:

- Use `ctx.runQuery` for queries, `ctx.runMutation` for mutations, `ctx.runAction` for actions.
- Avoid chains of many server calls inside actions; prefer fewer, well-scoped operations to reduce race conditions.
- When calling a function in the **same file**, add explicit return type annotations on the variable receiving the result to avoid TS circularity issues.

Example pattern:

~~~ts
export const getGreeting = query({
  args: { name: v.string() },
  returns: v.string(),
  handler: async (ctx, args) => "Hello " + args.name,
});

export const logGreeting = query({
  args: {},
  returns: v.null(),
  handler: async (ctx, args) => {
    const greeting: string = await ctx.runQuery(api.example.getGreeting, {
      name: "Bob",
    });
    console.log(greeting);
    return null;
  },
});
~~~

---

## 5. Validators & types

Use `v.*` from `convex/values` for **all** arguments and return types, and in `schema.ts`.

Common validators:

- Scalars: `v.string()`, `v.boolean()`, `v.number()`, `v.int64()`, `v.null()`, `v.bytes()`.
- Collections: `v.array(inner)`, `v.object({...})`, `v.record(keyValidator, valueValidator)`, `v.union(...)`, `v.optional(inner)`.
- IDs: `v.id("tableName")` or `v.id("_storage")` for file IDs.

Rules:

- Use `v.int64()` for 64-bit integers (not `v.bigint()`).
- Use `v.null()` whenever a function purposely returns `null`.
- `undefined` is **not** a valid Convex value. Never rely on `undefined` for stored data or return values.
- When using `Record`, keep keys as ASCII, non-empty, not starting with `_` or `$`.

Data model types (from `_generated/dataModel`):

- `Doc<"tableName">` – document type for a table.
- `Id<"tableName">` – type-safe ID for a table.

Always accept IDs as `Id<"tableName">`, not raw `string`.

---

## 6. Schema & database

### 6.1 Schema definition

- Define schema in `convex/schema.ts` with `defineSchema` and `defineTable` from `convex/server`.

Example sketch:

~~~ts
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    name: v.string(),
    email: v.string(),
  }).index("by_email", ["email"]),

  messages: defineTable({
    channelId: v.id("channels"),
    authorId: v.optional(v.id("users")),
    content: v.string(),
  }).index("by_channel", ["channelId"]),
});
~~~

Rules:

- System fields `_id` (`v.id(tableName)`) and `_creationTime` (`v.number()`) are added automatically.
- Index naming: include all fields in the index name: e.g. `"by_field1_and_field2"`.
- Index order matters. If queries need both `(field1, field2)` and `(field2, field1)`, define two indexes.

Schema docs: https://docs.convex.dev/database

### 6.2 Querying data via `ctx.db`

Basic operations:

- `ctx.db.query("table")` – start a query.
- `ctx.db.get(id)` – get single document by ID.
- `ctx.db.insert("table", doc)` – insert.
- `ctx.db.patch(id, partial)` – shallow update.
- `ctx.db.replace(id, doc)` – replace completely.
- `ctx.db.delete(id)` – delete one document.

Use indexes for performance:

- `withIndex("indexName", (q) => q.eq("field", value))`
- `withSearchIndex("indexName", (q) => ...)` for full text search.

**Important**: Do **not** use `filter` on large tables for production queries. Instead:

- Define appropriate indexes in `schema.ts`.
- Use `.withIndex(...)` in queries.

Ordering:

- Default ordering: ascending `_creationTime`.
- `.order("asc")` / `.order("desc")` to override.
- Index-based queries are ordered by index fields.

Pagination:

- Use `paginationOptsValidator` and `.paginate(opts)` to implement cursor-based pagination.
- Result has `{ page, isDone, continueCursor }`.

Async iteration:

- For streaming-like queries, use `for await (const row of query)` rather than `.collect()` on large sets.

---

## 7. Queries, mutations, actions

### 7.1 Queries

- Read-only, transactional, fast.
- Used for **almost all reads**.
- Should complete quickly and touch at most a few hundred rows where possible.
- Automatically cached and reactive; changes propagate to clients bound to query results.

Best practice: small results, index-backed, deterministic logic.

### 7.2 Mutations

- Write transactions. All reads/writes inside a mutation happen atomically.
- Use for inserting, updating, deleting data via `ctx.db`.
- Use `ctx.db.patch` for partial updates, `ctx.db.replace` for full replacement.
- Avoid heavy logic that touches thousands of documents in a single mutation; consider actions + workflow instead.

### 7.3 Actions

- Long-running / external-API / background jobs.
- Can use Node built-ins if file starts with `"use node";`.
- **Actions do not have direct database access** (no `ctx.db`).
  - Use `ctx.runQuery` / `ctx.runMutation` inside actions to interact with the database.
- Use actions sparingly; if a query or mutation suffices, prefer them.
- Don’t call actions directly from the browser in most patterns:
  - Instead, call a mutation that writes a record and then **schedules** an action or triggers workflows.

Action docs: https://docs.convex.dev/functions/actions

---

## 8. HTTP endpoints

- Implement in `convex/http.ts` using `httpRouter` and `httpAction` from `convex/server` / `./_generated/server`.

Sketch:

~~~ts
import { httpRouter } from "convex/server";
import { httpAction } from "./_generated/server";

const http = httpRouter();

http.route({
  path: "/echo",
  method: "POST",
  handler: httpAction(async (ctx, req) => {
    const body = await req.bytes();
    return new Response(body, { status: 200 });
  }),
});

export default http;
~~~

Rules:

- `path` is the **exact** path where the endpoint is exposed (`/api/someRoute` ⇒ that exact URL).
- Handler uses standard `Request` / `Response` objects.

HTTP docs: https://docs.convex.dev/http-api

---

## 9. Scheduling (crons)

- Define in `convex/crons.ts` using `cronJobs()` from `convex/server`.

Sketch:

~~~ts
import { cronJobs } from "convex/server";
import { internal } from "./_generated/api";
import { internalAction } from "./_generated/server";

const crons = cronJobs();

const doCleanup = internalAction({
  args: {},
  returns: v.null(),
  handler: async (ctx, args) => {
    // cleanup logic
    return null;
  },
});

// Run every 2 hours
crons.interval("cleanup", { hours: 2 }, internal.crons.doCleanup, {});

export default crons;
~~~

Rules:

- Use `crons.interval` or `crons.cron` (not deprecated helpers like `crons.daily`).
- Cron targets are **FunctionReference**s (e.g. `internal.crons.doCleanup`), not raw functions.
- You can define Convex functions in `crons.ts` as in any other server file.

Scheduling docs: https://docs.convex.dev/scheduling

---

## 10. File storage

- Convex stores large objects (images, PDFs, etc.) using file storage APIs and the `_storage` system table.

Key APIs:

- Uploading from clients via generated upload URLs (see docs).
- `ctx.storage.getUrl(fileId)` – returns a signed `https://` URL or `null` if file not found.
- To inspect metadata, query `_storage` via `ctx.db.system` rather than deprecated APIs.

Sketch:

~~~ts
import { query } from "./_generated/server";
import { v } from "convex/values";
import { Id } from "./_generated/dataModel";

type FileMetadata = {
  _id: Id<"_storage">;
  _creationTime: number;
  contentType?: string;
  sha256: string;
  size: number;
};

export const getFileMetadata = query({
  args: { fileId: v.id("_storage") },
  returns: v.null(),
  handler: async (ctx, args) => {
    const metadata: FileMetadata | null =
      await ctx.db.system.get(args.fileId);
    console.log(metadata);
    return null;
  },
});
~~~

- Storage values are `Blob`s; convert to/from `ArrayBuffer`/`Blob` as needed.

File storage docs: https://docs.convex.dev/file-storage

---

## 11. Search & vector search

Convex provides:

- **Full text search** via `withSearchIndex`.
- **Vector search** capabilities (see RAG / search docs).

Sketch for full-text search:

~~~ts
const messages = await ctx.db
  .query("messages")
  .withSearchIndex("search_body", (q) =>
    q.search("body", "hello hi").eq("channel", "#general"),
  )
  .take(10);
~~~

Search docs: https://docs.convex.dev/search  
RAG guide: https://www.convex.dev/can-do/rag

---

## 12. Authentication

- Convex can integrate with auth providers or use built-in auth.
- Typical pattern: use provider-specific setup (Clerk, Auth0, etc.) and rely on Convex auth APIs to resolve user identity in server functions.

Auth docs: https://docs.convex.dev/authentication

When writing AI-generated code, do not invent auth flows; follow provider quickstart guides.

---

## 13. Client usage patterns

Depending on the client framework (React, Next.js, etc.), use the corresponding client library:

Docs: https://docs.convex.dev/client

### 13.1 React example (pattern)

- Wrap app with `ConvexProvider`.
- Use generated hooks such as `useQuery(api.file.fn, args)` and `useMutation(api.file.fn)`.

AI agent rules:

- Don’t manually wire WebSockets or custom caches. Use the official client APIs and let Convex handle sync.

---

## 14. Agent-mode & external AI coding agents

For remote AI coding agents (e.g. Codex, Jules, Devin, background IDE agents):

- Use Convex **Agent Mode** to limit permissions:

Example setup script:

~~~bash
npm i
CONVEX_AGENT_MODE=anonymous npx convex dev --once
~~~

Or with Bun:

~~~bash
bun i
CONVEX_AGENT_MODE=anonymous bun x convex dev --once
~~~

- This lets the agent run `convex dev` with limited privileges while iterating on code, running tests, and calling functions.

AI & agents docs: https://docs.convex.dev/ai

---

## 15. Best practices & pitfalls

When generating Convex code, follow these constraints:

1. **Always** use `query` / `mutation` / `action` / `internal*` from `./_generated/server` with the new syntax.
2. **Always** define `args` and `returns` with validators from `convex/values`.
3. Use `v.null()` explicitly when a function returns `null`.
4. Use `Id<"table">` and `v.id("table")` for IDs instead of `string`.
5. Use indexes and `withIndex` / `withSearchIndex`, avoid `.filter()` on large tables.
6. Keep queries and mutations fast and scoped to a small number of records whenever possible.
7. Use actions for external APIs and long-running workflows; never call `ctx.db` in an action.
8. Put schema in `convex/schema.ts` and let Convex generate `_generated/*` files.
9. For scheduled jobs, use `cronJobs()` in `convex/crons.ts` with function references.
10. Prefer writing “just TypeScript” helper functions for shared logic between queries/mutations/actions instead of duplicating logic.

If in doubt:

- Search the docs: https://docs.convex.dev/
- Prefer **simpler, index-backed, deterministic** server code.

---
