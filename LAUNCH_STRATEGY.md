# Shelves - Launch Strategy & Market Analysis

## 1. Executive Summary
The personal book cataloging market is dominated by legacy players with dated UX (Goodreads, LibraryThing) or expensive niche tools (CLZ Books). Startups often lack depth. **Shelves** has a clear window to capture the "Prosumer" segment—serious collectors who demand a modern, premium, mobile-first experience with AI intelligence.

## 2. Competitive Landscape

| Competitor | Strengths | Weaknesses | Shelves Advantage |
| :--- | :--- | :--- | :--- |
| **Goodreads** | Massive social network, free. | App is notoriously buggy/dated (Amazon neglected). No advanced organization. | **Premium UX**, privacy-focused (no social clutter), better scanning. |
| **CLZ Books** | Powerful, reputable database. | Expensive ($15/yr), complex UI ("spreadsheet" feel), data entry heavy. | **AI Automation**, modern "Apple Design Award" aesthetic, spine recognition. |
| **LibraryThing** | Deep metadata, scholarly focus. | Mobile app is an afterthought. Web-first. | **Mobile-First**, faster scanning workflows. |
| **Bookly** | Good design, reading tracking focus. | Cataloging is secondary. More for "readers" than "collectors". | **Collection-First** focus with advanced location management. |

### The Gap
There is no "Linear" or "Things 3" for book collecting. Existing tools are either ugly but powerful (CLZ) or rudimentary (Goodreads). **Shelves** fills the "Premium Utility" gap.

## 3. Pricing Strategy
**Model:** Freemium with Subscription (RevenueCat integration).

### Free Tier ("Reader")
*Goal: User Acquisition & Data Lock-in*
*   Unlimited items (don't cap at 50, it kills retention).
*   Basic Scanning (Barcode).
*   Cloud Sync (Primary device + 1).

### Pro Tier ("Collector") - $4.99/mo or $29.99/yr
*Goal: Monetize Power Users*
*   **AI Intelligence:** Spine Recognition (Killer Feature), Auto-categorization (Themes/Tone).
*   **Organization:** "Smart Shelves" suggestions.
*   **Unlimited Sync:** All devices.
*   **Export:** CSV Data ownership.

*Rationale:* $29.99/yr undercuts CLZ ($15-$30 range depending on platform/bundle) while offering superior AI features. The "Spine Recognition" is a high-compute cost, justifying the subscription.

## 4. Launch Strategy

### Phase 1: Pre-Launch Hype (Waitlist)
*   **Asset:** Simple Landing Page (Carrd/Webflow) capturing emails.
*   **Hook:** "The first AI-powered library for serious collectors. Stop typing, start scanning."
*   **Incentive:** "Join waitlist for 3 months free Pro."
*   **Channel:** Reddit (r/bookshelf, r/books), Twitter/X build-in-public.

### Phase 2: Soft Launch (TestFlight)
*   **Target:** 50-100 users (Theology scholars, extensive fiction collectors).
*   **Focus:** Testing the "Barcode vs Spine" workflow. Refining Vertex AI prompts.
*   **Metric:** Scan success rate > 95%.

### Phase 3: "BookTok" & Influencer Campaign
*   **Concept:** "The Aesthetics of Organization."
*   **Target Influencers:**
    *   *Micro (10k-50k):* High engagement, often reply to DMs. Send free Lifetime Pro code.
    *   *Niche:* "Dark Academia" aesthetic accounts, Interior Design x Books accounts.
*   **Brief:** Don't ask for a review. Ask them to *show* them organizing their shelf using the Spine Scanner.
*   **Hashtags:** #librarygoals #shelfie #booktok #organizationporn.

### Phase 4: App Store Optimization (ASO) & Launch
*   **Title:** Shelves: AI Book Tracker & Library
*   **Subtitle:** Scan Spines, Organize, Catalog.
*   **Keywords:** "Home Library", "ISBN Scanner", "Personal Database", "Reading Log", "Citation".
*   **Visuals:**
    *   *Screenshot 1:* Spine recognition in action (The "Wow" moment).
    *   *Screenshot 2:* Beautiful dark mode grid of covers.
    *   *Screenshot 3:* AI Organization suggestion ("Move these 5 books...").
    *   *Video:* 15s Portrait video demonstrating the scan speed.
*   **Product Hunt:** Launch on a Tuesday/Wednesday. Position as "The Linear for Books".

### Phase 5: Retention & Referral
*   **Onboarding:** "Scan your first 5 books to unlock a custom app icon." (Gamification).
*   **Shareable Assets:** "My 2025 Reading Stats" card (Spotify Wrapped style) generated beautifully for Instagram Stories.


## 5. Risk Assessment
*   **API Costs:** Vertex AI (Gemini) costs can scale. *Mitigation:* Cache extensively. Compute categories once per book.
*   **Data Accuracy:** AI hallucinations on niche books. *Mitigation:* User "Verify" step for AI data.
*   **Retention:** Users scan once and leave. *Mitigation:* "Reading Status" and "Lending Tracker" features (P2) to drive weekly usage.
