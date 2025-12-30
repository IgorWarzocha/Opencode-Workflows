#!/usr/bin/env bash
# Vite Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== VITE SECURITY SCAN ==="
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

echo "=== CRITICAL: VITE_ Secrets ==="
echo ""

# Check .env files for suspicious VITE_ vars
for envfile in $(find "$DIR" -name ".env*" -type f 2>/dev/null); do
    while IFS=: read -r line_num content; do
        [[ -z "$content" ]] && continue
        if echo "$content" | grep -qiE 'VITE_.*(SECRET|KEY|PASSWORD|TOKEN|PRIVATE|API_KEY)'; then
            report "CRITICAL" "Suspicious VITE_ variable (bundled into client)" "$envfile" "$line_num"
        fi
    done < <(grep -n 'VITE_' "$envfile" 2>/dev/null || true)
done

echo "=== HIGH: Secrets in vite.config ==="
echo ""

VITE_CONFIG=$(find "$DIR" -maxdepth 1 -name "vite.config.*" 2>/dev/null | head -1)

if [[ -n "$VITE_CONFIG" && -f "$VITE_CONFIG" ]]; then
    # Check for define with process.env
    if rg -q 'define:.*process\.env' "$VITE_CONFIG" 2>/dev/null; then
        report "HIGH" "process.env in define block (may expose secrets to client)" "$VITE_CONFIG"
    fi

    # Check for envPrefix overrides
    if rg -q 'envPrefix' "$VITE_CONFIG" 2>/dev/null; then
        report "MEDIUM" "envPrefix configured (verify only public prefixes are exposed)" "$VITE_CONFIG"
    fi
    
    # Check for 0.0.0.0 binding
    if rg -q 'host.*0\.0\.0\.0|host.*true' "$VITE_CONFIG" 2>/dev/null; then
        report "MEDIUM" "Dev server exposed to network" "$VITE_CONFIG"
    fi
    
    # Check for sourcemaps in production
    if rg -q 'sourcemap.*true' "$VITE_CONFIG" 2>/dev/null; then
        report "MEDIUM" "Source maps enabled (check if production)" "$VITE_CONFIG"
    fi
fi

echo "=== MEDIUM: .env files ==="
echo ""

# Check if .env.local is in gitignore
if [[ -f "$DIR/.env.local" ]]; then
    if [[ -f "$DIR/.gitignore" ]]; then
        if ! grep -q '\.env\.local' "$DIR/.gitignore" 2>/dev/null; then
            report "MEDIUM" ".env.local exists but may not be in .gitignore" "$DIR/.env.local"
        fi
    else
        report "MEDIUM" ".env.local exists and no .gitignore found" "$DIR/.env.local"
    fi
fi

# Check if any .env.*.local files are gitignored
ENV_LOCAL_FILES=$(find "$DIR" -name ".env.*.local" -type f 2>/dev/null | head -5 || true)
if [[ -n "$ENV_LOCAL_FILES" ]]; then
    if [[ -f "$DIR/.gitignore" ]]; then
        if ! grep -q '\.env\.\*\.local' "$DIR/.gitignore" 2>/dev/null && ! grep -q '\.env\.local' "$DIR/.gitignore" 2>/dev/null; then
            report "MEDIUM" ".env.*.local exists but may not be in .gitignore" "$DIR/.gitignore"
        fi
    else
        report "MEDIUM" ".env.*.local exists and no .gitignore found" "$DIR/.gitignore"
    fi
fi

echo "=== INFO: Check Built Bundle ==="
echo ""

if [[ -d "$DIR/dist" ]]; then
    echo "[INFO] Built bundle found at $DIR/dist"
    echo "Scanning for exposed secrets in bundle..."
    
    BUNDLE_SECRETS=$(rg -a '(sk_live_|sk_test_|AKIA[0-9A-Z]{16}|ghp_|api[_-]?key)' "$DIR/dist" 2>/dev/null || true)
    
    if [[ -n "$BUNDLE_SECRETS" ]]; then
        report "CRITICAL" "Secrets found in built bundle!" "$DIR/dist"
        echo "$BUNDLE_SECRETS" | head -10
        echo ""
    fi
    
    # Check for source maps
    MAPS=$(find "$DIR/dist" -name "*.map" 2>/dev/null | head -5)
    if [[ -n "$MAPS" ]]; then
        report "MEDIUM" "Source map files in dist/ (exposes source code)" "$DIR/dist"
    fi
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Vite security issues detected"
    exit 0
fi
