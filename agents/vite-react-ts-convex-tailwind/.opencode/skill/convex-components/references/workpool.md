# Workpool Component (Extensive)

Sources:
- https://convex.dev/components/workpool
- https://www.npmjs.com/package/@convex-dev/workpool

## Install and Configure

```bash
npm install @convex-dev/workpool
```

`convex/convex.config.ts`:

```ts
import { defineApp } from "convex/server";
import workpool from "@convex-dev/workpool/convex.config.js";

const app = defineApp();
app.use(workpool, { name: "emailWorkpool" });
app.use(workpool, { name: "scrapeWorkpool" });
export default app;
```

Instantiate:

```ts
import { Workpool } from "@convex-dev/workpool";
import { components } from "./_generated/api";

const emailPool = new Workpool(components.emailWorkpool, {
  maxParallelism: 10,
  retryActionsByDefault: true,
  defaultRetryBehavior: { maxAttempts: 3, initialBackoffMs: 1000, base: 2 },
});
```

## Enqueue Work

```ts
await emailPool.enqueueAction(ctx, internal.email.send, args, {
  retry: false,
  onComplete: internal.email.onComplete,
  context: { userId: args.userId },
});
```

Batching:

```ts
await emailPool.enqueueActionBatch(ctx, internal.weather.scrape, [
  { city: "New York" },
  { city: "Chicago" },
]);
```

## Retry Semantics

- Exponential backoff with jitter.
- Only enable retries for idempotent actions.
- Per-call override with `retry: true/false/custom`.

## Completion Handling

```ts
export const onComplete = emailPool.defineOnComplete<DataModel>({
  context: v.object({ userId: v.id("users") }),
  handler: async (ctx, { context, result }) => {
    if (result.kind === "success") {
      await ctx.db.insert("emailLog", { userId: context.userId });
    }
  },
});
```

## Status and Monitoring

```ts
import { vWorkIdValidator } from "@convex-dev/workpool";

export const getStatus = query({
  args: { id: vWorkIdValidator },
  handler: async (ctx, args) => await emailPool.status(args.id),
});
```

- `statusTtl` controls retention (use `Infinity` for permanent).
- Status kinds: `pending`, `running`, `finished`.

## Parallelism Guidance

- Avoid >20 on free tier, >100 on Pro across workpools/workflows.
- Use low parallelism to reduce OCC conflicts.

## Cancellation

- `pool.cancel(id)` or `pool.cancelAll()` stops queued/retry work.
