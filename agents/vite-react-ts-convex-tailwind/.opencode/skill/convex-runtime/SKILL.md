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
# Convex Runtime

## Scope

HTTP actions, file storage, search/RAG, and scheduling.

## Authoritative Sources

- HTTP actions: https://docs.convex.dev/functions/http-actions
- File storage: https://docs.convex.dev/file-storage
- Uploading files: https://docs.convex.dev/file-storage/upload-files
- Serving files: https://docs.convex.dev/file-storage/serve-files
- File metadata: https://docs.convex.dev/file-storage/file-metadata
- Full text search: https://docs.convex.dev/search/text-search
- Vector search: https://docs.convex.dev/search/vector-search
- Scheduling: https://docs.convex.dev/scheduling
- Scheduled functions: https://docs.convex.dev/scheduling/scheduled-functions
- Cron jobs: https://docs.convex.dev/scheduling/cron-jobs

## Runtime Concepts

- Full text search: `searchIndex` with `searchField` and optional `filterFields`; relevance-ordered; prefix matching on final term; limits 16 terms, 8 filters, 1024 scanned.
- Vector search: `vectorIndex` with `vectorField` and `dimensions` (2-4096); vector field is `v.array(v.float64())`; actions-only; limits 256 results, 64 filters, 4 vector indexes per table.
- Scheduling: scheduled functions are durable and stored in DB; cron jobs run on fixed schedules; auth not propagated, pass identity explicitly.
- File storage: upload URLs for large files; HTTP action uploads limited to 20MB; metadata in `_storage`.

## Runtime Operations

- HTTP actions: define handlers with `httpAction`, register in `convex/http.ts` via `httpRouter` (default export required); parse `Request` manually; add CORS headers and `OPTIONS` preflight.
- HTTP actions exposed at `https://<deployment>.convex.site`.
- Upload URL flow: generate URL mutation → client POST → store `storageId`; URLs expire after 1 hour.
- HTTP upload flow: `ctx.storage.store(blob)` then mutation.
- Serving files: `ctx.storage.getUrl(storageId)` in queries/mutations; controlled access via HTTP action + `ctx.storage.get(storageId)`.
- File metadata: `ctx.db.system.get("_storage", id)` or `query("_storage")`; `storage.getMetadata()` deprecated.
- Scheduling: `ctx.scheduler.runAfter/runAt`; cron jobs in `convex/crons.ts` using `cronJobs()`; cron runs may skip if previous run overlaps.

## Core Rules

- HTTP actions are routed only via `convex/http.ts` default export.
- HTTP actions do not support validators; parse `Request` manually.
- HTTP actions exposed at `https://<deployment>.convex.site`.
- Vector search is actions-only; results are non-reactive.
- Prefer search/vector filters in index definitions and query filters.
- Scheduled functions must remain backward compatible with args.
