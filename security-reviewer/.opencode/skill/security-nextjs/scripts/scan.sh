#!/usr/bin/env bash
# Next.js Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== NEXT.JS SECURITY SCAN ==="
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
    local file="$3"
    local line="${4:-}"
    echo "[$severity] $title"
    if [[ -n "$line" ]]; then
        echo "  File: $file:$line"
    else
        echo "  File: $file"
    fi
    echo ""
    FOUND=$((FOUND + 1))
}

echo "=== CRITICAL: NEXT_PUBLIC_ Secrets ==="
echo ""

# Check .env files for suspicious NEXT_PUBLIC_ vars
for envfile in $(find "$DIR" -name ".env*" -type f 2>/dev/null); do
    while IFS=: read -r line_num content; do
        [[ -z "$content" ]] && continue
        # Check for suspicious patterns
        if echo "$content" | grep -qiE 'NEXT_PUBLIC_.*(SECRET|KEY|PASSWORD|TOKEN|PRIVATE)'; then
            report "CRITICAL" "Suspicious NEXT_PUBLIC_ variable (secrets exposed to client)" "$envfile" "$line_num"
        fi
    done < <(grep -n 'NEXT_PUBLIC_' "$envfile" 2>/dev/null || true)
done

echo "=== HIGH: next.config env Exposure ==="
echo ""

NEXT_CONFIG_FILE="$DIR/next.config.js"
[[ ! -f "$NEXT_CONFIG_FILE" ]] && NEXT_CONFIG_FILE="$DIR/next.config.mjs"
[[ ! -f "$NEXT_CONFIG_FILE" ]] && NEXT_CONFIG_FILE="$DIR/next.config.ts"

if [[ -f "$NEXT_CONFIG_FILE" ]]; then
    if rg -q 'env\s*:' "$NEXT_CONFIG_FILE" 2>/dev/null; then
        if rg -q '(SECRET|KEY|PASSWORD|TOKEN|PRIVATE)' "$NEXT_CONFIG_FILE" 2>/dev/null; then
            report "HIGH" "next.config env contains sensitive-looking keys (values are bundled)" "$NEXT_CONFIG_FILE"
        else
            report "MEDIUM" "next.config env detected (values are bundled to client)" "$NEXT_CONFIG_FILE"
        fi
    fi
fi

echo "=== HIGH: Unauthenticated Server Actions ==="
echo ""

# Find server action files
ACTION_FILES=$(rg -l '"use server"' "$DIR" -g "*.ts" -g "*.tsx" 2>/dev/null || true)

for file in $ACTION_FILES; do
    [[ -z "$file" ]] && continue
    
    # Check if file has auth
    if ! rg -q '(getServerSession|auth\(|getSession|currentUser|getAuthUserId)' "$file" 2>/dev/null; then
        report "HIGH" "Server Action file without auth checks" "$file"
    fi
done

echo "=== HIGH: Unauthenticated API Routes ==="
echo ""

# Find API route files (App Router)
API_ROUTES=$(find "$DIR" -path "*/app/api/*" -name "route.ts" -o -path "*/app/api/*" -name "route.js" 2>/dev/null || true)

for file in $API_ROUTES; do
    [[ -z "$file" ]] && continue
    
    if ! rg -q '(getServerSession|auth\(|getSession|NextAuth)' "$file" 2>/dev/null; then
        report "HIGH" "API route without apparent auth" "$file"
    fi
done

echo "=== MEDIUM: Middleware Matcher Gaps ==="
echo ""

MIDDLEWARE_FILE="$DIR/middleware.ts"
if [[ -f "$MIDDLEWARE_FILE" ]]; then
    # Check if matcher exists
    if ! rg -q 'matcher' "$MIDDLEWARE_FILE" 2>/dev/null; then
        report "MEDIUM" "Middleware without matcher config (applies to all routes)" "$MIDDLEWARE_FILE"
    fi
    
    # Check if /api routes are in matcher
    if rg -q 'matcher' "$MIDDLEWARE_FILE" && ! rg -q '/api' "$MIDDLEWARE_FILE"; then
        report "MEDIUM" "Middleware matcher may not cover /api routes" "$MIDDLEWARE_FILE"
    fi
fi

echo "=== MEDIUM: dangerouslySetInnerHTML ==="
echo ""

while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "MEDIUM" "dangerouslySetInnerHTML usage (XSS risk if unsanitized)" "$file" "$line"
done < <(rg -n --no-heading 'dangerouslySetInnerHTML' "$DIR" -g "*.tsx" -g "*.jsx" 2>/dev/null || true)

echo "=== INFO: Security Headers ==="
echo ""

NEXT_CONFIG="$DIR/next.config.js"
[[ ! -f "$NEXT_CONFIG" ]] && NEXT_CONFIG="$DIR/next.config.mjs"
[[ ! -f "$NEXT_CONFIG" ]] && NEXT_CONFIG="$DIR/next.config.ts"

if [[ -f "$NEXT_CONFIG" ]]; then
    if ! rg -q 'headers' "$NEXT_CONFIG" 2>/dev/null; then
        report "LOW" "No security headers configured in next.config" "$NEXT_CONFIG"
    fi
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Next.js security issues detected"
    exit 0
fi
