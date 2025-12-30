#!/usr/bin/env bash
# Master Security Scanner - Runs all applicable security scans
# Usage: ./scan-all.sh [directory]

set -euo pipefail

DIR="${1:-.}"
SKILL_DIR="$(dirname "$0")/.."
TOTAL_ISSUES=0

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           SECURITY SCAN - VIBECODING VULNERABILITY         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Directory: $DIR"
echo "Timestamp: $(date -Iseconds)"
echo ""

run_scan() {
    local name="$1"
    local script="$2"
    local condition="$3"
    
    if eval "$condition"; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Running: $name"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        if "$script" "$DIR"; then
            echo "[✓] $name: No issues found"
        else
            echo "[!] $name: Issues detected"
            TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
        fi
    fi
}

# Always run secrets scan
run_scan "Secrets Scan" \
    ~/.config/opencode/skill/security-secrets/scripts/scan.sh \
    "true"

# Always run AI keys scan
run_scan "AI Keys Scan" \
    ~/.config/opencode/skill/security-ai-keys/scripts/scan.sh \
    "true"

# Convex
run_scan "Convex Scan" \
    ~/.config/opencode/skill/security-convex/scripts/scan.sh \
    "[[ -d '$DIR/convex' ]]"

# Next.js
run_scan "Next.js Scan" \
    ~/.config/opencode/skill/security-nextjs/scripts/scan.sh \
    "[[ -f '$DIR/next.config.js' || -f '$DIR/next.config.mjs' || -f '$DIR/next.config.ts' ]]"

# Vite
run_scan "Vite Scan" \
    ~/.config/opencode/skill/security-vite/scripts/scan.sh \
    "[[ -f '$DIR/vite.config.ts' || -f '$DIR/vite.config.js' ]]"

# Bun
run_scan "Bun Scan" \
    ~/.config/opencode/skill/security-bun/scripts/scan.sh \
    "[[ -f '$DIR/bun.lockb' || -f '$DIR/bunfig.toml' ]]"

# Express (check package.json for express)
run_scan "Express Scan" \
    ~/.config/opencode/skill/security-express/scripts/scan.sh \
    "[[ -f '$DIR/package.json' ]] && grep -q '\"express\"' '$DIR/package.json' 2>/dev/null"

# Django
run_scan "Django Scan" \
    ~/.config/opencode/skill/security-django/scripts/scan.sh \
    "[[ -f '$DIR/manage.py' || -n \"\$(find '$DIR' -name 'settings.py' -type f 2>/dev/null | head -1)\" ]]"

# FastAPI
run_scan "FastAPI Scan" \
    ~/.config/opencode/skill/security-fastapi/scripts/scan.sh \
    "[[ -f '$DIR/pyproject.toml' ]] && grep -qi 'fastapi' '$DIR/pyproject.toml' 2>/dev/null || [[ -f '$DIR/requirements.txt' ]] && grep -qi 'fastapi' '$DIR/requirements.txt' 2>/dev/null || [[ -n \"\$(find '$DIR' -name 'requirements*.txt' -type f 2>/dev/null | head -1)\" ]] && grep -qi 'fastapi' \$(find '$DIR' -name 'requirements*.txt' -type f 2>/dev/null | head -1) 2>/dev/null"

# Docker
run_scan "Docker Scan" \
    ~/.config/opencode/skill/security-docker/scripts/scan.sh \
    "[[ -f '$DIR/Dockerfile' || -f '$DIR/docker-compose.yml' || -f '$DIR/docker-compose.yaml' ]]"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                      FINAL SUMMARY                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [[ $TOTAL_ISSUES -gt 0 ]]; then
    echo "[!] $TOTAL_ISSUES scan(s) found potential security issues."
    echo ""
    echo "Next steps:"
    echo "  1. Review each finding above"
    echo "  2. Use 'security review' command for detailed analysis"
    echo "  3. Prioritize CRITICAL and HIGH severity items"
    exit 1
else
    echo "[✓] All scans passed. No obvious issues detected."
    echo ""
    echo "Note: Automated scans catch common patterns only."
    echo "Manual review is still recommended for production code."
    exit 0
fi
