---
name: convex-components
description: |-
  Use Convex Components to add isolated backend features and compose component APIs.
  Use for installing components, calling component APIs, authoring components, and
  handling component-specific constraints (Id types, env vars, pagination, auth).
  Use proactively when users mention components, workpool, workflow, agent component,
  or reusable backend modules.
  
  Examples:
  - user: "Install the Agent component" → add convex.config.ts + use() + components API
  - user: "Call component functions" → ctx.runQuery(components.foo.bar, args)
  - user: "Build a component" → defineComponent, schema, _generated, packaging
  - user: "Expose component API to clients" → re-export functions with auth
---
# Convex Components

## Authoritative Sources

- Components overview: https://docs.convex.dev/components
- Understanding: https://docs.convex.dev/components/understanding
- Using: https://docs.convex.dev/components/using
- Authoring: https://docs.convex.dev/components/authoring
- Directory: https://convex.dev/components

## Mental Model

- Components are isolated mini backends with their own schema, tables, file storage, and functions.
- Components cannot access app tables/functions/env unless passed explicitly.
- Calls into components are transactional with the caller, but component mutations are sub-transactions.

## Component References (Extensive)

- `references/agent.md` — Agent component: threads/messages, streaming, tools, context, debugging, usage tracking, and install/setup.
- `references/rag.md` — RAG component: namespaces, add/search/generateText, filters, chunking, prompt vs tool RAG.
- `references/workpool.md` — Workpool component: enqueue, retries, onComplete, parallelism, batching, monitoring.
- `references/workflow.md` — Workflow component: durable steps, events, retries, status, cancel/cleanup, limits.

## Installing Components

- Install package: `npm i @convex-dev/<component>`.
- Add `convex/convex.config.ts`:
  - `import { defineApp } from "convex/server";`
  - `app.use(component)`; use `app.use(component, { name: "custom" })` for multiple instances.
- Run `npx convex dev` to generate component code.
- Access via `components.<name>` in `convex/_generated/api`.

## Calling Component APIs

- Use `ctx.runQuery/Mutation/Action` with `components.<name>.<fn>`.
- Public component functions become internal references; not callable directly from clients.
- Queries remain reactive; mutations are transactional.

## Transaction Semantics

- Top-level mutation commits all writes across components together.
- If a component mutation throws, only its writes are rolled back; caller can catch and continue.

## Component API Differences

- `components.<name>` exposes only public component functions.
- `Id` types cross boundaries as `string`; cannot use `v.id("table")` for external tables.
- Each component has its own `_generated` directory; use the app's `components` references.

## Environment Variables

- Components cannot access `process.env` directly.
- Pass env values as arguments from the app, or store config in a component table.

## HTTP Actions

- Components cannot expose routes directly; app must mount handlers in `convex/http.ts`.

## Auth in Components

- `ctx.auth` is not available inside component functions.
- Authenticate in the app and pass identifiers (userId) to component functions.

## Pagination

- Built-in `.paginate()` is not supported inside components.
- Use `convex-helpers` paginator and `usePaginatedQuery` from convex-helpers if needed.

## Authoring Components

- Component folder includes `convex.config.ts`, `schema.ts`, functions, `_generated`.
- `defineComponent("name")` defines component; use `component.use(...)` for child components.
- Local components can live in `convex/components/` or any folder.
- NPM components should export:
  - `@pkg/convex.config.js`
  - `@pkg/_generated/component.js`
  - `@pkg/test` helpers

## Function Handles

- Use `createFunctionHandle(api.foo.bar)` to pass callbacks across boundaries.
- Handles are strings; use `v.string()` validators and cast back to `FunctionHandle`.

## Testing Components

- Register component with `convex-test` using component schema/modules or provided test helpers.
- For component packages, use `@pkg/test` register helper.

## Best Practices

- Always validate args/returns on public component functions.
- Prefer app-level wrappers to add auth/rate limiting when re-exporting component APIs.
- Use a single-row globals/config table for static configuration.
