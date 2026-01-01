---
name: security-bun
description: Bun runtime security audit patterns. Load when reviewing Bun apps (bun.lockb, bunfig.toml, or bun:* imports present). Covers Bun shell injection, bun:sqlite SQL injection, Bun.serve, Bun.spawn, file operations, and Bun-specific footguns.
---

<overview>

Security audit patterns for Bun runtime applications covering shell injection, SQL injection, server security, and Bun-specific vulnerabilities.

</overview>

<rules>

## The #1 Bun Footgun: Shell Escaping vs Raw Shell

Bun's shell `$` is a tagged template that escapes by default. If you bypass escaping (via raw mode), user input can become command injection.

```typescript
import { $ } from "bun";

const userInput = "hello; rm -rf /";

// ✓ SAFE: Tagged template - automatically escapes
await $`echo ${userInput}`;
// Executes: echo 'hello; rm -rf /'

// ❌ CRITICAL: Spawning a new shell (bypasses Bun escaping)
await $`bash -c "echo ${userInput}"`;
// The nested shell interprets user input as code
```

### Argument Injection (Even with Escaping)

Even the safe tagged template is vulnerable to argument injection:

```typescript
import { $ } from "bun";

// ❌ HIGH: Argument injection via -- prefix
const userRepo = "--upload-pack=id>/tmp/pwned";
await $`git ls-remote ${userRepo} main`;
// The -- prefix makes it a command-line argument, not a value

// ✓ Validate input format before use
const userRepo = getUserInput();
if (!userRepo.match(/^https?:\/\//)) {
  throw new Error("Invalid repository URL");
}
await $`git ls-remote ${userRepo} main`;

// ✓ Or use -- to end argument parsing
await $`git ls-remote -- ${userRepo} main`;
```

## bun:sqlite SQL Injection

`sql` is a tagged template that parameterizes values. If you build SQL strings manually, you can still be vulnerable.

```typescript
import { sql } from "bun";

const userId = "1 OR 1=1";

// ❌ CRITICAL: Function call - SQL injection!
await sql(`SELECT * FROM users WHERE id = ${userId}`);
// Executes: SELECT * FROM users WHERE id = 1 OR 1=1

// ✓ SAFE: Tagged template - parameterized query
await sql`SELECT * FROM users WHERE id = ${userId}`;
// Executes: SELECT * FROM users WHERE id = $1 with params ['1 OR 1=1']
```

### bun:sqlite Database Class

```typescript
import { Database } from "bun:sqlite";

const db = new Database("mydb.sqlite");
const userInput = "'; DROP TABLE users; --";

// ❌ CRITICAL: String interpolation
db.run(`INSERT INTO logs VALUES ('${userInput}')`);

// ✓ SAFE: Parameterized with .run()
db.run("INSERT INTO logs VALUES (?)", [userInput]);

// ✓ SAFE: Prepared statements
const stmt = db.prepare("SELECT * FROM users WHERE id = ?");
stmt.get(userInput);

// ✓ SAFE: Query with parameters
db.query("SELECT * FROM users WHERE email = ?").get(userInput);
```

</rules>

<vulnerabilities>

## Bun.serve() Security

### Missing Request Validation

```typescript
// ❌ No input validation
Bun.serve({
  fetch(req) {
    const url = new URL(req.url);
    const file = url.searchParams.get("file");
    return new Response(Bun.file(`./uploads/${file}`)); // Path traversal!
  },
});

// ✓ Validate and sanitize
import { join, basename, resolve } from "path";

Bun.serve({
  fetch(req) {
    const url = new URL(req.url);
    const file = url.searchParams.get("file");
    
    // Sanitize filename
    const safeName = basename(file ?? "");
    const uploadsDir = resolve("./uploads");
    const filePath = resolve(join(uploadsDir, safeName));
    
    // Verify path is within uploads directory
    if (!filePath.startsWith(uploadsDir)) {
      return new Response("Forbidden", { status: 403 });
    }
    
    return new Response(Bun.file(filePath));
  },
});
```

### Request Size Limits (DoS Protection)

```typescript
// ❌ No body size limit (large uploads can exhaust memory)
Bun.serve({
  fetch(req) {
    return new Response("ok");
  },
});

// ✓ Set a max request body size
Bun.serve({
  maxRequestBodySize: 1_000_000, // 1 MB
  fetch(req) {
    return new Response("ok");
  },
});
```

### CORS Configuration

```typescript
// ❌ Wide open CORS
Bun.serve({
  fetch(req) {
    return new Response("data", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true", // Dangerous combo!
      },
    });
  },
});

// ✓ Explicit origin allowlist
const ALLOWED_ORIGINS = ["https://app.example.com"];

Bun.serve({
  fetch(req) {
    const origin = req.headers.get("Origin");
    const corsHeaders: Record<string, string> = {};
    
    if (origin && ALLOWED_ORIGINS.includes(origin)) {
      corsHeaders["Access-Control-Allow-Origin"] = origin;
      corsHeaders["Access-Control-Allow-Credentials"] = "true";
    }
    
    return new Response("data", { headers: corsHeaders });
  },
});
```

### Host Binding

```typescript
// ❌ Exposed to network (sometimes unintentional)
Bun.serve({
  hostname: "0.0.0.0", // Accessible from any network interface
  port: 3000,
  fetch(req) { /* ... */ },
});

// ✓ Localhost only for development
Bun.serve({
  hostname: "127.0.0.1", // Only local access
  port: 3000,
  fetch(req) { /* ... */ },
});
```

## Bun.spawn() Command Injection

```typescript
// ❌ CRITICAL: User input in command array (can still be dangerous)
const filename = userInput; // Could be "--version" or other flags
Bun.spawn(["convert", filename, "output.png"]);

// ❌ CRITICAL: Shell execution with user input
Bun.spawn(["sh", "-c", `convert ${userInput} output.png`]);

// ✓ Validate input first
const filename = userInput;
if (!filename.match(/^[a-zA-Z0-9_-]+\.(jpg|png|gif)$/)) {
  throw new Error("Invalid filename");
}
Bun.spawn(["convert", filename, "output.png"]);

// ✓ Use -- to prevent flag injection
Bun.spawn(["convert", "--", filename, "output.png"]);
```

## Bun.file() and Bun.write() Path Traversal

```typescript
// ❌ HIGH: Path traversal
const userFile = req.query.file; // "../../etc/passwd"
const content = await Bun.file(`./uploads/${userFile}`).text();

// ❌ HIGH: Writing to arbitrary paths
await Bun.write(`./data/${userFile}`, content);

// ✓ Sanitize paths
import { join, basename, resolve } from "path";

const UPLOADS_DIR = resolve("./uploads");

function getSafePath(userInput: string): string {
  const safeName = basename(userInput);
  const fullPath = resolve(join(UPLOADS_DIR, safeName));
  
  if (!fullPath.startsWith(UPLOADS_DIR)) {
    throw new Error("Invalid path");
  }
  
  return fullPath;
}

const content = await Bun.file(getSafePath(userFile)).text();
```

## Bun.password (Secure, but check usage)

```typescript
// ✓ Bun.password.hash is secure by default (uses argon2)
const hash = await Bun.password.hash(password);

// ✓ Verify passwords
const isValid = await Bun.password.verify(password, hash);

// ⚠️ But check: is it actually being used?
// Common vibecoding mistake: storing plaintext anyway

// ❌ Storing plaintext
db.run("INSERT INTO users (password) VALUES (?)", [password]);

// ✓ Storing hash
const hash = await Bun.password.hash(password);
db.run("INSERT INTO users (password_hash) VALUES (?)", [hash]);
```

## Environment Variables

```typescript
// Bun.env is the same as process.env

// ❌ Secrets in client-facing code
// If using Bun with a bundler, check what gets bundled

// ✓ Server-only access
const apiKey = Bun.env.API_KEY;
if (!apiKey) {
  throw new Error("API_KEY not configured");
}

// Check bunfig.toml for any exposed variables
```

### bunfig.toml Security

```toml
# Check for suspicious configurations

[install]
# ❌ Disabling lockfile = supply chain risk
save-lockfile = false

# ❌ Allowing arbitrary registries
registry = "http://malicious-registry.com"

[run]
# ❌ Disabling sandbox (if applicable)
```

## WebSocket Security

```typescript
Bun.serve({
  fetch(req, server) {
    if (req.headers.get("upgrade") === "websocket") {
      // ❌ No auth check before upgrade
      server.upgrade(req);
      return;
    }
  },
  websocket: {
    message(ws, message) {
      // ❌ Broadcasting without auth
      ws.publish("chat", message);
    },
  },
});

// ✓ Authenticate before upgrade
Bun.serve({
  fetch(req, server) {
    if (req.headers.get("upgrade") === "websocket") {
      const token = req.headers.get("Authorization");
      const user = await verifyToken(token);
      
      if (!user) {
        return new Response("Unauthorized", { status: 401 });
      }
      
      server.upgrade(req, { data: { user } });
      return;
    }
  },
  websocket: {
    message(ws, message) {
      // Access authenticated user
      const user = ws.data.user;
      // Now safe to process message
    },
  },
});
```

</vulnerabilities>

<severity_table>

## Common Vulnerabilities Summary

| Issue | Pattern to Find | Severity |
|-------|-----------------|----------|
| Shell injection (function call) | `$(`...`)` or `$("...")` | CRITICAL |
| SQL injection (function call) | `sql(`...`)` | CRITICAL |
| SQL string interpolation | `` `...${var}...` `` in SQL | CRITICAL |
| Argument injection | User input starting with `-` | HIGH |
| Path traversal | `Bun.file(userInput)` | HIGH |
| Command injection | `Bun.spawn` with user input | HIGH |
| Open CORS | `Access-Control-Allow-Origin: *` | MEDIUM |
| Network exposure | `hostname: "0.0.0.0"` | MEDIUM |
| Missing WebSocket auth | `server.upgrade` without auth check | HIGH |

</severity_table>

<commands>

## Quick Audit Commands

```bash
# Find dangerous shell usage (function call instead of tagged template)
rg '\$\s*\(' . -g "*.ts" -g "*.js"

# Find SQL function calls (should be tagged template)
rg 'sql\s*\(' . -g "*.ts" -g "*.js"

# Find string interpolation in queries
rg '(query|run|exec)\s*\(\s*`' . -g "*.ts" -g "*.js"

# Find Bun.spawn usage
rg 'Bun\.spawn' . -g "*.ts" -g "*.js" -A 2

# Find Bun.file with variables (potential path traversal)
rg 'Bun\.file\s*\([^"'\''`]' . -g "*.ts" -g "*.js"

# Find hostname binding
rg 'hostname.*0\.0\.0\.0' . -g "*.ts" -g "*.js"

# Find CORS headers
rg 'Access-Control-Allow-Origin' . -g "*.ts" -g "*.js"

# Find WebSocket upgrades
rg 'server\.upgrade' . -g "*.ts" -g "*.js" -B 5
```

</commands>

<checklist>

## Hardening Checklist

- [ ] All `$` shell usage is tagged template (no parentheses)
- [ ] All `sql` usage is tagged template (no parentheses)
- [ ] All bun:sqlite queries use parameterization
- [ ] User input validated before shell/spawn commands
- [ ] `--` used to prevent argument injection where applicable
- [ ] File paths sanitized with basename() and path validation
- [ ] CORS restricted to specific origins
- [ ] hostname is 127.0.0.1 for dev, explicit for prod
- [ ] WebSocket connections authenticated before upgrade
- [ ] Bun.password.hash used for passwords (not plaintext)
- [ ] bunfig.toml reviewed for suspicious settings

</checklist>
