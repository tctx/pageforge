#!/bin/bash
# PageForge — Deploy to Vercel
#
# Quick start (after vercel login):
#   ./deploy.sh
#
# Or with token:
#   VERCEL_TOKEN=xxx ./deploy.sh
#
# Or via vault:
#   bash ~/Desktop/test/longshanks/scripts/vault-manager.sh --add VERCEL_TOKEN <token>
#   ./deploy.sh

set -euo pipefail
cd "$(dirname "$0")"

PROJECT_NAME="pageforge-gen"  # pageforge.vercel.app is taken

echo "============================================"
echo "  PageForge — Vercel Deploy"
echo "============================================"
echo ""

# ── Source vault if VERCEL_TOKEN not already set ──
VAULT_FILE="$HOME/Desktop/tooling/vault/.env"
if [ -z "${VERCEL_TOKEN:-}" ] && [ -f "$VAULT_FILE" ]; then
  VAULT_TOKEN=$(grep '^VERCEL_TOKEN=' "$VAULT_FILE" 2>/dev/null | cut -d'=' -f2- || true)
  if [ -n "$VAULT_TOKEN" ]; then
    export VERCEL_TOKEN="$VAULT_TOKEN"
    echo "▸ Loaded VERCEL_TOKEN from vault"
  fi
fi

# ── Check auth ──
AUTH_FLAG=""
if [ -n "${VERCEL_TOKEN:-}" ]; then
  AUTH_FLAG="--token $VERCEL_TOKEN"
  echo "▸ Using VERCEL_TOKEN for authentication"
else
  if vercel whoami &>/dev/null; then
    VERCEL_USER=$(vercel whoami 2>/dev/null)
    echo "▸ Authenticated as: $VERCEL_USER"
  else
    echo "✗ No Vercel credentials found."
    echo ""
    echo "  Option 1 — Browser login (easiest):"
    echo "    vercel login"
    echo ""
    echo "  Option 2 — Token (headless):"
    echo "    1. Go to https://vercel.com/account/tokens"
    echo "    2. Create a token"
    echo "    3. Run: VERCEL_TOKEN=<token> ./deploy.sh"
    echo ""
    echo "  Option 3 — Vercel Dashboard (no CLI):"
    echo "    1. Go to https://vercel.com/new"
    echo "    2. Import: github.com/tctx/pageforge"
    echo "    3. Deploy (auto-detects static site)"
    exit 1
  fi
fi

# ── Link project if first deploy ──
if [ ! -d ".vercel" ]; then
  echo ""
  echo "▸ First deploy — linking project as '$PROJECT_NAME'..."
  vercel link --yes --project "$PROJECT_NAME" $AUTH_FLAG 2>&1 || {
    echo "  Creating new project '$PROJECT_NAME'..."
    vercel --yes --name "$PROJECT_NAME" $AUTH_FLAG 2>&1
  }
fi

# ── Deploy to production ──
echo ""
echo "▸ Deploying to production..."
DEPLOY_OUTPUT=$(vercel --prod --yes $AUTH_FLAG 2>&1)
echo "$DEPLOY_OUTPUT"
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -oE 'https://[^ ]+' | tail -1)

echo ""
echo "============================================"
echo "  ✓ Deploy complete!"
echo "============================================"
echo ""
echo "  URL: ${DEPLOY_URL:-check https://vercel.com/dashboard}"
echo ""
echo "  Post-deploy checklist:"
echo "  [ ] Verify site loads at the URL above"
echo "  [ ] Update Stripe success redirect URL to your Vercel domain"
echo "      (see STRIPE-SETUP.md, Step 3)"
echo "  [ ] Consider adding a custom domain in Vercel dashboard"
echo ""
