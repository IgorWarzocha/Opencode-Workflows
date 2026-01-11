#!/usr/bin/env bash
# Convex Security Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
CONVEX_DIR="$DIR/convex"
FOUND=0

echo "=== CONVEX SECURITY SCAN ==="
echo "Directory: $DIR"
echo "Timestamp: $(date -Iseconds)"
echo ""

if [[ ! -d "$CONVEX_DIR" ]]; then
    echo "[INFO] No convex/ directory found. Skipping Convex-specific checks."
    exit 0
fi

if ! command -v rg &> /dev/null; then
    echo "[ERROR] ripgrep (rg) required. Install with: brew install ripgrep"
    exit 1
fi

report() {
    local severity="$1"
    local title="$2"
    local file="$3"
    local line="$4"
    echo "[$severity] $title"
    echo "  File: $file:$line"
    echo ""
    FOUND=$((FOUND + 1))
}

echo "=== CRITICAL: Unauthenticated Public Functions ==="
echo ""

# Find all query/mutation exports
QUERY_FILES=$(rg -l 'export const .* = (query|mutation)\(' "$CONVEX_DIR" -g "*.ts" 2>/dev/null || true)

for file in $QUERY_FILES; do
    [[ -z "$file" ]] && continue
    
    # Check if file has auth imports/calls
    if ! rg -q '(getAuthUserId|getUserIdentity|ctx\.auth)' "$file" 2>/dev/null; then
        # Get the function names
        FUNCS=$(rg -n 'export const (\w+) = (query|mutation)\(' "$file" -o -r '$1' 2>/dev/null || true)
        if [[ -n "$FUNCS" ]]; then
            echo "[CRITICAL] File has public functions without auth checks:"
            echo "  File: $file"
            echo "  Functions: $(echo $FUNCS | tr '\n' ', ')"
            echo ""
            FOUND=$((FOUND + 1))
        fi
    fi
done

echo "=== HIGH: Client-Provided userId (IDOR Risk) ==="
echo ""

# userId in args
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "userId in function args (should come from auth context)" "$file" "$line"
done < <(rg -n --no-heading 'userId:\s*v\.id\(["'\''](users)["'\''\)]' "$CONVEX_DIR" -g "*.ts" 2>/dev/null || true)

echo "=== HIGH: Missing Validators ==="
echo ""

# Functions without args object
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "HIGH" "Function handler without args validation" "$file" "$line"
done < <(rg -n --no-heading 'handler:\s*async\s*\(ctx\)\s*=>' "$CONVEX_DIR" -g "*.ts" 2>/dev/null || true)

echo "=== MEDIUM: HTTP Actions ==="
echo ""

# httpAction usage
while IFS=: read -r file line match; do
    [[ -z "$file" ]] && continue
    report "MEDIUM" "HTTP action found (verify authentication)" "$file" "$line"
done < <(rg -n --no-heading 'httpAction' "$CONVEX_DIR" -g "*.ts" 2>/dev/null || true)

echo "=== INFO: Internal vs Public Functions ==="
echo ""

# Count internal vs public
PUBLIC_COUNT=$(rg -c 'export const .* = (query|mutation|action)\(' "$CONVEX_DIR" -g "*.ts" 2>/dev/null | awk -F: '{sum+=$2} END {print sum+0}')
INTERNAL_COUNT=$(rg -c 'export const .* = internal(Query|Mutation|Action)\(' "$CONVEX_DIR" -g "*.ts" 2>/dev/null | awk -F: '{sum+=$2} END {print sum+0}')

echo "Public functions: $PUBLIC_COUNT"
echo "Internal functions: $INTERNAL_COUNT"
echo ""

if [[ $PUBLIC_COUNT -gt 0 && $INTERNAL_COUNT -eq 0 ]]; then
    echo "[WARN] No internal functions found. Consider using internalMutation/internalAction for sensitive operations."
    FOUND=$((FOUND + 1))
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious Convex security issues detected"
    exit 0
fi
