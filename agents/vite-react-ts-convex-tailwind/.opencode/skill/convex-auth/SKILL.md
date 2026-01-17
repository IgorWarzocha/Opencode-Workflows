---
name: convex-auth
description: |-
  Implement Convex authentication and authorization patterns with OIDC providers or Convex Auth.
  Use for auth provider setup, ctx.auth usage, user identity handling, and auth-aware schema patterns.
  Use proactively when users mention auth, JWT, Clerk/Auth0/WorkOS, or Convex Auth.
  
  Examples:
  - user: "Add auth to Convex" → choose provider and outline setup
  - user: "Get current user" → use ctx.auth.getUserIdentity and checks
  - user: "Service-to-service access" → use shared secret pattern
---
# Convex Auth

## Sources

- Auth overview: https://docs.convex.dev/auth
- Functions auth: https://docs.convex.dev/auth/functions-auth
- Database auth: https://docs.convex.dev/auth/database-auth
- Convex Auth (beta): https://docs.convex.dev/auth/convex-auth

## Auth Concepts

- Convex uses OpenID Connect JWTs.
- Integrations: Clerk, WorkOS AuthKit, Auth0; custom OIDC supported.
- Convex Auth is beta (labs.convex.dev), React/React Native oriented.
- Authorization is enforced per public function; use internal functions for sensitive ops.
- Service-to-service access uses shared secret checks stored in env vars.

## Auth Operations

- In functions: `ctx.auth.getUserIdentity()` returns `tokenIdentifier`, `subject`, `issuer` plus provider claims.
- Custom JWT auth may expose claims at `identity["properties.email"]` style paths.
- User storage patterns:
  - Client mutation to store user from JWT, or webhook from provider to upsert users.
  - Index lookups using `by_token` / `byExternalId`.
- Webhooks: implement via HTTP actions, verify signatures with provider SDK; store signing secrets in env vars.
- HTTP actions: require `Authorization: Bearer <JWT>` for authenticated access.

## Provider Guidance

- Convex authenticates via OpenID Connect JWTs.
- Supported provider integrations: Clerk, WorkOS AuthKit, Auth0.
- Custom OIDC is supported via advanced config.
- Convex Auth is beta; call that out when suggested.

## Server Function Patterns

- Read identity via `ctx.auth.getUserIdentity()`.
- Enforce row-level authorization in every public function.
- Avoid exposing sensitive logic via public functions; prefer internal ones.

## Service-to-service Access

- If no user JWT is available, use a shared secret pattern.
- Store secrets in deployment env vars; do not hardcode.

## Client Guidance

- Follow provider quickstarts; do not invent flows.
- Avoid relying on auth data in client-only code without server verification.
