# PageForge Pro — Stripe Payment Setup

## Current State
A Stripe Payment Link is already in the code: `https://buy.stripe.com/cNi5kD15QbNx9DV1JjeQM01`

If this is YOUR link and it's working — skip to **Step 3** to verify the success redirect.

## Step 1: Create Payment Link (if needed)

1. Go to [Stripe Dashboard → Payment Links](https://dashboard.stripe.com/payment-links)
2. Click **+ New** payment link
3. Configure:
   - **Product name**: PageForge Pro
   - **Price**: $9.00 USD (one-time)
   - **Description**: Unlock all premium templates — Gradient, SaaS Pro, and future additions
4. Click **Create link**
5. Copy the link (format: `https://buy.stripe.com/xxxxx`)

## Step 2: Update the Link in Code

Open `index.html` and find this line near the top of the `<script>` block:

```js
const STRIPE_PAYMENT_LINK = 'https://buy.stripe.com/cNi5kD15QbNx9DV1JjeQM01';
```

Replace the URL with your new payment link.

## Step 3: Configure Success Redirect (CRITICAL)

This is the most important step. After checkout, Stripe needs to redirect back to your app.

1. Go to [Stripe Dashboard → Payment Links](https://dashboard.stripe.com/payment-links)
2. Click your PageForge Pro payment link
3. Click **Edit** (or the three dots → Edit)
4. Scroll to **After payment** section
5. Set **Confirmation page** to: **Don't show confirmation page**
6. Set **Custom redirect URL** to:
   ```
   https://YOUR-DOMAIN.vercel.app/?checkout=success
   ```
   Replace `YOUR-DOMAIN` with your actual deployed URL.
7. Save

## How the Unlock Flow Works

1. User clicks "Get PageForge Pro" → opens Stripe checkout in new tab
2. User pays $9 → Stripe redirects to `?checkout=success`
3. App detects `checkout=success` URL param → calls `unlockPro()`
4. Pro state saved to `localStorage` → persists across sessions
5. All premium templates become available

## Testing

1. Use Stripe test mode to create a test payment link
2. Complete a test checkout with card `4242 4242 4242 4242`
3. Verify you're redirected to your app with `?checkout=success`
4. Verify the Pro badge appears and templates unlock
5. Refresh the page — Pro should stay unlocked (localStorage)
6. Switch to live mode payment link when ready

## Manual Unlock (for testing)

Open browser console and run:
```js
localStorage.setItem('pageforge_pro', 'true');
location.reload();
```

To reset:
```js
localStorage.removeItem('pageforge_pro');
location.reload();
```
