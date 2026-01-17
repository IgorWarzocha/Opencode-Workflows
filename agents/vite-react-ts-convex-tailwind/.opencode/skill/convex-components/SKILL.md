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

<overview>
Use Convex Components to add isolated backend features and compose component APIs.
</overview>

<reference>
- **Components overview**: https://docs.convex.dev/components
- **Understanding**: https://docs.convex.dev/components/understanding
- **Using**: https://docs.convex.dev/components/using
- **Authoring**: https://docs.convex.dev/components/authoring
- **Directory**: https://convex.dev/components
</reference>

<context name="Component References">
You SHOULD consult these reference files for specific component knowledge:
- `references/agent.md` — Agent component: threads/messages, streaming, tools, context, debugging, usage tracking, and install/setup.
- `references/rag.md` — RAG component: namespaces, add/search/generateText, filters, chunking, prompt vs tool RAG.
- `references/workpool.md` — Workpool component: enqueue, retries, onComplete, parallelism, batching, monitoring.
- `references/workflow.md` — Workflow component: durable steps, events, retries, status, cancel/cleanup, limits.
</context>

<rules>

### Mental Model
- Components are isolated mini backends with their own schema, tables, file storage, and functions.
- Components MUST NOT access app tables/functions/env unless passed explicitly.
- Calls into components are transactional with the caller, but component mutations are sub-transactions.

### Installing Components
- Install package: `npm i @convex-dev/<component>`.
- Add `convex/convex.config.ts`:
  - `import { defineApp } from "convex/server";`
  - `app.use(component)`; use `app.use(component, { name: "custom" })` for multiple instances.
- You MUST run `npx convex dev` to generate component code.
- Access via `components.<name>` in `convex/_generated/api`.

### Calling Component APIs
- Use `ctx.runQuery/Mutation/Action` with `components.<name>.<fn>`.
- Public component functions MUST NOT be called directly from clients (they are internal references).
- Queries remain reactive; mutations are transactional.

### Transaction Semantics
- Top-level mutation commits all writes across components together.
- If a component mutation throws, only its writes are rolled back; the caller MAY catch and continue.

### Component API Differences
- `components.<name>` exposes ONLY public component functions.
- `Id` types cross boundaries as `string`; You MUST NOT use `v.id("table")` for external tables.
- Each component has its own `_generated` directory; You MUST use the app's `components` references.

### Environment Variables
- Components MUST NOT access `process.env` directly.
- You MUST pass env values as arguments from the app, or store config in a component table.

### HTTP Actions
- Components MUST NOT expose routes directly; app MUST mount handlers in `convex/http.ts`.

### Auth in Components
- `ctx.auth` is NOT available inside component functions.
- You MUST authenticate in the app and pass identifiers (userId) to component functions.

### Pagination
- Built-in `.paginate()` is NOT supported inside components.
- You SHOULD use `convex-helpers` paginator and `usePaginatedQuery` from convex-helpers if needed.

### Authoring Components
- Component folder MUST include `convex.config.ts`, `schema.ts`, functions, and `_generated`.
- `defineComponent("name")` defines component; use `component.use(...)` for child components.
- Local components MAY live in `convex/components/` or any folder.
- NPM components SHOULD export:
  - `@pkg/convex.config.js`
  - `@pkg/_generated/component.js`
  - `@pkg/test` helpers

### Function Handles
- You SHOULD use `createFunctionHandle(api.foo.bar)` to pass callbacks across boundaries.
- Handles are strings; use `v.string()` validators and cast back to `FunctionHandle`.

### Testing Components
- You SHOULD register component with `convex-test` using component schema/modules or provided test helpers.
- For component packages, You SHOULD use `@pkg/test` register helper.

### Best Practices
- You MUST always validate args/returns on public component functions.
- You SHOULD prefer app-level wrappers to add auth/rate limiting when re-exporting component APIs.
- You SHOULD use a single-row globals/config table for static configuration.

</rules>
