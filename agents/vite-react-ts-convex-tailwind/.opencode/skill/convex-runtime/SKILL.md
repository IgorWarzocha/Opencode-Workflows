---
name: convex-runtime
description: |-
  Implement Convex runtime features: HTTP actions, file storage, search (full text + vector),
  scheduling (crons + scheduled functions), and RAG patterns. Use for webhooks, uploads,
  search indexes, vectorSearch actions, and background workflows. Use proactively when users
  mention HTTP endpoints, files, search, embeddings, or cron/schedule.
  
  Examples:
  - user: "Add full text search" → define searchIndex + withSearchIndex query
  - user: "Upload files" → generate upload URL and persist storageId
  - user: "Vector search" → action with ctx.vectorSearch and doc fetch
  - user: "Run cleanup nightly" → cronJobs + function reference
---

<overview>
Implement Convex runtime features: HTTP actions, file storage, search (full text + vector), and scheduling.
</overview>

<reference>
- **HTTP actions**: https://docs.convex.dev/functions/http-actions
- **File storage**: https://docs.convex.dev/file-storage
- **Uploading files**: https://docs.convex.dev/file-storage/upload-files
- **Serving files**: https://docs.convex.dev/file-storage/serve-files
- **File metadata**: https://docs.convex.dev/file-storage/file-metadata
- **Full text search**: https://docs.convex.dev/search/text-search
- **Vector search**: https://docs.convex.dev/search/vector-search
- **Scheduling**: https://docs.convex.dev/scheduling
- **Scheduled functions**: https://docs.convex.dev/scheduling/scheduled-functions
- **Cron jobs**: https://docs.convex.dev/scheduling/cron-jobs
</reference>

<context name="Runtime Concepts">
- Full text search: `searchIndex` with `searchField` and optional `filterFields`; relevance-ordered; prefix matching on final term; fuzzy matches are deprecated; limits 16 terms, 8 filters, 1024 scanned.
- Vector search: `vectorIndex` with `vectorField` and `dimensions` (2-4096); vector field is `v.array(v.float64())`; actions-only; limits 256 results, 64 filters, 4 vector indexes per table.
- Scheduling: scheduled functions are durable and stored in DB; cron jobs run on fixed schedules; auth not propagated, You MUST pass identity explicitly.
- File storage: upload URLs for large files; HTTP action uploads limited to 20MB; metadata in `_storage`.
</context>

<rules>

### Runtime Operations
- HTTP actions: define handlers with `httpAction`, register in `convex/http.ts` via `httpRouter` (default export REQUIRED).
- HTTP Syntax:
  ```ts
  http.route({
    path: "/api/echo", // Exact path
    method: "POST",
    handler: httpAction(async (ctx, req) => {
      const body = await req.bytes();
      return new Response(body, { status: 200 });
    }),
  });
  ```
- HTTP actions MUST be exposed at `https://<deployment>.convex.site`.
- Upload URL flow: generate URL mutation → client POST → store `storageId`; URLs expire after 1 hour.
- HTTP upload flow: `ctx.storage.store(blob)` then mutation. Uploads via HTTP actions are limited to 20MB.
- Serving files: `ctx.storage.getUrl(storageId)` in queries/mutations; returns signed URL or `null`.
- File metadata: `ctx.db.system.get("_storage", id)` or `query("_storage")`; `storage.getMetadata()` is deprecated.
- Scheduling: `ctx.scheduler.runAfter/runAt`; cron jobs in `convex/crons.ts` using `cronJobs()`.
- Cron Scheduling: You MUST use `crons.interval` or `crons.cron`. You MUST NOT use deprecated helpers like `crons.hourly`, `crons.daily`, or `crons.weekly`.
- Cron internal calls: If a cron calls an internal function, You MUST import the `internal` object from `_generated/api` to reference it, even if defined in the same file.

### Core Rules
- HTTP actions MUST be routed only via `convex/http.ts` default export.
- HTTP actions MUST parse `Request` manually as they do not support validators.
- Search Example:
  ```ts
  const messages = await ctx.db.query("messages")
    .withSearchIndex("search_body", (q) =>
      q.search("body", "hello hi").eq("channel", "#general")
    ).take(10);
  ```
- Vector search MUST be actions-only; results are non-reactive.
- Search behavior: full text search is relevance-ordered and uses prefix matching on the final term; fuzzy matches are deprecated.
- You SHOULD prefer search/vector filters in index definitions and query filters.
- Scheduled functions MUST remain backward compatible with args.

</rules>
