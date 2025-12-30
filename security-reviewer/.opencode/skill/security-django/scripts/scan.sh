#!/usr/bin/env bash
# Django Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== DJANGO SECURITY SCAN ==="
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

# Find settings files
SETTINGS_FILES=$(find "$DIR" -name "settings*.py" -type f 2>/dev/null || true)

if [[ -z "$SETTINGS_FILES" ]]; then
    echo "[INFO] No settings.py found. Is this a Django project?"
    exit 0
fi

for SETTINGS in $SETTINGS_FILES; do
    echo "=== Checking: $SETTINGS ==="
    echo ""
    
    # SECRET_KEY
    echo "## SECRET_KEY"
    if rg -q "SECRET_KEY.*=.*['\"][^'\"]+['\"]" "$SETTINGS" 2>/dev/null; then
        if ! rg -q "SECRET_KEY.*os\.environ|SECRET_KEY.*env\(" "$SETTINGS" 2>/dev/null; then
            report "CRITICAL" "SECRET_KEY appears hardcoded" "$SETTINGS"
        fi
    fi
    
    # DEBUG
    echo "## DEBUG"
    if rg -q "^DEBUG\s*=\s*True" "$SETTINGS" 2>/dev/null; then
        report "CRITICAL" "DEBUG = True (should be False in production)" "$SETTINGS"
    fi
    
    # ALLOWED_HOSTS
    echo "## ALLOWED_HOSTS"
    if rg -q "ALLOWED_HOSTS.*\*" "$SETTINGS" 2>/dev/null; then
        report "CRITICAL" "ALLOWED_HOSTS contains wildcard" "$SETTINGS"
    fi
    if rg -q "ALLOWED_HOSTS\s*=\s*\[\s*\]" "$SETTINGS" 2>/dev/null; then
        report "HIGH" "ALLOWED_HOSTS is empty" "$SETTINGS"
    fi
    
    # Security middleware
    echo "## Security Middleware"
    if ! rg -q "SecurityMiddleware" "$SETTINGS" 2>/dev/null; then
        report "HIGH" "SecurityMiddleware not found in MIDDLEWARE" "$SETTINGS"
    fi
    
    # CSRF
    echo "## CSRF"
    if ! rg -q "CsrfViewMiddleware" "$SETTINGS" 2>/dev/null; then
        report "CRITICAL" "CsrfViewMiddleware not found (CSRF disabled?)" "$SETTINGS"
    fi
    
    # Cookie security
    echo "## Cookie Security"
    if ! rg -q "SESSION_COOKIE_SECURE\s*=\s*True" "$SETTINGS" 2>/dev/null; then
        report "MEDIUM" "SESSION_COOKIE_SECURE not set to True" "$SETTINGS"
    fi
    if ! rg -q "CSRF_COOKIE_SECURE\s*=\s*True" "$SETTINGS" 2>/dev/null; then
        report "MEDIUM" "CSRF_COOKIE_SECURE not set to True" "$SETTINGS"
    fi
    if ! rg -q "SECURE_SSL_REDIRECT\s*=\s*True" "$SETTINGS" 2>/dev/null; then
        report "MEDIUM" "SECURE_SSL_REDIRECT not set to True" "$SETTINGS"
    fi
    
    echo ""
done

echo "=== CRITICAL: csrf_exempt Usage ==="
echo ""

while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "@csrf_exempt decorator (needs justification)" "$file" "$line"
done < <(rg -n --no-heading '@csrf_exempt' "$DIR" -g "*.py" 2>/dev/null || true)

echo "=== HIGH: Raw SQL Queries ==="
echo ""

while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "Raw SQL query (check for string interpolation)" "$file" "$line"
done < <(rg -n --no-heading '\.raw\(|cursor\.execute\(' "$DIR" -g "*.py" 2>/dev/null || true)

echo "=== HIGH: Shell Commands ==="
echo ""

while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    if echo "$match" | grep -q "shell.*=.*True"; then
        report "HIGH" "subprocess with shell=True (command injection risk)" "$file" "$line"
    fi
done < <(rg -n --no-heading 'subprocess\.' "$DIR" -g "*.py" 2>/dev/null || true)

while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "os.system usage (command injection risk)" "$file" "$line"
done < <(rg -n --no-heading 'os\.system\(' "$DIR" -g "*.py" 2>/dev/null || true)

echo "=== MEDIUM: Missing Auth Decorators ==="
echo ""

# Find view functions without decorators (heuristic)
VIEW_FILES=$(find "$DIR" -name "views.py" -type f 2>/dev/null || true)
for view_file in $VIEW_FILES; do
    # Count functions without common auth decorators above them
    UNDECORATED=$(rg -B2 '^def [a-z_]+\(request' "$view_file" 2>/dev/null | grep -c '^def' || echo 0)
    DECORATED=$(rg -B2 '^def [a-z_]+\(request' "$view_file" 2>/dev/null | grep -cE '@(login_required|permission_required|user_passes_test)' || echo 0)
    
    if [[ $UNDECORATED -gt 0 && $DECORATED -lt $UNDECORATED ]]; then
        report "MEDIUM" "Some view functions may lack auth decorators" "$view_file"
    fi
done

echo "=== INFO: Deployment Checklist ==="
echo ""
echo "Consider running: python manage.py check --deploy"
echo ""

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Django security issues detected"
    exit 0
fi
