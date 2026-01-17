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

<overview>
Core Convex modeling and function authoring patterns. This skill is the default baseline for Convex work.
</overview>

<reference>
- **Schemas**: https://docs.convex.dev/database/schemas
- **Reading data + indexes**: https://docs.convex.dev/database/reading-data/indexes
- **Validation**: https://docs.convex.dev/functions/validation
- **Functions**: https://docs.convex.dev/functions
- **Pagination**: https://docs.convex.dev/database/pagination
- **System tables**: https://docs.convex.dev/database/advanced/system-tables
</reference>

<context name="Core Concepts">
- Schema: `defineSchema`/`defineTable` in `convex/schema.ts`; use `v` validators.
- Options: `schemaValidation: false` disables runtime validation; `strictTableNameTypes: false` allows undeclared tables in TS types.
- Validation: `args`/`returns` validators for queries/mutations/actions; objects reject extra props; `undefined` is invalid (use `null`).
- Discriminated Unions: Use `v.union` and `v.literal` with `as const` for type-safe state/kind definitions.
- Types: Use `v.int64()` for 64-bit integers (not `v.bigint()`); `v.null()` for explicit null returns.
- IDs: Use `Id<"table">` and `v.id("table")` instead of raw strings.
- Records: `v.record(keys, values)` keys MUST be ASCII, non-empty, and NOT start with `_` or `$`.
- Validator composition: `Infer`, `.pick`, `.omit`, `.extend`, `.partial` on object validators.
</context>

<rules>

### Schema Rules
- You MUST define all tables in `convex/schema.ts` with `defineSchema` / `defineTable`.
- System Fields: `_id` (`v.id(tableName)`) and `_creationTime` (`v.number()`) are added automatically.
- You MUST use `v.*` validators for every field; SHOULD avoid `v.any()` unless necessary.
- Index naming: include all fields in the name, e.g., `"by_field1_and_field2"`.
</rules>
- Index rules:
  - You MUST use `.index(name, [fields...])`.
  - Field order matters; range expressions MUST follow index order.
  - Limits: 16 fields per index, 32 indexes per table.

### Function Rules
- You MUST use new function syntax with `args`, `returns`, and `handler`.
- You MUST always validate `args` and `returns` (HTTP actions excluded).
- Use `query` for reads, `mutation` for writes, and `action` for external/long-running.
- Actions MUST NOT access `ctx.db`; You MUST use `ctx.runQuery` / `ctx.runMutation`.
- Circular Dependencies: When calling a function in the same file via `ctx.run*`, You MUST add explicit return type annotations to the receiver variable.

### Database Operations
- You MUST provide the explicit table name as the first argument to `ctx.db.get`, `ctx.db.patch`, `ctx.db.replace`, and `ctx.db.delete`.
- Replacement: Use `ctx.db.replace` for full document replacement (throws if missing).
- Patching: Use `ctx.db.patch` for shallow merge updates (throws if missing).
- Deletion: Convex queries do NOT support `.delete()`. You MUST `.collect()` results and iterate to call `ctx.db.delete(id)`.
- Unique: Use `.unique()` for single document results; it MUST throw if multiple documents match.
- You MUST NOT use `filter` in production queries; use indexes and `.withIndex`.

### TypeScript Best Practices
- You MUST use `as const` for string literals in discriminated unions.
- You MUST define arrays as `const array: Array<T> = [...]` and records as `const record: Record<K, V> = {...}`.
- You MUST prefer `Id<"table">` over `string` for all document identifiers.

### Query Performance
- You SHOULD prefer `.withIndex` over `.filter` on large tables.
- If using `.withIndex` without a range, You MUST pair it with `take`, `first`, `unique`, or `paginate`.
- Search limits: `collect()` throws if >1024 docs; You SHOULD use `take(n)`, `paginate()`, or `for await` iteration for large sets.
- Async iteration: Use `for await (const row of query)` instead of `.collect()` for streaming large result sets.

### Pagination
- You MUST use `paginationOptsValidator` in args.
- `.paginate()` returns `{ page, isDone, continueCursor }`.
- Pages are reactive; size MAY change.
- You SHOULD avoid strict `returns` validators for the full `.paginate()` result object; validate `page` or use `v.any()`.

### Client Patterns
- You MUST use `api.*` references from `convex/_generated/api`.
- React hooks: `useQuery`, `useMutation`, `useAction`, `usePaginatedQuery`.
- You MUST NOT call mutations or actions during render.

### Safety
- You MUST enforce auth per function; check identity via `ctx.auth` helpers.
- You MUST NOT expose sensitive logic in public functions; MUST use internal ones.

</rules>
