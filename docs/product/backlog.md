# Product Backlog

> Status convention: each task line includes `*(Done)*`, `*(In progress)*`, or `*(Not done)*` based on the repo audit (2026-09-16, updated 2026-09-20). Product spec, epics, user stories, and technical design (including ADRs) need **named human approval**; drafted or merged files are not approval — do not mark stories or epics Done or “complete” without that. MVP epics in `docs/product/specification.md` were approved by **mjbvilhena** (2026-09-15, PR #1). Epic 1 user stories US-E1-01 through US-E1-07 were approved by **mjbvilhena** (2026-09-20, named human sign-off of the story artefacts). There is still no application source tree, test suite, or runtime. Story *approval* is not implementation *Done*. Epic *approval* is not implementation *Done*.

## Epic 1: Natural-language intake of trip constraints

> Outcome (from product specification): a signed-in consumer can submit a trip prompt on web or CLI (chat-like), retrieve past coordinated itineraries, and produce structured constraints (budget, dates, destination, preferences, required party size, 1–5 scoring matrix) for the Supervisor.

- **Task 1.1** *(Done)*: Refine Epic 1 into user stories (product-spec Next step; `/sdlc-user-story-refiner` or equivalent). *(Evidence: 2026-09-20 — US-E1-01 through US-E1-07 exist under `docs/product/user-stories/epic-1/`, plus `docs/product/user-stories/README.md`. All seven story artefacts approved by **mjbvilhena** (2026-09-20, named human sign-off); stakeholder-acceptance checkboxes marked for those artefacts only, not implementation Done. Sign-off includes **Google sign-in** (US-E1-01) and **simultaneous scoring-matrix capture** via web widget and CLI TUI widget (US-E1-05). Story-artefact approval is not application delivery.)*
- **Task 1.2** *(Not done)*: Deliver Epic 1 outcome (accounts with Google sign-in, itinerary history, chat-like intake with party-size prompt and simultaneous scoring-matrix widgets). *(Evidence: 2026-09-20 — repo still docs + CI only; no application source, tests, or runtime.)*

## Epic 2: Supervisor and specialist-agent delegation

> Outcome (from product specification): a single request spawns Supervisor, Flight Broker, Lodging Broker, and Concierge Agent; specialists use curated KB first and live web only as fallback.

- **Task 2.1** *(Not done)*: Refine Epic 2 into user stories (Epic 1 story-artefact approval gate is cleared; start when the conductor directs). *(Evidence: 2026-09-20 — no `docs/product/user-stories/epic-2/`; no application source. Product-spec Next step is design/planning for Epic 1 slices and/or Epic 2 story refinement per conductor.)*
- **Task 2.2** *(Not done)*: Deliver Epic 2 outcome (autonomous delegation + per-specialist curated KBs). *(Evidence: 2026-09-20 re-audit — no application source.)*

## Epic 3: Shared remaining-budget coordination

> Outcome (from product specification): the combined itinerary cannot silently overflow the user’s cap; rebalance first, then fail closed and ask which constraint to relax.

- **Task 3.1** *(Not done)*: Refine Epic 3 into user stories (`/sdlc-user-story-refiner` or equivalent; after Epic 1 stories are approved and Epic 2 is refined). *(Evidence: 2026-09-20 re-audit — no `docs/product/user-stories/epic-3/`; no application source.)*
- **Task 3.2** *(Not done)*: Deliver Epic 3 outcome (shared remaining-budget handoff + fail-closed infeasibility). *(Evidence: 2026-09-20 re-audit — no application source.)*

## Epic 4: Finalized itinerary with fulfillment choice

> Outcome (from product specification): one coordinated itinerary (flights + lodging + dining) with direct-booking deep links or optional pass-through in-product charged booking.

- **Task 4.1** *(Not done)*: Refine Epic 4 into user stories (`/sdlc-user-story-refiner` or equivalent; after Epic 1 stories are approved and Epics 2–3 are refined). *(Evidence: 2026-09-20 re-audit — no `docs/product/user-stories/epic-4/`; no application source.)*
- **Task 4.2** *(Not done)*: Deliver Epic 4 outcome (deep links + optional pass-through charged path; not merchant of record). *(Evidence: 2026-09-20 re-audit — no application source.)*

## Epic 5: Documentation hygiene (docs-first repo)

> Goal: Keep the docs-first tree navigable and evidence-backed until application code lands. Added by the 2026-09-16 daily docs/backlog review. Does not invent product features.

- **Task 5.1** *(Done)*: Vendor the product vision into the repository at `docs/product/vision.md`. Relocated from the PR #6 path `docs/vision/leisure_orchestrator_product_vision.md`; empty `docs/vision/` removed. *(Evidence: 2026-09-20 re-audit — `docs/product/vision.md` present; spec Source and README Contents point at it; no `docs/vision/` tree.)*
- **Task 5.2** *(Done)*: Relocate `docs/product-spec.md` under `docs/product/` as `docs/product/specification.md` and update README / backlog / spec links so product docs share one folder with this backlog. *(Evidence: 2026-09-20 re-audit — `docs/product/specification.md` present; no `docs/product-spec.md`; README Contents and this backlog point at the new path.)*
- **Task 5.3** *(Done)*: Seed `DOMAIN.md` (travel) and `LAYER.md` (orchestration) from constraints already stated in the product specification (especially **Resolved with Product Owner**, In Scope MVP, agent roles, fail-closed budget behaviour, dual fulfillment, accounts/history, curated-KB-first). Do not invent personas, KPIs, vendors, or unset rules. *(Evidence: 2026-09-20 re-audit — repo-root `DOMAIN.md` and `LAYER.md` present; each bound cites its spec source; “Unset — do not invent” sections intact.)*
