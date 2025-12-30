---
name: security-fastapi
description: FastAPI security audit patterns. Use when reviewing FastAPI apps (fastapi imports, main.py/app.py, requirements/pyproject with fastapi, uvicorn). Covers auth dependencies, CORS configuration, TrustedHost/HTTPS middleware, and common FastAPI/Starlette security footguns.
---
# FastAPI Security Audit

## Core Risks to Check

### Missing Auth on Routes
FastAPI expects authentication/authorization via dependencies on routes or routers. If no `Depends()`/`Security()` usage exists, review every route for unintended public access.

```python
from fastapi import Depends, Security

@app.get("/private")
async def private_route(user=Depends(get_current_user)):
    return {"ok": True}

@app.get("/scoped")
async def scoped_route(user=Security(get_current_user, scopes=["items"])):
    return {"ok": True}
```

### API Key Schemes
If using API keys, prefer header-based schemes (`APIKeyHeader`) and validate the key server-side.

```python
from fastapi import Depends, FastAPI
from fastapi.security import APIKeyHeader

api_key = APIKeyHeader(name="x-api-key")

@app.get("/items")
async def read_items(key: str = Depends(api_key)):
    return {"key": key}
```

### CORS: Avoid Wildcards with Credentials
Using `allow_origins=["*"]` excludes credentialed requests (cookies/Authorization). For authenticated browser clients, explicitly list allowed origins.

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://app.example.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Host Header and HTTPS Enforcement
Use Starlette middleware to prevent host-header attacks and enforce HTTPS in production.

```python
from starlette.middleware.trustedhost import TrustedHostMiddleware
from starlette.middleware.httpsredirect import HTTPSRedirectMiddleware

app.add_middleware(TrustedHostMiddleware, allowed_hosts=["example.com", "*.example.com"])
app.add_middleware(HTTPSRedirectMiddleware)
```

## Quick Audit Commands

```bash
# Detect FastAPI usage
rg -n "fastapi" pyproject.toml requirements*.txt

# Find routes
rg -n "@app\.(get|post|put|patch|delete)" . -g "*.py"

# Check for auth dependencies
rg -n "Depends\(|Security\(" . -g "*.py"

# CORS config and wildcards
rg -n "CORSMiddleware|allow_origins|allow_credentials" . -g "*.py"

# TrustedHost/HTTPS middleware
rg -n "TrustedHostMiddleware|HTTPSRedirectMiddleware" . -g "*.py"
```

## Hardening Checklist

- [ ] All sensitive routes require `Depends()` or `Security()` auth dependencies
- [ ] API key schemes use headers (`APIKeyHeader`), not query params
- [ ] `allow_origins` is explicit when `allow_credentials=True`
- [ ] `TrustedHostMiddleware` configured for production domains
- [ ] `HTTPSRedirectMiddleware` enabled in production (or enforced by proxy)

## Scripts

- `scripts/scan.sh` - First-pass FastAPI security scan
