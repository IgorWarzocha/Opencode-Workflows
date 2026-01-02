# Security Reviewer

A specialized agent for auditing codebases against vibecoding vulnerabilities. It automatically detects the technology stack and applies the appropriate security checks.

All security skills use **RFC 2119 keywords** and **XML tags** for structured scanning instructions.

All security skills use **RFC 2119 keywords** and **XML tags** for structured scanning instructions.

## The Security Reviewer Agent

Your automated security auditor for modern web applications. It identifies common vulnerabilities in AI-integrated codebases, including exposed API keys, insecure configurations, and framework-specific security issues. The agent auto-selects the relevant scanning skills based on detected technologies.

> [!IMPORTANT]  
> Community input is greatly appreciated and encouraged on this one!

![security-reviewer](https://github.com/user-attachments/assets/b6fea9bb-cfda-41bb-9b3f-b29de579b397)

## The Skills

The agent dynamically loads the appropriate security skills for each scan:

| Skill | What it scans |
|-------|---------------|
| **security-ai-keys** | AI API key leakage, client-side exposure, logging/redaction issues |
| **security-bun** | Bun runtime security, shell injection, bun:sqlite, Bun.serve |
| **security-convex** | Convex query/mutation auth, row-level security, validators |
| **security-django** | Django SECRET_KEY, ALLOWED_HOSTS, DEBUG, CSRF, SecurityMiddleware |
| **security-docker** | Docker secrets in layers, port exposure, non-root users, multi-stage builds |
| **security-express** | Helmet.js, CORS, body-parser limits, auth middleware |
| **security-fastapi** | FastAPI auth dependencies, CORS, TrustedHost/HTTPS middleware |
| **security-nextjs** | NEXT_PUBLIC_* exposure, Server Actions, middleware auth, API routes |
| **security-secrets** | 25+ secret types (AWS, Google, GitHub, Stripe, etc.) - auto-loaded for all audits |
| **security-vite** | VITE_* exposure, build-time secrets, dev server security |

## Installation

Drop the `skill/` and `agent/` folders into `~/.config/opencode/`.

> [!NOTE]
> The security-reviewer agent has **10 security skills enabled by default**: `security-ai-keys`, `security-bun`, `security-convex`, `security-django`, `security-docker`, `security-express`, `security-fastapi`, `security-nextjs`, `security-secrets`, and `security-vite`. All other skills are blocked with `"*": "deny"`. This allows the agent to dynamically load relevant security checks based on detected technologies without context pollution.

### Skill Configuration

The agent's YAML frontmatter controls skill access:

```yaml
permission:
  skill:
    security-ai-keys: allow
    security-bun: allow
    security-convex: allow
    security-django: allow
    security-docker: allow
    security-express: allow
    security-fastapi: allow
    security-nextjs: allow
    security-secrets: allow
    security-vite: allow
    '*': deny
```

## Usage

Simply ask for a security review:

- *"Is my codebase leaking any API keys?"*
- *"Review this React app for security issues"*
- *"Check for vulnerabilities in my Docker setup"*
- *"What security issues does my Next.js app have?"*
- *"Scan for exposed secrets in the codebase"*

The reviewer automatically detects the project type and applies the relevant scans.

## Trigger Keywords

The agent responds to these phrases:

- "security review"
- "check for secrets"
- "find vulnerabilities"
- "is this secure?"
- "audit for vulnerabilities"

## Contributing

Found a new vulnerability pattern? The skills are modular - add a new `security-*` skill following the existing structure to extend coverage.
