---
name: security-vite
description: |-
  Review Vite security audit patterns for SPA and dev server security. Use for auditing VITE_* exposure, build-time secrets, and proxy configs. Use proactively when reviewing Vite apps (vite.config.ts present).
  Examples:
  - user: "Audit Vite env vars" → check for secrets with VITE_ prefix
  - user: "Check Vite build config" → verify define block and source maps
  - user: "Review Vite dev server" → check host binding and proxy security
  - user: "Scan Vite bundles" → search dist/ for leaked API keys or secrets
  - user: "Audit Vite SPA auth" → verify server-side auth vs client route guards
---

<overview>

Security audit patterns for Vite applications focusing on environment variable exposure, build-time secrets, and SPA-specific vulnerabilities.

</overview>

<rules>

## Environment Variable Exposure

### The VITE_ Footgun
```
VITE_*    → Bundled into client JavaScript → Visible to everyone
No prefix → Only available in vite.config.ts → Safe for secrets
```

**Audit steps:**
1. `grep -r "VITE_" . -g "*.env*"`
2. Check `import.meta.env.VITE_*` usage in source
3. Common mistakes:
   - `VITE_API_SECRET` (SHOULD be server-only)
   - `VITE_DATABASE_URL` (MUST NOT use)
   - `VITE_STRIPE_SECRET_KEY` (only publishable keys)

### Env Files Priority
Vite loads in this order (later overrides earlier):
```
.env                # Always loaded
.env.local          # Always loaded, gitignored
.env.[mode]         # e.g., .env.production
.env.[mode].local   # e.g., .env.production.local, gitignored
```

**Check:** Are `.env.local` and `.env.*.local` in `.gitignore`?

### envPrefix Overrides

If `envPrefix` is configured, Vite exposes any variables with those prefixes. Treat `envPrefix` as a security-sensitive setting.

</rules>

<vulnerabilities>

## Build-Time vs Runtime

### Dangerous: Secrets in vite.config.ts
```typescript
// ❌ Secret in config (ends up in bundle)
export default defineConfig({
  define: {
    'process.env.API_KEY': JSON.stringify(process.env.API_KEY),
  },
});

// The above makes API_KEY available in client code!
```

### Safe Pattern
```typescript
// Only use VITE_ prefix for truly public values
export default defineConfig({
  define: {
    '__APP_VERSION__': JSON.stringify(process.env.npm_package_version),
  },
});

// Keep secrets on server (use a backend API)
```

## Dev Server Security

### Open to Network
```typescript
// ❌ Exposes dev server to network
export default defineConfig({
  server: {
    host: '0.0.0.0',  // or host: true
  },
});
```

This is dangerous on shared networks. Check if intentional.

### Proxy Misconfiguration
```typescript
export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        // ❌ Missing secure options for production-like setup
      },
    },
  },
});
```

## SPA Security Issues

### Client-Side Auth Only
```typescript
// ❌ "Protection" only in React Router
const ProtectedRoute = ({ children }) => {
  const { user } = useAuth();
  if (!user) return <Navigate to="/login" />;
  return children;
};

// API calls still need server-side auth!
// This is UI convenience, not security.
```

### Secrets in Bundle
```bash
# Check the built bundle for secrets
rg -a "(sk_live|sk_test|AKIA|api[_-]?key)" dist/
```

### Source Maps in Production
```typescript
// Check vite.config.ts
export default defineConfig({
  build: {
    sourcemap: true,  // ❌ Exposes source code in production
  },
});
```

</vulnerabilities>

<severity_table>

## Common Vulnerabilities

| Issue | Where to Look | Severity |
|-------|---------------|----------|
| VITE_* secrets | `.env*`, source files | CRITICAL |
| Secrets in define | `vite.config.ts` | CRITICAL |
| Source maps in prod | `vite.config.ts` | MEDIUM |
| Dev server exposed | `vite.config.ts` server.host | MEDIUM |
| Client-only auth | Route guards without API auth | HIGH |
| API keys in bundle | `dist/` directory | CRITICAL |

</severity_table>

<commands>

## Quick Audit Commands

```bash
# Find VITE_ secrets
grep -r "VITE_" . -g "*.env*"

# Find import.meta.env usage
rg 'import\.meta\.env' . -g "*.ts" -g "*.tsx" -g "*.vue"

# Check define in config
rg 'define:' vite.config.*

# Scan built bundle for secrets
rg -a "(sk_live|AKIA|ghp_|api[_-]?key['\"]?\s*[:=])" dist/

# Check for source maps
fd '\.map$' dist/
```

</commands>

<checklist>

## Hardening Checklist

- [ ] No secrets in `VITE_*` variables
- [ ] `.env.local` and `.env.*.local` in `.gitignore`
- [ ] `sourcemap: false` in production build
- [ ] `server.host` is not `0.0.0.0` or `true` (unless intentional)
- [ ] All sensitive API calls go through a backend (not direct from browser)
- [ ] No secrets in `vite.config.ts` define block

</checklist>
