#!/usr/bin/env bash
# Security Secrets Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== SECURITY SECRETS SCAN ==="
echo "Directory: $DIR"
echo "Timestamp: $(date -Iseconds)"
echo ""

# Check if rg (ripgrep) is available, fall back to grep
if command -v rg &> /dev/null; then
    GREP_CMD="rg -n --no-heading"
else
    GREP_CMD="grep -rn"
    echo "[WARN] ripgrep not found, using grep (slower)"
fi

scan_pattern() {
    local name="$1"
    local pattern="$2"
    local severity="${3:-HIGH}"
    
    echo "## Scanning: $name"
    
    local results
    results=$($GREP_CMD -E "$pattern" "$DIR" 2>/dev/null || true)
    
    if [[ -n "$results" ]]; then
        echo "[${severity}] Found potential $name:"
        echo "$results" | head -20
        if [[ $(echo "$results" | wc -l) -gt 20 ]]; then
            echo "... and more (truncated)"
        fi
        echo ""
        FOUND=$((FOUND + 1))
    fi
}

echo "=== HIGH-CONFIDENCE PATTERNS ==="
echo ""

# AWS
scan_pattern "AWS Access Key" "AKIA[0-9A-Z]{16}" "CRITICAL"
scan_pattern "AWS Secret Key" "aws.{0,20}['\"][0-9a-zA-Z/+]{40}['\"]" "CRITICAL"

# Google
scan_pattern "Google API Key" "AIza[0-9A-Za-z_-]{35}" "CRITICAL"

# GitHub
scan_pattern "GitHub Token" "gh[pousr]_[A-Za-z0-9_]{36,}" "CRITICAL"
scan_pattern "GitHub PAT" "github_pat_[A-Za-z0-9_]{22,}" "CRITICAL"

# Stripe
scan_pattern "Stripe Secret Key" "sk_(live|test)_[0-9a-zA-Z]{24,}" "CRITICAL"
scan_pattern "Stripe Restricted Key" "rk_(live|test)_[0-9a-zA-Z]{24,}" "HIGH"
scan_pattern "Stripe Publishable Key" "pk_(live|test)_[0-9a-zA-Z]{24,}" "MEDIUM"

# Slack
scan_pattern "Slack Bot/User Token" "xox[baprs]-[A-Za-z0-9-]{10,}" "CRITICAL"
scan_pattern "Slack App Token" "xapp-[A-Za-z0-9-]{10,}" "CRITICAL"
scan_pattern "Slack Workflow Token" "xwfp-[A-Za-z0-9-]{10,}" "CRITICAL"

# Private Keys
scan_pattern "Private Key" "BEGIN (RSA|EC|DSA|OPENSSH|PGP) PRIVATE KEY" "CRITICAL"

# OpenAI / Anthropic
scan_pattern "OpenAI Key" "sk-[A-Za-z0-9]{48}" "CRITICAL"
scan_pattern "Anthropic Key" "sk-ant-[A-Za-z0-9-]{32,}" "CRITICAL"

# Database URLs with passwords
scan_pattern "Database URL with Password" "(postgres|mysql|mongodb|redis)://[^:]+:[^@]+@" "CRITICAL"

# Generic patterns
scan_pattern "Password in URL" "[a-zA-Z]{3,10}://[^/\:@]+:[^/\:@]+@" "HIGH"

echo "=== MEDIUM-CONFIDENCE PATTERNS ==="
echo ""

scan_pattern "Generic API Key Assignment" "(api[_-]?key|apikey|secret[_-]?key)['\"]?\s*[:=]\s*['\"][A-Za-z0-9]{16,}['\"]" "MEDIUM"
scan_pattern "JWT Secret" "(jwt[_-]?secret|token[_-]?secret)['\"]?\s*[:=]\s*['\"][^'\"]+['\"]" "MEDIUM"
scan_pattern "Password Assignment" "password['\"]?\s*[:=]\s*['\"][^'\"]{8,}['\"]" "MEDIUM"

echo "=== FILES TO CHECK MANUALLY ==="
echo ""

# Check for .env files
if find "$DIR" -name ".env*" -type f 2>/dev/null | grep -q .; then
    echo "[WARN] Found .env files (check if committed to git):"
    find "$DIR" -name ".env*" -type f 2>/dev/null
    echo ""
    FOUND=$((FOUND + 1))
fi

# Check for key/pem files
if find "$DIR" -name "*.pem" -o -name "*.key" -o -name "*.p12" 2>/dev/null | grep -q .; then
    echo "[WARN] Found potential key files:"
    find "$DIR" \( -name "*.pem" -o -name "*.key" -o -name "*.p12" \) 2>/dev/null
    echo ""
    FOUND=$((FOUND + 1))
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issue categories. Review above."
    exit 1
else
    echo "[✓] No obvious secrets detected (manual review still recommended)"
    exit 0
fi
