#!/usr/bin/env bash
# Docker Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== DOCKER SECURITY SCAN ==="
echo "Directory: $DIR"
echo "Timestamp: $(date -Iseconds)"
echo ""

if ! command -v rg &> /dev/null; then
    echo "[ERROR] ripgrep (rg) required"
    exit 1
fi

report() {
    local severity="$1"
    local title="$2"
    local file="${3:-}"
    local line="${4:-}"
    echo "[$severity] $title"
    if [[ -n "$file" ]]; then
        if [[ -n "$line" ]]; then
            echo "  File: $file:$line"
        else
            echo "  File: $file"
        fi
    fi
    echo ""
    FOUND=$((FOUND + 1))
}

# Find Dockerfiles
DOCKERFILES=$(find "$DIR" -name "Dockerfile*" -type f 2>/dev/null || true)
COMPOSE_FILES=$(find "$DIR" -name "docker-compose*.yml" -o -name "docker-compose*.yaml" -o -name "compose.yml" -o -name "compose.yaml" 2>/dev/null | head -10 || true)

echo "=== DOCKERFILE CHECKS ==="
echo ""

for dockerfile in $DOCKERFILES; do
    [[ -z "$dockerfile" ]] && continue
    echo "## Checking: $dockerfile"
    
    # Secrets in ENV
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "CRITICAL" "Secret in ENV instruction" "$dockerfile" "$line"
    done < <(rg -n 'ENV.*(KEY|SECRET|PASSWORD|TOKEN)' "$dockerfile" 2>/dev/null || true)
    
    # Secrets in ARG
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "HIGH" "Sensitive ARG instruction (visible in image history)" "$dockerfile" "$line"
    done < <(rg -n 'ARG.*(KEY|SECRET|PASSWORD|TOKEN)' "$dockerfile" 2>/dev/null || true)
    
    # COPY . (copies everything)
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "MEDIUM" "COPY . copies all files (may include secrets)" "$dockerfile" "$line"
    done < <(rg -n '^COPY \. ' "$dockerfile" 2>/dev/null || true)
    
    # No USER instruction
    if ! rg -q '^USER ' "$dockerfile" 2>/dev/null; then
        report "MEDIUM" "No USER instruction (runs as root)" "$dockerfile"
    fi
    
    # Outdated base images
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        if echo "$match" | grep -qE 'node:(14|16)[^0-9]|python:(3\.7|3\.8)[^0-9]'; then
            report "MEDIUM" "Potentially outdated base image" "$dockerfile" "$line"
        fi
    done < <(rg -n '^FROM ' "$dockerfile" 2>/dev/null || true)
    
    echo ""
done

echo "=== DOCKER-COMPOSE CHECKS ==="
echo ""

for compose in $COMPOSE_FILES; do
    [[ -z "$compose" ]] && continue
    echo "## Checking: $compose"
    
    # Exposed database ports
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        if echo "$match" | grep -qE '"?(5432|3306|27017|6379):'; then
            report "CRITICAL" "Database/Redis port exposed to host" "$compose" "$line"
        fi
    done < <(rg -n 'ports:' "$compose" -A 5 2>/dev/null || true)
    
    # Docker socket mount
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "CRITICAL" "Docker socket mounted (root access to host)" "$compose" "$line"
    done < <(rg -n 'docker\.sock' "$compose" 2>/dev/null || true)
    
    # Privileged mode
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "CRITICAL" "Privileged container (full host access)" "$compose" "$line"
    done < <(rg -n 'privileged.*true' "$compose" 2>/dev/null || true)

    # Dangerous capabilities
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "HIGH" "cap_add includes privileged capability (review necessity)" "$compose" "$line"
    done < <(rg -n '(SYS_ADMIN|NET_ADMIN|SYS_PTRACE|ALL)' "$compose" 2>/dev/null || true)
    
    # Default passwords
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        if echo "$match" | grep -qiE 'PASSWORD.*(postgres|mysql|admin|root|password|123)'; then
            report "HIGH" "Potential default/weak password" "$compose" "$line"
        fi
    done < <(rg -n 'PASSWORD' "$compose" 2>/dev/null || true)
    
    # Network mode host
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "HIGH" "Host network mode (bypasses Docker networking)" "$compose" "$line"
    done < <(rg -n 'network_mode.*host' "$compose" 2>/dev/null || true)

    # Host PID namespace
    while IFS=: read -r line match; do
        [[ -z "$line" ]] && continue
        report "HIGH" "PID namespace set to host (process isolation bypass)" "$compose" "$line"
    done < <(rg -n 'pid:\s*host' "$compose" 2>/dev/null || true)
    
    echo ""
done

echo "=== .dockerignore CHECK ==="
echo ""

if [[ -f "$DIR/.dockerignore" ]]; then
    echo "[INFO] .dockerignore found"
    
    # Check for important exclusions
    for pattern in ".env" ".git" "*.pem" "*.key"; do
        if ! grep -q "$pattern" "$DIR/.dockerignore" 2>/dev/null; then
            report "MEDIUM" ".dockerignore missing: $pattern" "$DIR/.dockerignore"
        fi
    done
else
    if [[ -n "$DOCKERFILES" ]]; then
        report "MEDIUM" "No .dockerignore file (secrets may be copied into image)"
    fi
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Docker security issues detected"
    exit 0
fi
