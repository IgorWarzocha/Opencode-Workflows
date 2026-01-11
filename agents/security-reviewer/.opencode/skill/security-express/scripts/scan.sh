#!/usr/bin/env bash
# Express Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== EXPRESS SECURITY SCAN ==="
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
    local details="${3:-}"
    echo "[$severity] $title"
    [[ -n "$details" ]] && echo "  $details"
    echo ""
    FOUND=$((FOUND + 1))
}

echo "=== CHECKING: Helmet.js ==="
echo ""

if [[ -f "$DIR/package.json" ]]; then
    if ! rg -q '"helmet"' "$DIR/package.json" 2>/dev/null; then
        report "MEDIUM" "Helmet.js not in dependencies" "Install with: npm install helmet"
    else
        # Check if it's actually used
        if ! rg -q 'helmet\(\)' "$DIR" -g "*.js" -g "*.ts" 2>/dev/null; then
            report "MEDIUM" "Helmet.js installed but not used" "Add: app.use(helmet())"
        else
            echo "[✓] Helmet.js is installed and appears to be used"
        fi
    fi
fi
echo ""

echo "=== LOW: X-Powered-By Header ==="
echo ""

if ! rg -q "x-powered-by" "$DIR" -g "*.js" -g "*.ts" 2>/dev/null; then
    report "LOW" "x-powered-by not explicitly disabled (framework fingerprinting)" "Add: app.disable('x-powered-by')"
else
    echo "[✓] x-powered-by appears to be configured"
fi
echo ""

echo "=== CRITICAL: CORS Misconfiguration ==="
echo ""

# Wildcard CORS
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    if echo "$match" | grep -qE "origin.*['\"]\*['\"]|origin.*true|cors\(\)"; then
        report "HIGH" "Permissive CORS configuration" "$file:$line"
    fi
done < <(rg -n --no-heading 'cors\(' "$DIR" -g "*.js" -g "*.ts" -A 3 2>/dev/null || true)

echo "=== HIGH: SQL Injection Patterns ==="
echo ""

# String interpolation in queries
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "Potential SQL injection (string interpolation in query)" "$file:$line"
done < <(rg -n --no-heading '(query|execute)\s*\(\s*`' "$DIR" -g "*.js" -g "*.ts" 2>/dev/null || true)

# String concatenation in queries
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "Potential SQL injection (string concatenation)" "$file:$line"
done < <(rg -n --no-heading 'SELECT.*\+.*req\.' "$DIR" -g "*.js" -g "*.ts" 2>/dev/null || true)

echo "=== HIGH: Session Security ==="
echo ""

# Hardcoded session secret
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    if echo "$match" | grep -qE "secret.*['\"][^'\"]{5,}['\"]" && ! echo "$match" | grep -qE "process\.env|env\."; then
        report "HIGH" "Potential hardcoded session secret" "$file:$line"
    fi
done < <(rg -n --no-heading 'session\(' "$DIR" -g "*.js" -g "*.ts" -A 5 2>/dev/null || true)

# Insecure cookie settings
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    if echo "$match" | grep -qE "secure.*false"; then
        report "MEDIUM" "Session cookie secure:false (not HTTPS-only)" "$file:$line"
    fi
done < <(rg -n --no-heading 'cookie.*{' "$DIR" -g "*.js" -g "*.ts" -A 5 2>/dev/null || true)

echo "=== MEDIUM: Rate Limiting ==="
echo ""

if [[ -f "$DIR/package.json" ]]; then
    if ! rg -q '"express-rate-limit"' "$DIR/package.json" 2>/dev/null; then
        report "MEDIUM" "No rate limiting package found" "Consider: npm install express-rate-limit"
    fi
fi

echo "=== MEDIUM: Body Parser Limits ==="
echo ""

# Check for body parser without limits
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    if ! echo "$match" | grep -qE "limit"; then
        report "LOW" "Body parser without size limit (DoS risk)" "$file:$line"
    fi
done < <(rg -n --no-heading 'express\.json\(|express\.urlencoded\(' "$DIR" -g "*.js" -g "*.ts" 2>/dev/null || true)

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Express security issues detected"
    exit 0
fi
