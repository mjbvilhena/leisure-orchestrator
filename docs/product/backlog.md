# Product Backlog

> Status convention: each task line includes `*(Done)*`, `*(In progress)*`, or `*(Not done)*` based on the repo audit (2026-09-16, updated 2026-09-18). MVP epics in `docs/product/specification.md` were approved by **mjbvilhena** (2026-09-15, PR #1). There is still no application source tree, test suite, or runtime. Epic *approval* is not implementation *Done*.

## Epic 1: Natural-language intake of trip constraints

> Outcome (from product specification): a signed-in consumer can submit a trip prompt on web or CLI (chat-like), retrieve past coordinated itineraries, and produce structured constraints (budget, dates, destination, preferences, required party size, 1–5 scoring matrix) for the Supervisor.

- **Task 1.1** *(Done)*: Refine Epic 1 into user stories (product-spec Next step #1; `/sdlc-user-story-refiner` or equivalent). *(Evidence: `docs/product/user-stories/epic-1/` — US-E1-01 through US-E1-07, plus `docs/product/user-stories/README.md`.)*
- **Task 1.2** *(Not done)*: Deliver Epic 1 outcome (accounts, itinerary history, chat-like intake with party-size prompt and scoring). *(Evidence: repo root has docs + CI only; no app code.)*

## Epic 2: Supervisor and specialist-agent delegation

> Outcome (from product specification): a single request spawns Supervisor, Flight Broker, Lodging Broker, and Concierge Agent; specialists use curated KB first and live web only as fallback.

- **Task 2.1** *(Not done)*: Refine Epic 2 into user stories (product-spec Next step #2). *(Evidence: no Epic 2 user-story files under `docs/product/user-stories/`; no application source.)*
- **Task 2.2** *(Not done)*: Deliver Epic 2 outcome (autonomous delegation + per-specialist curated KBs). *(Evidence: no application source.)*

## Epic 3: Shared remaining-budget coordination

> Outcome (from product specification): the combined itinerary cannot silently overflow the user’s cap; rebalance first, then fail closed and ask which constraint to relax.

- **Task 3.1** *(Not done)*: Refine Epic 3 into user stories (product-spec Next step #3). *(Evidence: no Epic 3 user-story files under `docs/product/user-stories/`; no application source.)*
- **Task 3.2** *(Not done)*: Deliver Epic 3 outcome (shared remaining-budget handoff + fail-closed infeasibility). *(Evidence: no application source.)*

## Epic 4: Finalized itinerary with fulfillment choice

> Outcome (from product specification): one coordinated itinerary (flights + lodging + dining) with direct-booking deep links or optional pass-through in-product charged booking.

- **Task 4.1** *(Not done)*: Refine Epic 4 into user stories (product-spec Next step #4). *(Evidence: no Epic 4 user-story files under `docs/product/user-stories/`; no application source.)*
- **Task 4.2** *(Not done)*: Deliver Epic 4 outcome (deep links + optional pass-through charged path; not merchant of record). *(Evidence: no application source.)*

## Epic 5: Documentation hygiene (docs-first repo)

> Goal: Keep the docs-first tree navigable and evidence-backed until application code lands. Added by the 2026-09-16 daily docs/backlog review. Does not invent product features.

- **Task 5.1** *(Not done)*: Vendor the product vision into the repository (recommended path: `docs/product/vision.md`). **Blocked:** the source vision file lives only on Miguel’s laptop and is not available to attach; do not invent `vision.md`. *(Evidence: Source note in `docs/product/specification.md`; no `docs/product/vision.md`.)*
- **Task 5.2** *(Done)*: Relocate `docs/product-spec.md` under `docs/product/` as `docs/product/specification.md` and update README / backlog / spec links so product docs share one folder with this backlog. *(Evidence: `docs/product/specification.md` present; `docs/product-spec.md` removed; README Contents and this backlog point at the new path.)*
- **Task 5.3** *(Done)*: Seed `DOMAIN.md` (travel) and `LAYER.md` (orchestration) from constraints already stated in the product specification (especially **Resolved with Product Owner**, In Scope MVP, agent roles, fail-closed budget behaviour, dual fulfillment, accounts/history, curated-KB-first). Do not invent personas, KPIs, vendors, or unset rules. *(Evidence: repo-root `DOMAIN.md` and `LAYER.md`; each bound cites its spec source; unspecified topics listed under “Unset — do not invent.”)*
