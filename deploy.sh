#!/bin/bash
# PageForge — Deploy to Vercel
# Usage:
#   Option A: vercel login   (then run this script)
#   Option B: VERCEL_TOKEN=xxx ./deploy.sh

set -euo pipefail
cd "$(dirname "$0")"

echo "=== PageForge Vercel Deploy ==="

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
    echo "  Option A: Run 'vercel login' first"
    echo "  Option B: Export VERCEL_TOKEN=xxx then re-run"
    exit 1
  fi
fi

# Deploy to production
echo ""
echo "Deploying PageForge to production..."
vercel --prod --yes $AUTH_FLAG

echo ""
echo "Deploy complete!"
