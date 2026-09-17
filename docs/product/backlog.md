# Product Backlog

> Status convention: each task line includes `*(Done)*`, `*(In progress)*`, or `*(Not done)*` based on the repo audit (2026-09-16). MVP epics in `docs/product-spec.md` were approved by **mjbvilhena** (2026-09-15, PR #1). There is still no application source tree, test suite, or runtime on `master`. Epic *approval* is not implementation *Done*.

## Epic 1: Natural-language intake of trip constraints

> Outcome (from product-spec): a signed-in consumer can submit a trip prompt on web or CLI (chat-like), retrieve past coordinated itineraries, and produce structured constraints (budget, dates, destination, preferences, required party size, 1–5 scoring matrix) for the Supervisor.

- **Task 1.1** *(Not done)*: Refine Epic 1 into user stories (product-spec Next step #1; `/sdlc-user-story-refiner` or equivalent). *(Evidence: no user-story files under `docs/`; no application source on `master`.)*
- **Task 1.2** *(Not done)*: Deliver Epic 1 outcome (accounts, itinerary history, chat-like intake with party-size prompt and scoring). *(Evidence: repo root has docs + CI only; no app code.)*

## Epic 2: Supervisor and specialist-agent delegation

> Outcome (from product-spec): a single request spawns Supervisor, Flight Broker, Lodging Broker, and Concierge Agent; specialists use curated KB first and live web only as fallback.

- **Task 2.1** *(Not done)*: Refine Epic 2 into user stories (product-spec Next step #2). *(Evidence: no user-story files under `docs/`; no application source on `master`.)*
- **Task 2.2** *(Not done)*: Deliver Epic 2 outcome (autonomous delegation + per-specialist curated KBs). *(Evidence: no application source on `master`.)*

## Epic 3: Shared remaining-budget coordination

> Outcome (from product-spec): the combined itinerary cannot silently overflow the user’s cap; rebalance first, then fail closed and ask which constraint to relax.

- **Task 3.1** *(Not done)*: Refine Epic 3 into user stories (product-spec Next step #3). *(Evidence: no user-story files under `docs/`; no application source on `master`.)*
- **Task 3.2** *(Not done)*: Deliver Epic 3 outcome (shared remaining-budget handoff + fail-closed infeasibility). *(Evidence: no application source on `master`.)*

## Epic 4: Finalized itinerary with fulfillment choice

> Outcome (from product-spec): one coordinated itinerary (flights + lodging + dining) with direct-booking deep links or optional pass-through in-product charged booking.

- **Task 4.1** *(Not done)*: Refine Epic 4 into user stories (product-spec Next step #4). *(Evidence: no user-story files under `docs/`; no application source on `master`.)*
- **Task 4.2** *(Not done)*: Deliver Epic 4 outcome (deep links + optional pass-through charged path; not merchant of record). *(Evidence: no application source on `master`.)*

## Epic 5: Documentation hygiene (docs-first repo)

> Goal: Keep the docs-first tree navigable and evidence-backed until application code lands. Added by the 2026-09-16 daily docs/backlog review. Does not invent product features.

- **Task 5.1** *(Not done)*: Vendor the product vision into the repository (recommended path: `docs/product/vision.md`). The product-spec Source still refers to a machine-local file that is not in git. *(Evidence: Source note in `docs/product-spec.md`; no vision file under `docs/` on `master`.)*
- **Task 5.2** *(Not done)*: Relocate `docs/product-spec.md` under `docs/product/` (e.g. `docs/product/specification.md`) and update README / backlog links so product docs share one folder with this backlog. *(Evidence: `docs/` currently has top-level `product-spec.md` only; backlog is `docs/product/backlog.md`.)*
- **Task 5.3** *(Not done)*: Seed `DOMAIN.md` (travel) and `LAYER.md` (orchestration) when real constraints are known. Spec Risks already note empty consultant catalogs; do not invent domain or layer rules. *(Evidence: no `DOMAIN.md` / `LAYER.md` on `master`; Risks section in `docs/product-spec.md`.)*
