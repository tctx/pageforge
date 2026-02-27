#!/bin/bash
# PageForge — Deploy to Vercel
# Usage:
#   Option A: VERCEL_TOKEN=xxx ./deploy.sh
#   Option B: Add VERCEL_TOKEN to vault, then ./deploy.sh
#   Option C: vercel login (then run this script)

set -euo pipefail
cd "$(dirname "$0")"

echo "=== PageForge Vercel Deploy ==="

# Source vault if VERCEL_TOKEN not already set
VAULT_FILE="$HOME/Desktop/tooling/vault/.env"
if [ -z "${VERCEL_TOKEN:-}" ] && [ -f "$VAULT_FILE" ]; then
  VAULT_TOKEN=$(grep '^VERCEL_TOKEN=' "$VAULT_FILE" 2>/dev/null | cut -d'=' -f2- || true)
  if [ -n "$VAULT_TOKEN" ]; then
    export VERCEL_TOKEN="$VAULT_TOKEN"
    echo "Loaded VERCEL_TOKEN from vault"
  fi
fi

# Check auth
if [ -n "${VERCEL_TOKEN:-}" ]; then
  AUTH_FLAG="--token $VERCEL_TOKEN"
  echo "Using VERCEL_TOKEN for authentication"
else
  if vercel whoami &>/dev/null; then
    AUTH_FLAG=""
    echo "Using existing Vercel login session"
  else
    echo "ERROR: No Vercel credentials found."
    echo ""
    echo "  Add token to vault:"
    echo "    bash ~/Desktop/test/longshanks/scripts/vault-manager.sh --add VERCEL_TOKEN <your-token>"
    echo ""
    echo "  Or pass directly:"
    echo "    VERCEL_TOKEN=xxx ./deploy.sh"
    echo ""
    echo "  Get a token at: https://vercel.com/account/tokens"
    exit 1
  fi
fi

# Deploy to production
echo ""
echo "Deploying PageForge to production..."
DEPLOY_OUTPUT=$(vercel --prod --yes $AUTH_FLAG 2>&1)
echo "$DEPLOY_OUTPUT"
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -oE 'https://[^ ]+' | tail -1)

echo ""
echo "Deploy complete!"
echo "URL: ${DEPLOY_URL:-check Vercel dashboard}"
