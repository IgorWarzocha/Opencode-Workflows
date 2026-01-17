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

<overview>
Implement Convex authentication and authorization patterns with OIDC providers (Clerk, Auth0, WorkOS) or the built-in Convex Auth library.
</overview>

<reference>
- **Auth overview**: https://docs.convex.dev/auth
- **Convex Auth (beta)**: https://docs.convex.dev/auth/convex-auth
- **Auth methods**: https://labs.convex.dev/auth
- **Clerk Integration**: https://docs.convex.dev/auth/clerk
- **WorkOS Integration**: https://docs.convex.dev/auth/authkit/
</reference>

<context name="Auth Concepts">
- Convex uses OpenID Connect JWTs.
- Integrations: Clerk, WorkOS AuthKit, Auth0; custom OIDC supported.
- Convex Auth (Beta): A built-in library (labs.convex.dev) supporting Magic Links, OTPs, OAuth, and Passwords without external services.
- Identity: Accessed via `ctx.auth.getUserIdentity()` in server functions.
- Authorization: Enforced per public function; sensitive logic MUST use internal functions.
</context>

<rules>

### Auth Operations
- In functions: `ctx.auth.getUserIdentity()` returns `tokenIdentifier`, `subject`, `issuer` plus provider claims.
- Custom JWT auth MAY expose claims at `identity["properties.email"]` style paths.
- User storage patterns:
  - Client mutation to store user from JWT, or webhook from provider to upsert users.
  - Index lookups SHOULD use `by_token` / `byExternalId`.
- Webhooks: You MUST implement via HTTP actions and verify signatures with provider SDK; signing secrets MUST be stored in env vars.

### Convex Auth (Beta) Specifics
- Supported Methods:
  1. **Magic Links & OTPs**: Email-based links or codes.
  2. **OAuth**: GitHub, Google, Apple, etc.
  3. **Passwords**: Supports reset flows and optional email verification.
- Components: Does not provide UI components; You MUST build them in React using library hooks.
- Next.js: SSR/Middleware support is experimental/beta.

### Server Function Patterns
- You MUST read identity via `ctx.auth.getUserIdentity()`.
- You MUST enforce row-level authorization in every public function.
- You SHOULD NOT expose sensitive logic via public functions; prefer internal ones.

### Service-to-service Access
- If no user JWT is available, You SHOULD use a shared secret pattern.
- You MUST store secrets in deployment env vars; MUST NOT hardcode.

### Client Guidance
- You MUST follow provider quickstarts; MUST NOT invent flows.
- You SHOULD NOT rely on auth data in client-only code without server verification.

</rules>
