# PageForge — Handoff

## What it is
A free web tool that generates beautiful, responsive landing pages in 60 seconds. Users fill a form, preview the result live, and download a standalone HTML file.

## Revenue model
- **Free tier**: 2 templates (Midnight, Clean) — generates traffic, builds trust
- **Pro tier ($9 one-time)**: Unlocks 4 premium templates (Gradient, SaaS Pro, and future additions)

## Current state
- [x] Core app built (single-page HTML/CSS/JS)
- [x] Live preview with iframe
- [x] Form: product name, tagline, description, 3 features, CTA, colors
- [x] 2 free templates working (Midnight, Clean)
- [x] 2 locked pro templates (Gradient, SaaS Pro) — UI shows PRO badge
- [x] Download as standalone HTML file
- [x] Copy HTML to clipboard
- [x] Responsive layout
- [x] Vercel-ready (vercel.json)

## Needs Tommy
- [x] Push to GitHub — **DONE** → https://github.com/tctx/pageforge
- [x] Deploy — **LIVE** at https://tctx.github.io/pageforge/ (GitHub Pages, deployed 2026-02-27)
- [ ] **Deploy to Vercel** — blocked on `vercel login` (see below)
- [x] Stripe payment link wired into "Get PageForge Pro" button (link: `buy.stripe.com/cNi5kD...`)
- [x] **Stripe: success redirect URL configured** → `https://tctx.github.io/pageforge/?checkout=success` (updated 2026-02-27)
- [ ] Marketing: share on Twitter/social

## Vercel Deploy (Tommy action required)

Everything is ready — code, config, scripts, CI workflow. Just need one auth step. Pick **one** option:

### Option A: Dashboard Import (easiest, recommended)
1. Go to https://vercel.com/new
2. Import: `github.com/tctx/pageforge`
3. Framework: **Other** (static site)
4. Deploy — done in 30 seconds
5. **Bonus**: all future `git push` to main will auto-deploy

### Option B: GitHub Actions (fully automated, recommended for CI)
1. Go to https://vercel.com/new → Import `github.com/tctx/pageforge` → Deploy once (creates the project)
2. Get IDs: run `npx vercel link` locally, then check `.vercel/project.json` for `orgId` and `projectId`
3. Go to https://github.com/tctx/pageforge/settings/secrets/actions and add **3 secrets**:
   - `VERCEL_TOKEN` — from https://vercel.com/account/tokens
   - `VERCEL_ORG_ID` — the `orgId` from step 2
   - `VERCEL_PROJECT_ID` — the `projectId` from step 2
4. Push any commit to `main` → auto-deploys to Vercel via `.github/workflows/deploy.yml`

### Option C: CLI via vault (Longshanks can auto-deploy)
```bash
# Create token at https://vercel.com/account/tokens, then add to vault:
bash ~/Desktop/test/longshanks/scripts/vault-manager.sh --add VERCEL_TOKEN <token>
# Then deploy:
~/Desktop/test/longshanks/projects/pageforge/deploy.sh
```

### After deploying:
- Note: `pageforge.vercel.app` is taken — project will deploy as `pageforge-gen.vercel.app`
- Update Stripe redirect URL to your new Vercel domain (see STRIPE-SETUP.md, Step 3)
- Consider adding a custom domain like `pageforge.dev` in Vercel dashboard

## Growth strategy
- SEO: "free landing page generator", "landing page builder no code"
- The tool itself is a funnel: free users see locked templates and want Pro
- Every generated landing page is a distribution vector for PageForge
