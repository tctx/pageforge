#!/bin/bash
# PageForge — Deploy to Vercel
#
# GitHub push is done (SSH). This script handles Vercel CLI deploy.
#
# PREREQUISITES:
#   vercel login           # Vercel authentication (one-time)
#
# Then just run:
#   ./push-and-deploy.sh

set -euo pipefail
cd "$(dirname "$0")"

echo "============================================"
echo "  PageForge — Vercel Deploy"
echo "============================================"
echo ""

# ── Step 1: Check Vercel auth ──
echo "▸ Checking Vercel credentials..."
if ! vercel whoami &>/dev/null; then
    echo "  ✗ Vercel not authenticated. Run: vercel login"
    exit 1
fi
VERCEL_USER=$(vercel whoami 2>/dev/null)
echo "  ✓ Vercel authenticated as $VERCEL_USER"

# ── Step 2: Push latest code to GitHub ──
echo ""
echo "▸ Pushing latest code to GitHub..."
git push origin main 2>&1 && echo "  ✓ Code pushed" || echo "  ⚠ Push failed or nothing to push"

# ── Step 3: Deploy to Vercel ──
echo ""
echo "▸ Deploying to Vercel (production)..."
vercel --prod --yes
echo "  ✓ Deployed to Vercel"

echo ""
echo "============================================"
echo "  ✓ ALL DONE"
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Check your Vercel dashboard for the live URL"
echo "  2. Add a custom domain in Vercel if desired"
echo "  3. Update Stripe success redirect URL to your live domain"
echo "     (see STRIPE-SETUP.md for details)"
echo ""
