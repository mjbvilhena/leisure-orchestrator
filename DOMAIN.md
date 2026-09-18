# Domain: Travel

Seed for `get_domain_consultant` (`travel`). Place this file at the repository root unless a later convention is documented.

**Authority:** `docs/product/specification.md` only. The laptop-local vision file is **not** in this repository (backlog Task 5.1). Do not treat this file as a source of new product decisions.

**Rule:** Every bound below cites its specification source. If a travel fact is not cited, it is not a product rule.

## Product in this domain

- This product is a B2C **Executive Leisure Assistant**: specialist agents that execute complex, headache-inducing **travel** errands as an autonomous back-office for the consumer. Stickiness comes from solving the full coordination problem, not from advice-only chat. *(Source: Background & Value Proposition)*
- The travel problem in MVP is coordinating **flights + hotels + dining** as one trip, including a budget the traveler currently has to reconcile themselves. *(Source: Background & Value Proposition; In Scope MVP)*
- MVP success is proving the Multi-Agent Orchestration Engine on this travel problem: accept a constrained natural-language prompt, autonomously delegate to specialist agents, keep the combined itinerary inside budget, and return a finalized itinerary. *(Source: Background & Value Proposition)*

## Who it is for

- **Primary users:** Consumers in the travel market. *(Source: Target Audience)*
- The specification does not name additional personas (travel agents, enterprise admins, OTA operators). Those are **not in scope**. *(Source: Target Audience)*

## Core travel pain points (stated)

- The logistical nightmare of booking complex travel. *(Source: Target Audience)*
- Multi-tab, multi-platform coordination. *(Source: Target Audience)*
- Advice-only AI that stops before execution. *(Source: Target Audience)*
- A budget that must be split across flights, lodging, and dining without a single system holding the remaining amount. *(Source: Target Audience)*

## In-scope travel (MVP)

**Vision MVP core** *(Source: In Scope MVP — Vision MVP)*:

1. Accept a natural-language prompt with strict constraints (budget, dates, preferences) on **web and CLI**, both chat-like.
2. Specialist agents use an **internal curated knowledge base / allowlist** first; **live web only if the allowlist has no hit**.
3. The combined itinerary must respect the budget. If nothing fits: rebalance, then fail closed and ask which constraint to relax.
4. Output a finalized, coordinated itinerary with **actionable direct-booking (deep) links**. Dining/events on the links path is a **reservation/booking page**, not a listing and not a paid hold.

**Product Owner scope adds** *(Source: In Scope MVP — Product Owner scope adds; Resolved with Product Owner)*:

5. **Party size is required**; if omitted, ask before planning.
6. **Any destination** the curated tools (plus web fallback) can reach. Tokyo is the golden-path example, not a lock.
7. **Accounts and itinerary history.**
8. **Optional dual-mode fulfillment:** the user chooses in-product charged booking **or** direct-booking links.
9. **Preference scoring:** the user rates named dimensions (at least price, duration, stops) 1–5; that matrix is judgement, still bound by budget and dates.

## Travel constraint fields the product must accept

The intake must produce a structured, machine-usable set of constraints for the Supervisor. *(Source: Epic 1; Core Workflows §1)*

| Field | Rule | Source |
| --- | --- | --- |
| Budget | Strict constraint on the combined itinerary; the original cap is what the package must respect | In Scope MVP; Core Workflows §1–§3 |
| Dates | Strict constraint; scoring remains bound by dates | In Scope MVP; Resolved with Product Owner (“Optimal” flight) |
| Destination | Any destination the curated tools (plus web fallback) can reach; Tokyo is an example, not a lock | Product Owner scope add; Resolved with Product Owner |
| Preferences | Accepted from the natural-language prompt (example: high-end sushi reservation) | In Scope MVP; Canonical example |
| Party size | Required; ask if missing; do not plan until it is present | Product Owner scope add; Resolved with Product Owner |
| Scoring matrix | Named dimensions, at least **price**, **duration**, and **stops**; each rated 1 (not important) to 5 (critical) | Product Owner scope add; Resolved with Product Owner |

## Canonical travel example

*"Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."* *(Source: In Scope MVP — Canonical example)*

This example does **not** include party size. Party size remains required; the product asks before planning. *(Source: Resolved with Product Owner — Party size; Core Workflows §1)*

## Fulfillment in the travel domain

- After a finalized itinerary, the user either follows **direct-booking (deep) links** or, if they opt in, uses **in-product charged booking**. *(Source: Background & Value Proposition; Epic 4; Resolved with Product Owner — Payments)*
- **Booking links:** Direct/deep booking or reservation URLs are required. Search-result URLs do not count. *(Source: Resolved with Product Owner; Out of Scope)*
- **Dining on the links path:** A reservation/booking page the user completes. Not a paid hold, not a listing. *(Source: Resolved with Product Owner; In Scope MVP)*
- **Charged path:** Pass-through — providers charge the user. This product is **not** merchant of record. *(Source: Resolved with Product Owner — Payments; Out of Scope)*
- Payment appears only if the user opted into charged booking; otherwise they see priced components and deep links. *(Source: Core Workflows §2)*

## Travel specialists (domain roles)

These roles exist because the vision named them; they operate on travel inventory, not generic chat. Orchestration rules for how they collaborate live in `LAYER.md`. *(Source: In Scope MVP — MVP agent team)*

- **Flight Broker** — find and validate a flight route (curated flight KB first).
- **Lodging Broker** — accommodations within the remaining budget (validated option + deep link, or charged booking if the user opted in).
- **Concierge Agent** — hospitality/event reservation/booking page links (curated hospitality/event KB first); charges a card only if the user chose that fulfillment path.

## Explicitly out of scope (travel)

- Advice-only chatbot output with no coordinated itinerary or booking links. *(Source: Out of Scope / Non-Goals)*
- Search-result URLs presented as booking links. *(Source: Out of Scope / Non-Goals)*
- Restaurant/event listings with no bookable reservation path. *(Source: Out of Scope / Non-Goals)*
- Invented channels or markets not in the vision: B2B travel desks, white-label for OTAs, API-only B2C, multi-field form as the primary intake. *(Source: Out of Scope / Non-Goals)*
- Acting as merchant of record. *(Source: Out of Scope / Non-Goals)*
- Broader autonomous back-office errands **beyond travel** (deferred to v2+). *(Source: Future Scope)*
- Consumer-facing editor for specialist knowledge bases (MVP KBs are internal). *(Source: Future Scope; Resolved with Product Owner — Per-agent KB)*

## Unset — do not invent

The specification does not state the following. Omit them from implementation guesses; do not add them here as rules.

- Quantitative KPIs, conversion rates, or numeric success metrics *(Source: Background — How do we measure success? “The vision does not state quantitative KPIs.”)*
- Named vendors, OTAs, GDSes, airlines, hotel chains, or card processors *(Source: Resolved with Product Owner — Data sources: “No vendors named yet”; Risks)*
- Additional personas beyond “consumers in the travel market”
- Currency (the canonical example uses `$`; that is an example, not a currency policy)
- Taxes, fees, refunds, cancellations, insurance, visas, loyalty programs
- Origin vs destination parsing beyond accepting a destination from the prompt
- Cabin class, number of rooms, hotel star ratings, or dietary taxonomies as required fields
- Adults vs children vs infants as a split of party size
- Timezones, calendar libraries, or “business day” rules
- A closed list of reachable destinations (coverage is “any destination the tools can reach”)
- What “preferences” means beyond prompt text plus the named 1–5 scoring dimensions
- Extra scoring dimensions beyond the required minimum of price, duration, and stops
