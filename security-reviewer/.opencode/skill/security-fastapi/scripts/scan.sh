#!/usr/bin/env bash
# FastAPI Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== FASTAPI SECURITY SCAN ==="
echo "Directory: $DIR"
echo "Timestamp: $(date -Iseconds)"
echo ""

if ! command -v rg &> /dev/null; then
    echo "[ERROR] ripgrep (rg) required"
    exit 1
fi

# Detect FastAPI
if ! rg -q "fastapi" "$DIR/pyproject.toml" "$DIR/requirements.txt" "$DIR/requirements-dev.txt" "$DIR/requirements*.txt" 2>/dev/null; then
    if ! rg -q "from fastapi|import fastapi" "$DIR" -g "*.py" 2>/dev/null; then
        echo "[INFO] FastAPI not detected. Skipping."
        exit 0
    fi
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

echo "=== HIGH: Missing Auth Dependencies ==="
echo ""

ROUTE_COUNT=$(rg -c "@app\.(get|post|put|patch|delete)" "$DIR" -g "*.py" 2>/dev/null | awk -F: '{sum+=$2} END {print sum+0}')
HAS_AUTH=$(rg -q "Depends\(|Security\(" "$DIR" -g "*.py" 2>/dev/null && echo "yes" || echo "no")

if [[ "$ROUTE_COUNT" -gt 0 && "$HAS_AUTH" == "no" ]]; then
    report "HIGH" "Routes detected but no Depends()/Security() usage found" "Review route auth dependencies"
fi

echo "=== HIGH: CORS Wildcard with Credentials ==="
echo ""

# Warn on allow_origins=["*"] with allow_credentials=True
if rg -q "allow_origins\s*=\s*\[\s*['\"]\*['\"]\s*\]" "$DIR" -g "*.py" 2>/dev/null; then
    if rg -q "allow_credentials\s*=\s*True" "$DIR" -g "*.py" 2>/dev/null; then
        report "HIGH" "CORS wildcard with credentials" "Set explicit allow_origins when allow_credentials=True"
    fi
fi

echo "=== MEDIUM: TrustedHostMiddleware Missing ==="
echo ""

if ! rg -q "TrustedHostMiddleware" "$DIR" -g "*.py" 2>/dev/null; then
    report "MEDIUM" "TrustedHostMiddleware not found" "Consider restricting allowed hosts in production"
fi

echo "=== LOW: HTTPSRedirectMiddleware Missing ==="
echo ""

if ! rg -q "HTTPSRedirectMiddleware" "$DIR" -g "*.py" 2>/dev/null; then
    report "LOW" "HTTPSRedirectMiddleware not found" "Ensure HTTPS enforced by proxy or middleware"
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious FastAPI security issues detected"
    exit 0
fi
