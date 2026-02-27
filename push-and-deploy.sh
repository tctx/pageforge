#!/bin/bash
# PageForge — Push to GitHub + Deploy to Vercel
#
# Usage (after vercel login):
#   ./push-and-deploy.sh
#
# Or with token:
#   VERCEL_TOKEN=xxx ./push-and-deploy.sh

set -euo pipefail
cd "$(dirname "$0")"

PROJECT_NAME="pageforge-gen"  # pageforge.vercel.app is taken

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
AUTH_FLAG=""
echo "▸ Checking Vercel credentials..."
if [ -n "${VERCEL_TOKEN:-}" ]; then
    AUTH_FLAG="--token $VERCEL_TOKEN"
    echo "  ✓ Using VERCEL_TOKEN"
elif vercel whoami &>/dev/null; then
    VERCEL_USER=$(vercel whoami 2>/dev/null)
    echo "  ✓ Authenticated as $VERCEL_USER"
else
    echo "  ✗ No Vercel credentials found."
    echo "    Run: vercel login"
    echo "    Or:  VERCEL_TOKEN=xxx ./push-and-deploy.sh"
    exit 1
fi

# ── Step 2: Push latest code to GitHub ──
echo ""
echo "▸ Pushing latest code to GitHub..."
git push origin main 2>&1 && echo "  ✓ Code pushed" || echo "  ⚠ Push failed or nothing to push"

# ── Step 3: Link project if first deploy ──
if [ ! -d ".vercel" ]; then
    echo ""
    echo "▸ First deploy — linking project as '$PROJECT_NAME'..."
    vercel link --yes --project "$PROJECT_NAME" $AUTH_FLAG 2>&1 || {
        echo "  Creating new project '$PROJECT_NAME'..."
        vercel --yes --name "$PROJECT_NAME" $AUTH_FLAG 2>&1
    }
fi

# ── Step 4: Deploy to Vercel ──
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
echo "Live URL: ${DEPLOY_URL:-check https://vercel.com/dashboard}"
echo ""
echo "Post-deploy:"
echo "  1. Verify the live URL works"
echo "  2. Update Stripe redirect URL to your Vercel domain"
echo "     (see STRIPE-SETUP.md, Step 3)"
echo "  3. Consider adding a custom domain in Vercel dashboard"
echo ""
