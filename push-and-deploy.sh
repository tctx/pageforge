#!/bin/bash
# PageForge — Push to GitHub + Deploy to Vercel
#
# Usage:
#   VERCEL_TOKEN=xxx ./push-and-deploy.sh
#   (or add VERCEL_TOKEN to vault first)

set -euo pipefail
cd "$(dirname "$0")"

echo "============================================"
echo "  PageForge — Push & Deploy"
echo "============================================"
echo ""

# ── Step 0: Source vault for VERCEL_TOKEN ──
VAULT_FILE="$HOME/Desktop/tooling/vault/.env"
if [ -z "${VERCEL_TOKEN:-}" ] && [ -f "$VAULT_FILE" ]; then
    VAULT_TOKEN=$(grep '^VERCEL_TOKEN=' "$VAULT_FILE" 2>/dev/null | cut -d'=' -f2- || true)
    if [ -n "$VAULT_TOKEN" ]; then
        export VERCEL_TOKEN="$VAULT_TOKEN"
        echo "▸ Loaded VERCEL_TOKEN from vault"
    fi
fi

# ── Step 1: Check Vercel auth ──
echo "▸ Checking Vercel credentials..."
if [ -n "${VERCEL_TOKEN:-}" ]; then
    AUTH_FLAG="--token $VERCEL_TOKEN"
    echo "  ✓ Using VERCEL_TOKEN"
elif vercel whoami &>/dev/null; then
    AUTH_FLAG=""
    VERCEL_USER=$(vercel whoami 2>/dev/null)
    echo "  ✓ Vercel authenticated as $VERCEL_USER"
else
    echo "  ✗ No Vercel credentials found."
    echo "    Add token: bash ~/Desktop/test/longshanks/scripts/vault-manager.sh --add VERCEL_TOKEN <token>"
    echo "    Or pass:   VERCEL_TOKEN=xxx ./push-and-deploy.sh"
    exit 1
fi

# ── Step 2: Push latest code to GitHub ──
echo ""
echo "▸ Pushing latest code to GitHub..."
git push origin main 2>&1 && echo "  ✓ Code pushed" || echo "  ⚠ Push failed or nothing to push"

# ── Step 3: Deploy to Vercel ──
echo ""
echo "▸ Deploying to Vercel (production)..."
DEPLOY_OUTPUT=$(vercel --prod --yes $AUTH_FLAG 2>&1)
echo "$DEPLOY_OUTPUT"
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -oE 'https://[^ ]+' | tail -1)
echo "  ✓ Deployed to Vercel"

echo ""
echo "============================================"
echo "  ✓ ALL DONE"
echo "============================================"
echo ""
echo "Live URL: ${DEPLOY_URL:-check Vercel dashboard}"
echo ""
echo "Next steps:"
echo "  1. Verify the live URL works"
echo "  2. Add a custom domain in Vercel if desired"
echo "  3. Update Stripe success redirect URL to your live domain"
echo "     (see STRIPE-SETUP.md for details)"
echo ""
