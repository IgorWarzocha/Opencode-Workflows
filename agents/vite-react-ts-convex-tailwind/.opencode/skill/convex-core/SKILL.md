---
name: convex-core
description: |-
  Build Convex schemas, queries, mutations, actions, and client usage with strict validators and indexes.
  Use for data modeling, function authoring, argument/return validation, and performance guidance.
  Use proactively when work touches convex/schema.ts, functions, or api.* references.
  
  Examples:
  - user: "Design tables for multi-tenant app" → defineSchema/defineTable with indexes
  - user: "Write a mutation" → args/returns validators + auth checks
  - user: "Optimize query" → add index and withIndex range expression
  - user: "Use useQuery" → show generated hook usage
---
# Convex Core

## Scope

Core Convex modeling and function authoring patterns. Use as the default baseline for Convex work.

## Authoritative Sources

- Schemas: https://docs.convex.dev/database/schemas
- Reading data + indexes: https://docs.convex.dev/database/reading-data/indexes
- Validation: https://docs.convex.dev/functions/validation
- Functions: https://docs.convex.dev/functions
- Pagination: https://docs.convex.dev/database/pagination
- System tables: https://docs.convex.dev/database/advanced/system-tables

## Core Concepts

- Schema: `defineSchema`/`defineTable` in `convex/schema.ts`; use `v` validators.
- Options: `schemaValidation: false` disables runtime validation; `strictTableNameTypes: false` allows undeclared tables in TS types.
- Validation: `args`/`returns` validators for queries/mutations/actions; objects reject extra props; `undefined` invalid (use `null`).
- Validator composition: `Infer`, `.pick`, `.omit`, `.extend`, `.partial` on object validators.
- Function types: `query` (reactive reads), `mutation` (atomic writes), `action` (external/long-running, no `ctx.db`).
- Internal functions are private; call via `internal.*` references.

## Core Operations

- Indexing: `.index(name, [fields...])`; `_creationTime` appended; 16 fields per index, 32 indexes per table; staged indexes for large tables.
- Querying: prefer `.withIndex` over `.filter` for large tables; range-less `withIndex` must pair with `take/first/unique/paginate`.
- Limits: `collect()` throws if >1024 docs; use `take` or pagination.
- Pagination: `paginationOptsValidator`, `.paginate()` returns `{ page, isDone, continueCursor }`, pages are reactive; avoid strict `returns` on the full paginate object.
- System tables: `_storage` and `_scheduled_functions` via `db.system.get/query`, reactive + paginatable.

## Schema Rules

- Define all tables in `convex/schema.ts` with `defineSchema` / `defineTable`.
- Use `v.*` validators for every field; avoid `v.any()` unless necessary.
- Index rules:
  - Use `.index(name, [fields...])`.
  - Field order matters; range expressions must follow index order.
  - Limits: 16 fields per index, 32 indexes per table.

## Function Rules

- Use new function syntax with `args`, `returns`, `handler`.
- Always validate `args` and `returns` (HTTP actions excluded).
- Use `query` for reads, `mutation` for writes, `action` for external/long-running.
- Actions cannot access `ctx.db`; use `ctx.runQuery` / `ctx.runMutation`.

## Query Performance

- Prefer `.withIndex` over `.filter` on large tables.
- If using `.withIndex` without a range, always pair with `take`, `first`, `unique`, or `paginate`.
- `collect()` throws if more than 1024 docs; prefer `take` or pagination.

## Pagination

- Use `paginationOptsValidator` in args.
- `.paginate()` returns `{ page, isDone, continueCursor }`.
- Pages are reactive; size can change.
- Avoid strict `returns` validators for full paginate result.

## Client Patterns

- Use `api.*` references from `convex/_generated/api`.
- React hooks: `useQuery`, `useMutation`, `useAction`, `usePaginatedQuery`.
- Never call mutations in render paths.

## Safety

- Enforce auth per function; check identity via `ctx.auth` helpers.
- Do not expose sensitive logic in public functions; use internal ones.
