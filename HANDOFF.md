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

Deploy scripts are ready. Just need auth. Pick **one** option:

### Option A: CLI (30 seconds)
```bash
cd ~/Desktop/test/longshanks/projects/pageforge
vercel login          # opens browser, authorize
./deploy.sh           # deploys to production
```

### Option B: Dashboard (no CLI needed)
1. Go to https://vercel.com/new
2. Import: `github.com/tctx/pageforge`
3. Framework: **Other** (static site)
4. Deploy — done

### After deploying:
- Note: `pageforge.vercel.app` is taken — project will deploy as `pageforge-gen.vercel.app`
- Update Stripe redirect URL to your new Vercel domain (see STRIPE-SETUP.md, Step 3)
- Consider adding a custom domain like `pageforge.dev` in Vercel dashboard

## Growth strategy
- SEO: "free landing page generator", "landing page builder no code"
- The tool itself is a funnel: free users see locked templates and want Pro
- Every generated landing page is a distribution vector for PageForge
