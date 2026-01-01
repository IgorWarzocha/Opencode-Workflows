---
name: security-docker
description: Docker/container security audit patterns. Load when Dockerfile or docker-compose.yml present. Covers secrets in layers, port exposure, non-root users, multi-stage builds, and compose security.
---

<overview>

Security audit patterns for Docker and container deployments covering secrets in images, port exposure, user privileges, and compose security.

</overview>

<vulnerabilities>

## Secrets in Images (Critical)

### Secrets in Build Args/ENV
```dockerfile
# ❌ CRITICAL: Secret in ENV (visible in image history)
ENV API_KEY=sk_live_abc123
ENV DATABASE_URL=postgres://user:password@host/db

# ❌ CRITICAL: Secret in ARG (visible in image history)
ARG AWS_SECRET_ACCESS_KEY
RUN aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

# ✓ Use runtime secrets
# Pass via docker run -e or docker-compose environment/env_file

# ✓ Docker secrets (Swarm) or orchestrator-specific secrets
# Use /run/secrets/* instead of ENV/ARG when available
```

### Secrets Baked into Layers
```dockerfile
# ❌ CRITICAL: Even if deleted, secret is in layer history
COPY .env /app/.env
RUN source /app/.env && do_something
RUN rm /app/.env  # Still in previous layer!

# ❌ CRITICAL: Copying all files includes secrets
COPY . /app/  # Copies .env, .git, etc.

# ✓ Use .dockerignore
# In .dockerignore:
# .env*
# .git
# *.pem
# *.key

# ✓ Or explicit COPY
COPY package*.json /app/
COPY src/ /app/src/
```

### Checking Image History
```bash
# Audit existing images for secrets
docker history --no-trunc <image>
docker inspect <image> | jq '.[0].Config.Env'
```

## Port Exposure

### docker-compose.yml
```yaml
# ❌ CRITICAL: Database exposed to host network
services:
  db:
    image: postgres
    ports:
      - "5432:5432"  # Accessible from outside!

# ❌ CRITICAL: Redis without password
  redis:
    image: redis
    ports:
      - "6379:6379"  # And no AUTH!

# ✓ Internal only (accessible to other containers)
services:
  db:
    image: postgres
    expose:
      - "5432"  # Only internal
    # No 'ports' = not exposed to host

# ✓ If must expose, bind to localhost
  db:
    ports:
      - "127.0.0.1:5432:5432"  # Only localhost
```

### Default Credentials
```yaml
# ❌ No password or default password
services:
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: postgres  # Default!

  redis:
    image: redis
    # No password at all

# ✓ Strong passwords from secrets
services:
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt  # MUST NOT be in git!
```

## Non-Root User

```dockerfile
# ❌ Running as root (default)
FROM node:18
COPY . /app
CMD ["node", "server.js"]  # Runs as root

# ✓ Create and use non-root user
FROM node:18
WORKDIR /app
COPY --chown=node:node . .
USER node
CMD ["node", "server.js"]

# ✓ Using numeric UID (more portable)
FROM node:18
RUN useradd -r -u 1001 appuser
WORKDIR /app
COPY --chown=1001:1001 . .
USER 1001
CMD ["node", "server.js"]
```

## Multi-Stage Builds

```dockerfile
# ❌ Build tools and secrets in final image
FROM node:18
COPY . .
RUN npm install
RUN npm run build
CMD ["node", "dist/server.js"]
# Final image has: source, node_modules (dev deps), build tools

# ✓ Multi-stage: only production artifacts
FROM node:18 AS builder
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-slim AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
USER node
CMD ["node", "dist/server.js"]
# Final image: minimal, no source, no build tools
```

## Docker Compose Security

### Privileged Mode
```yaml
# ❌ CRITICAL: Full host access
services:
  app:
    privileged: true  # Container can do anything on host!

# ❌ HIGH: Dangerous capabilities
services:
  app:
    cap_add:
      - SYS_ADMIN
      - NET_ADMIN
```

### Volume Mounts
```yaml
# ❌ CRITICAL: Docker socket access = root on host
services:
  app:
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

# ❌ HIGH: Sensitive host paths
services:
  app:
    volumes:
      - /etc:/etc
      - /root:/root
```

### Network Mode
```yaml
# ❌ HIGH: Host network mode
services:
  app:
    network_mode: host  # Bypasses Docker network isolation
```

## Image Security

### Base Image
```dockerfile
# ❌ Outdated or unverified
FROM node:14  # EOL version
FROM random-user/node-app  # Unverified

# ✓ Official, recent, minimal
FROM node:20-slim
FROM node:20-alpine
```

### Image Scanning
```bash
# Scan for vulnerabilities
docker scout cves <image>
trivy image <image>
grype <image>
```

</vulnerabilities>

<commands>

## Quick Audit Commands

```bash
# Find secrets in Dockerfile
rg "(ENV|ARG).*(KEY|SECRET|PASSWORD|TOKEN)" Dockerfile*

# Find exposed ports in compose
rg "ports:" docker-compose*.yml -A 3

# Check for privileged/capabilities
rg "(privileged|cap_add|network_mode)" docker-compose*.yml

# Check for docker.sock mount
rg "docker.sock" docker-compose*.yml

# Check for USER instruction
grep "^USER" Dockerfile

# Check .dockerignore exists and has secrets
cat .dockerignore | grep -E "(env|key|secret|pem)"
```

</commands>

<checklist>

## Hardening Checklist

- [ ] No secrets in ENV/ARG instructions
- [ ] No secrets COPY'd into image
- [ ] .dockerignore excludes .env, .git, *.pem, *.key
- [ ] Database/Redis ports not exposed to host (or only 127.0.0.1)
- [ ] Strong passwords for all services (not defaults)
- [ ] USER instruction sets non-root user
- [ ] Multi-stage build for production images
- [ ] No privileged: true
- [ ] No docker.sock mount (unless required)
- [ ] Base images are official and recent
- [ ] Images scanned for vulnerabilities

</checklist>
