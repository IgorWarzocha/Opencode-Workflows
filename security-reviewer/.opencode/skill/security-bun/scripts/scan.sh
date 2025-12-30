#!/usr/bin/env bash
# Bun Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== BUN SECURITY SCAN ==="
echo "Directory: $DIR"
echo "Timestamp: $(date -Iseconds)"
echo ""

if ! command -v rg &> /dev/null; then
    echo "[ERROR] ripgrep (rg) required. Install with: brew install ripgrep"
    exit 1
fi

report() {
    local severity="$1"
    local title="$2"
    local file="$3"
    local line="$4"
    local match="$5"
    echo "[$severity] $title"
    echo "  File: $file:$line"
    echo "  Match: $match"
    echo ""
    FOUND=$((FOUND + 1))
}

echo "=== HIGH: Shell Usage Without Escaping ==="
echo ""

# Non-tagged $ usage (potentially unescaped)
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "Non-template $ usage (verify escaping)" "$file" "$line" "$match"
done < <(rg -n --no-heading '\$\s*\(' "$DIR" -g "*.ts" -g "*.js" -g "*.tsx" 2>/dev/null || true)

echo "=== HIGH: Nested Shell Usage ==="
echo ""

# Spawning a new shell can re-enable injection
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "Nested shell invocation (verify input is not user-controlled)" "$file" "$line" "$match"
done < <(rg -n --no-heading 'bash\\s+-c|sh\\s+-c' "$DIR" -g "*.ts" -g "*.js" -g "*.tsx" 2>/dev/null || true)

echo "=== CRITICAL: SQL Injection ==="
echo ""

# SQL function call - CRITICAL
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "CRITICAL" "sql() used as function call (injection risk)" "$file" "$line" "$match"
done < <(rg -n --no-heading 'sql\s*\(' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

# String interpolation in database queries
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "String interpolation in query/run/exec" "$file" "$line" "$match"
done < <(rg -n --no-heading '(query|run|exec)\s*\(\s*`' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

echo "=== HIGH: Command Injection ==="
echo ""

# Bun.spawn checks
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "MEDIUM" "Bun.spawn usage (verify input validation)" "$file" "$line" "$match"
done < <(rg -n --no-heading 'Bun\.spawn' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

echo "=== HIGH: Path Traversal ==="
echo ""

# Bun.file with variable (not string literal)
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    # Skip if it's a string literal
    if ! echo "$match" | grep -qE 'Bun\.file\s*\(["'\''`]'; then
        report "HIGH" "Bun.file() with variable (path traversal risk)" "$file" "$line" "$match"
    fi
done < <(rg -n --no-heading 'Bun\.file\s*\(' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

echo "=== MEDIUM: Network Exposure ==="
echo ""

# 0.0.0.0 binding
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "MEDIUM" "Server bound to 0.0.0.0 (network exposed)" "$file" "$line" "$match"
done < <(rg -n --no-heading 'hostname.*0\.0\.0\.0' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

echo "=== MEDIUM: CORS Configuration ==="
echo ""

# Wildcard CORS
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "MEDIUM" "CORS Allow-Origin header found (verify not wildcard)" "$file" "$line" "$match"
done < <(rg -n --no-heading 'Access-Control-Allow-Origin' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

echo "=== MEDIUM: WebSocket Auth ==="
echo ""

# WebSocket upgrade without apparent auth
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "MEDIUM" "server.upgrade() found (verify auth before upgrade)" "$file" "$line" "$match"
done < <(rg -n --no-heading 'server\.upgrade' "$DIR" -g "*.ts" -g "*.js" 2>/dev/null || true)

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Bun security issues detected"
    exit 0
fi
