---
name: convex-deploy
description: |-
  Implement Convex deployment workflows, environments, and CI/CD configuration. Use for dev/prod/preview
  deployments, deploy keys, local deployments, environment variables, schema/index rollout safety,
  and HTTP action URLs. Use proactively when users mention deploy, preview, staging, CI, env vars,
  or local backend.
  
  Examples:
  - user: "Set up Convex deploy in CI" → configure deploy key + npx convex deploy steps
  - user: "How do preview deployments work?" → explain preview keys, lifecycle, limits
  - user: "Deploy to prod safely" → list safe schema/function change patterns
  - user: "Use local convex" → explain npx convex dev --local and limitations
---

<overview>
Cover deployment lifecycle, environments, and safe rollout strategies for Convex backends and full-stack apps.
</overview>

<context name="Deployment Concepts">
- Model: one prod deployment per project, one dev deployment per team member, preview deployments per branch.
- Preview deployments are beta and auto-cleaned; data seeding requires `--preview-run`.
- Local deployments: `npx convex dev --local --once`, no public URL, Node actions require Node 18.
- Agent Mode: Use `CONVEX_AGENT_MODE=anonymous` for AI coding agents to limit permissions during development.
- Env vars are per-deployment; system vars `CONVEX_CLOUD_URL` and `CONVEX_SITE_URL`.
- Safe change rules: schema MUST match data; use optional/backfill/union migrations; keep functions backwards compatible; scheduled args MUST remain valid.
- Project config: `convex.json` CAN change functions path, node runtime; static codegen is beta.
- Pausing deployments returns errors for new calls, queues scheduled jobs, skips crons; You SHOULD test on dev first.
</context>

<rules>

### Deployment Operations
- Core commands: `npx convex dev`, `npx convex deploy`, `npx convex codegen`, `npx convex run` (use `--prod` for prod).
- Agent Mode: You SHOULD use `CONVEX_AGENT_MODE=anonymous npx convex dev --once` when iterating as an AI agent to safely generate codegen artifacts.
- Deploy target resolution: `CONVEX_DEPLOY_KEY` overrides, else uses production of `CONVEX_DEPLOYMENT` project.
- Build step: `npx convex deploy --cmd "npm run build"` and `--cmd-url-env-var-name` if needed.
- Deploy keys: production, preview, dev, admin (You MUST NOT commit/log).
- Hosting flows:
  - Vercel/Netlify build command SHOULD use `npx convex deploy --cmd 'npm run build'`.
  - You MUST set `CONVEX_DEPLOY_KEY` per environment (Preview vs Production).
  - Preview seeding via `--preview-run 'functionName'`.
  - Custom hosting: deploy backend, host frontend elsewhere; custom domains require overriding `CONVEX_CLOUD_URL` and redeploying; optional `CONVEX_SITE_URL`.

### Required Outputs
- You MUST use exact CLI commands and flags from docs.
- You MUST state target deployment resolution (deploy key vs CONVEX_DEPLOYMENT).
- You MUST call out deploy-side effects: schema validation, index backfill, codegen, bundling.
- You SHOULD always mention `.convex.site` vs `.convex.cloud` URL usage where relevant.

### Deployment Model
- Each project has one production deployment and one cloud dev deployment per team member.
- Preview deployments are per-branch and are auto-cleaned after a time window.
- Local deployments are dev-only and run as subprocesses of `npx convex dev`.

### CLI Workflow

#### Dev
- `npx convex dev`:
  - Watches files, pushes changes to dev deployment.
  - Regenerates `convex/_generated/*`.
  - You SHOULD use `--tail-logs` to control log output.
- Local dev:
  - `npx convex dev --local --once` for local backend.
  - Note: No public URL; HTTP requests need a proxy (e.g., ngrok).
  - Node actions require Node 18 locally.

#### Deploy
- `npx convex deploy`:
  - Typechecks functions.
  - Regenerates codegen.
  - Bundles and pushes functions, schema, and indexes.
- Deploy target resolution:
  - If `CONVEX_DEPLOY_KEY` is set, deploys to that key's target.
  - Else uses the production deployment of `CONVEX_DEPLOYMENT`'s project.
- Optional build command:
  - `npx convex deploy --cmd "npm run build"`
  - Use `--cmd-url-env-var-name` to customize env var name.

### Deploy Keys
- Production deploy key: targets project production deployment (typical CI).
- Preview deploy key: creates preview deployment per branch.
- Dev deploy key: scoped to a single dev deployment.
- Admin key: full control; used for anonymous local deployments.
- **Security**: You MUST NOT paste deploy keys into code or commit history.

### Preview Deployments
- Beta feature, lifecycle auto-cleans (5 days default).
- Preview deployment name is tied to branch; redeploy replaces previous preview.
- Data seeding requires running a function during deploy (`--preview-run`).

### Environment Variables
- You MUST set per-deployment via dashboard or `npx convex env`.
- Same key MAY require values in both dev and prod.
- System vars:
  - `CONVEX_CLOUD_URL` for client RPCs.
  - `CONVEX_SITE_URL` for HTTP actions.
- You MUST NOT branch exports on `process.env` at runtime; functions set at deploy time.

### Safe Rollout Rules
- Schema MUST match existing data; deploy blocks on validation failures.
- Safe schema changes:
  - Add tables.
  - Add optional fields, backfill, then make required.
  - Widen via `v.union`, backfill, then narrow.
- Functions MUST remain backward compatible while old clients are running.
- Scheduled functions MUST accept previously scheduled args.

### Index Backfill
- New indexes backfill during deploy; CAN slow production push.
- You SHOULD use staged indexes (including search/vector) for large tables.
- Removing indexes deletes them on deploy; You MUST ensure no code paths depend on them.

### URLs
- HTTP actions: `https://<deployment>.convex.site`.
- Client URLs: `https://<deployment>.convex.cloud` (via `CONVEX_CLOUD_URL`).
- You SHOULD warn about mixing `.convex.site` and `.convex.cloud`.

### Response Checklist
- [ ] State environment (dev/prod/preview/local).
- [ ] Provide exact commands and required env vars.
- [ ] List safety considerations (schema, functions, scheduled).
- [ ] Mention logs location (CLI or dashboard) when troubleshooting.

</rules>
