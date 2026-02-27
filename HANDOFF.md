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
- [ ] Deploy to Vercel — run `vercel login` then `./push-and-deploy.sh`
  - OR import repo at https://vercel.com/new → select `tctx/pageforge` (auto-deploys on push)
- [x] Stripe payment link wired into "Get PageForge Pro" button (link: `buy.stripe.com/cNi5kD...`)
- [ ] **Stripe: configure success redirect URL** → `https://YOUR-DOMAIN/?checkout=success` (see STRIPE-SETUP.md)
- [ ] Marketing: share on Twitter/social

## Growth strategy
- SEO: "free landing page generator", "landing page builder no code"
- The tool itself is a funnel: free users see locked templates and want Pro
- Every generated landing page is a distribution vector for PageForge
