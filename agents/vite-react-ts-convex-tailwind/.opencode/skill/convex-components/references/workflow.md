# Workflow Component

<reference>
- https://convex.dev/components/workflow
- https://www.npmjs.com/package/@convex-dev/workflow
</reference>

<workflow>

### Install and Configure

```bash
npm install @convex-dev/workflow
```

`convex/convex.config.ts`:

```ts
import { defineApp } from "convex/server";
import workflow from "@convex-dev/workflow/convex.config.js";

const app = defineApp();
app.use(workflow);
export default app;
```

Instantiate:

```ts
import { WorkflowManager } from "@convex-dev/workflow";
import { components } from "./_generated/api";

export const workflow = new WorkflowManager(components.workflow, {
  workpoolOptions: { maxParallelism: 10, retryActionsByDefault: true },
});
```

### Define Workflows

```ts
export const userOnboarding = workflow.define({
  args: { userId: v.id("users") },
  handler: async (step, args): Promise<void> => {
    await step.runMutation(internal.emails.send, { userId: args.userId });
    await step.runAction(internal.llm.enrich, { userId: args.userId }, { retry: true });
    await step.runMutation(
      internal.emails.followUp,
      { userId: args.userId },
      { runAfter: 24 * 60 * 60 * 1000 },
    );
  },
});
```

### Start / Status / Cancel

```ts
const workflowId = await workflow.start(ctx, internal.userOnboarding, { userId });
const status = await workflow.status(ctx, workflowId);
await workflow.cancel(ctx, workflowId);
```

### Events

```ts
const approvalEvent = defineEvent({
  name: "approval",
  validator: v.object({ approved: v.boolean() }),
});

// Wait inside workflow
const approval = await step.awaitEvent(approvalEvent);

// Send from mutation/action
await workflow.sendEvent(ctx, { ...approvalEvent, workflowId, value: { approved: true } });
```

Dynamic events:

```ts
const eventId = await workflow.createEvent(ctx, { name: "userResponse", workflowId });
await step.awaitEvent({ id: eventId });
await workflow.sendEvent(ctx, { id: eventId, value: { ok: true } });
```

### onComplete Handling

```ts
import { vWorkflowId } from "@convex-dev/workflow";
import { vResultValidator } from "@convex-dev/workpool";

export const kickoff = mutation({
  handler: async (ctx) => {
    await workflow.start(ctx, internal.userOnboarding, { userId: "..." }, {
      onComplete: internal.workflows.onComplete,
      context: { userId: "..." },
    });
  },
});

export const onComplete = mutation({
  args: { workflowId: vWorkflowId, result: vResultValidator, context: v.any() },
  handler: async (ctx, args) => {
    if (args.result.kind === "success") {
      // handle success
    }
  },
});
```

</workflow>

<rules>

### Retry Policies
- You SHOULD configure defaults in WorkflowManager `workpoolOptions`.
- Per-step override: `{ retry: true | false | { maxAttempts, initialBackoffMs, base } }`.

### Parallel Steps
You MAY use `Promise.all` for parallel execution:
```ts
await Promise.all([
  step.runAction(internal.jobs.a, args),
  step.runAction(internal.jobs.b, args),
]);
```

### Limits and Caveats
- Workflow data limit ~1 MiB; journal limit ~8 MiB.
- Workflow body MUST be deterministic; You MUST use steps for side effects.
- Changing step order mid-flight MUST NOT be done (causes determinism violations).

</rules>
