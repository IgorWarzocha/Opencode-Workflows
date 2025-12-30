#!/usr/bin/env bash
# AI API Key Leakage Scanner - First-pass automated detection
# Usage: ./scan.sh [directory]

set -euo pipefail

DIR="${1:-.}"
FOUND=0

echo "=== AI API KEY LEAKAGE SCAN ==="
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

echo "=== CRITICAL: Client-Exposed Env Vars ==="
echo ""

# NEXT_PUBLIC_ / VITE_ with AI key names
if rg -q "(NEXT_PUBLIC_|VITE_).*(OPENAI|OPENROUTER|ANTHROPIC|GEMINI|GOOGLE|VERTEX|BEDROCK|AWS|AZURE|MISTRAL|COHERE|GROQ|PERPLEXITY|TOGETHER|REPLICATE|FIREWORKS|HUGGINGFACE|HF_)" "$DIR" -g "*.env*" 2>/dev/null; then
    report "CRITICAL" "AI keys appear in client-exposed env vars" "Remove from NEXT_PUBLIC_/VITE_ and move to server"
fi

echo "=== HIGH: AI API Endpoints in Client Code ==="
echo ""

if rg -q "api\.openai\.com|openrouter\.ai|api\.anthropic\.com|generativelanguage\.googleapis\.com|aiplatform\.googleapis\.com|bedrock.*amazonaws\.com|api\.mistral\.ai|api\.cohere\.ai|api\.groq\.com|api\.together\.xyz|api\.perplexity\.ai|api\.replicate\.com|api\.fireworks\.ai|openai\.azure\.com" "$DIR" -g "*.js" -g "*.ts" -g "*.jsx" -g "*.tsx" -g "*.vue" 2>/dev/null; then
    report "HIGH" "AI API endpoint used in client code" "Verify calls are server-side and keys are not exposed"
fi

echo "=== HIGH: Cloud AI Credentials in Repo ==="
echo ""

if rg -q "\"type\"\s*:\s*\"service_account\"|GOOGLE_APPLICATION_CREDENTIALS|AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY|AWS_SESSION_TOKEN|AZURE_OPENAI_API_KEY|AZURE_OPENAI_ENDPOINT" "$DIR" -g "*.env*" -g "*.json" 2>/dev/null; then
    report "HIGH" "Cloud AI credentials found" "Verify files are not committed and rotate if exposed"
fi

echo "=== HIGH: Possible AI Keys in Repo (Heuristic) ==="
echo ""

if rg -q "sk-[A-Za-z0-9]{20,}|sk-ant-[A-Za-z0-9-]{20,}|sk-or-[A-Za-z0-9-]{20,}|AIza[0-9A-Za-z_-]{35}|hf_[A-Za-z0-9]{20,}" "$DIR" 2>/dev/null; then
    report "HIGH" "Possible AI API keys detected (heuristic)" "Rotate keys immediately if real"
fi

echo "=== MEDIUM: Build Artifacts Present ==="
echo ""

if [[ -d "$DIR/dist" || -d "$DIR/build" || -d "$DIR/.next" ]]; then
    report "MEDIUM" "Build artifacts found" "Scan bundles for embedded secrets"
fi

echo "=== SUMMARY ==="
if [[ $FOUND -gt 0 ]]; then
    echo "[!] Found $FOUND potential issues. Review above."
    exit 1
else
    echo "[✓] No obvious AI key leakage issues detected"
    exit 0
fi
