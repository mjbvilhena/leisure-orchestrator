# Product Specification: Leisure Orchestrator

Standard product specification / epic pack that bridges the vision document and later user stories.

**Quality bar:** A reader can understand the why, who it is for, what is strictly in MVP, and the primary workflows, without needing to ping the author. No sprint-level tasks or UI pixel details.

**Source:** In-repo product vision at `docs/product/vision.md`.

**Consultant notes:** `get_domain_consultant` (`travel`) and `get_layer_consultant` (`orchestration`) returned empty catalogs when this spec was first authored. Travel and orchestration rules that this specification already states are now seeded in repo-root `DOMAIN.md` and `LAYER.md`. No personas, KPIs, vendors, or success metrics were invented. Scope that the vision did not state is marked as a Product Owner decision in **Resolved with Product Owner**. Topics the specification does not state are listed as **Unset — do not invent** in those files.

**Status:** Epics approved by **mjbvilhena** (2026-09-15). Open questions: none remaining. Implementation backlog: `docs/product/backlog.md`. Epic 1 user stories: `docs/product/user-stories/epic-1/`.

---

## Background & Value Proposition

- **What problem are we solving?** Current consumer AI provides *advice*. It can plan an itinerary and then abandon the user when it is time to do the work. Complex travel still means a multi-tab, multi-platform headache: flights, lodging, and dining coordinated by hand, with a budget the traveler must reconcile themselves.
- **Why is it important to solve now?** The landscape is shifting from single-agent chatbots to Digital Assembly Lines managed by multi-agent organizations. The strategic goal is to prove the orchestration framework. A platform that cohesively handles the *entire* trip (flights + hotels + dining) is a prime acquisition target for industry giants such as Amex, Expedia, Airbnb, or Google Travel, who are in a race to build the ultimate autonomous concierge.
- **How do we measure success?** The vision does not state quantitative KPIs. MVP success is proving the **Multi-Agent Orchestration Engine**: accept a constrained natural-language prompt, autonomously delegate to specialist agents, keep the combined itinerary inside budget, and return a finalized itinerary. The user then either follows **direct-booking links** or, if they opt in, uses **in-product charged booking**.

The product is a B2C **Executive Leisure Assistant**: specialist agents that execute complex, headache-inducing travel errands as an autonomous back-office for the consumer. Stickiness comes from solving the full coordination problem, not from advice-only chat.

---

## Target Audience

- **Primary users/personas:** Consumers in the travel market. The vision does not name additional personas (travel agents, enterprise admins, OTA operators). Those are not in scope.
- **Core pain points:**
  - The logistical nightmare of booking complex travel
  - Multi-tab, multi-platform coordination
  - Advice-only AI that stops before execution
  - A budget that must be split across flights, lodging, and dining without a single system holding the remaining amount

---

## Scope & Phasing

### In Scope (MVP)

What MUST be delivered to validate the hypothesis: prove the Multi-Agent Orchestration Engine.

**Vision MVP (unchanged core):**

1. Accept a natural-language prompt with strict constraints (budget, dates, preferences) on **web and CLI**, both chat-like.
2. Autonomously delegate tasks to specialist agents. Each specialist uses an **internal curated knowledge base / allowlist** first; **live web only if the allowlist has no hit**.
3. Validate that the combined itinerary respects the budget (e.g. if the flight agent spends $1,500, the hotel agent knows it only has $1,500 left). If nothing fits: rebalance, then fail closed and ask which constraint to relax.
4. Output a finalized, perfectly coordinated itinerary with **actionable direct-booking (deep) links**. Dining/events is a **reservation/booking page**, not a listing and not a paid hold.

**Product Owner scope adds (not in the vision):**

5. **Party size is required**; if omitted, ask before planning.
6. **Any destination** the curated tools (plus web fallback) can reach. Tokyo is the golden-path example, not a lock.
7. **Accounts and itinerary history.**
8. **Optional dual-mode fulfillment:** the user chooses in-product charged booking **or** direct-booking links. (Widens the vision’s “no real financial transactions” stance; liability and card integration remain risks.)
9. **Preference scoring:** the user rates named dimensions (at least price, duration, stops) 1–5; the Supervisor uses that matrix as judgement, still bound by budget and dates.

**MVP agent team (explicit in the vision):**

- **Supervisor** — breaks down constraints, holds the budget, applies the user’s 1–5 scoring matrix, rebalances or rejects overflow
- **Flight Broker** — uses the curated flight KB (web fallback if empty) to find and validate a flight route
- **Lodging Broker** — secures accommodations within the remaining budget (validated option + deep link, or charged booking if the user opted in)
- **Concierge Agent** — uses the curated hospitality/event KB (web fallback if empty) to produce reservation/booking page links; charges a card only if the user chose that fulfillment path

**Canonical example:** *"Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."*

### Future Scope (v2+)

What we are explicitly deferring:

- Broader autonomous back-office errands beyond travel (stated in the philosophy; the product itself is complex travel)
- Consumer-facing editor for specialist knowledge bases (MVP KBs are internal)

### Out of Scope / Non-Goals

- Advice-only chatbot output with no coordinated itinerary or booking links
- Search-result URLs presented as booking links
- Restaurant/event listings with no bookable reservation path
- Invented channels or markets not in the vision (B2B travel desks, white-label for OTAs, API-only B2C, multi-field form as the primary intake)
- Acting as merchant of record (charged path is **pass-through**: providers charge the user)

---

## Core Workflows

Keep this narrative. Leave Given/When/Then to later user stories.

### 1. Constrained trip request → coordinated itinerary

1. The consumer uses **web or CLI** (chat-like) and is signed in (accounts are in MVP).
2. They submit a natural-language prompt with budget, dates, destination, preferences, and **party size**. If party size is missing, the product asks before planning.
3. They score named dimensions (at least price, duration, stops) from 1 (not important) to 5 (critical).
4. The Supervisor extracts constraints, holds the overall budget, and keeps the scoring matrix.
5. The Supervisor delegates to the Flight Broker, Lodging Broker, and Concierge Agent.
6. Specialists query their internal curated KB first; live web only if that KB has no hit. They return candidates that fit their remaining-budget slice and the scoring matrix.
7. The Supervisor validates that the combined package still respects the original budget.
8. The user receives a single finalized itinerary: flights + lodging + dining/events, internally consistent. They then choose **direct-booking links** or **in-product charged booking**.

### 2. Cross-agent budget handoff (planning, then optional payment)

1. A specialist consumes part of the budget in planning terms (e.g. Flight Broker selects a $1,500 route).
2. Remaining budget is visible to the next specialist (Lodging Broker has $1,500 left on a $3,000 cap).
3. Concierge selections must still fit whatever remains after flights and lodging, or the Supervisor must rebalance or reject combinations that overflow.
4. Payment appears only if the user opted into charged booking; otherwise they see priced components and deep links.

### 3. Infeasible combination (no overflowing itinerary)

1. The Supervisor first tries to rebalance slices so the package fits the cap, using the user’s 1–5 matrix.
2. If no combination fits, the user does **not** receive an overflowing itinerary.
3. The user receives a closed failure: why it cannot be met, the closest in-budget attempt if one exists, and which constraints they can relax (budget, dates, destination, dining/event, party size).
4. If they relax a constraint in the chat-like surface, the request re-enters workflow 1.

### 4. User fulfills the itinerary

1. The user reviews the coordinated itinerary (saved to their account history).
2. **Links path:** they complete each booking on the destination site via deep links. Product job ends at a bookable, budget-valid package.
3. **Charged path:** they opt in to in-product charged booking, which is **pass-through** — providers charge the user; this product is not merchant of record.

---

## Epics (MVP)

Each epic is **Done** when the outcome is in users’ hands (or explicitly shelved), not when the last ticket is closed. Stories inside the epic use the user-story / feature Definition of Done.

### Shared epic Definition of Done

- [ ] **Outcome stated** — one paragraph: who can do what now that they could not before
- [ ] **Child work complete** — all in-scope stories/tasks are Done per their own DoD, or explicitly cut with a leftover backlog item
- [ ] **No orphan flags** — temporary flags/migrations have an owner and a remove-by plan, or are already removed
- [ ] **Journey proven** — critical path covered by E2E or a documented manual journey; link the `e2e_test_plan` or test evidence
- [ ] **Contracts published** — user docs, API contract, and runbooks match shipped behavior (no invented capabilities)
- [ ] **Domain/Layer updated** — `DOMAIN.md` / `LAYER.md` changed if the epic moved a boundary
- [ ] **ADRs filed** — accepted decisions are ADRs, not only PR comments
- [ ] **Rollout finished or gated** — `rollout_plan` stages complete, or remaining rings have a named owner
- [ ] **Stakeholder acceptance** — **mjbvilhena** (spec owner) accepted the outcome

Not done if half the stories shipped a different product than the epic described and nobody updated the epic; if documentation is “later” with no ticket; or if integration was only tested on a developer laptop.

### Epic 1 — Natural-language intake of trip constraints

**Outcome:** A signed-in consumer can submit a trip prompt on web or CLI (chat-like), retrieve past coordinated itineraries, and the system has a structured, machine-usable set of constraints (budget, dates, destination, preferences, required party size, 1–5 scoring matrix) for the Supervisor.

**MVP includes:** Accounts and itinerary history (Product Owner scope add; not in the vision); parsing/accepting those fields from free text (Tokyo-style request); asking when party size is missing; any destination the tools can reach.

**Not this epic:** Completing bookings; UI pixel details; social features, sharing, or multi-user trip workspaces (unmentioned).

### Epic 2 — Supervisor and specialist-agent delegation

**Outcome:** A single request spawns a team—Supervisor, Flight Broker, Lodging Broker, Concierge Agent—and work is autonomously delegated; the user does not manually assign agents.

**MVP includes:** Each specialist’s internal curated KB; live web only as fallback; flight search using the scoring matrix; lodging within remaining budget; concierge reservation/booking pages.

**Not this epic:** Unbounded web as the first/only source; a consumer-facing KB editor.

### Epic 3 — Shared remaining-budget coordination

**Outcome:** The combined itinerary cannot silently overflow the user’s cap. If one specialist consumes part of the budget, others operate on what is left; the package is validated as a whole.

**MVP includes:** Vision example semantics (flight $1,500 → lodging knows $1,500 remains). On infeasible combinations: rebalance, then fail closed and ask which constraint to relax (workflow 3).

**Not this epic:** Returning an overflowing itinerary or a partial package that pretends the cap was met.

### Epic 4 — Finalized itinerary with fulfillment choice

**Outcome:** The consumer receives one coordinated itinerary (flights + hotels + dining) and can either execute **direct-booking deep links** themselves or opt into **in-product charged booking**.

**MVP includes:** Output is not “just text advice.” Links must be live/deep booking or reservation pages. Dining on the links path is a bookable reservation page.

**Not this epic:** Acting as merchant of record (out of scope).

---

## Risks & Dependencies

- **Teams, APIs, or existing systems:** The vision does not name vendors. MVP depends on per-specialist internal curated KBs, live-web fallback, web + CLI chat-like surfaces, accounts, and (if the user opts in) a **pass-through** charged path (providers charge the user). Domain and layer consultant catalogs were empty at spec authoring; constraints this specification already states are seeded in repo-root `DOMAIN.md` (travel) and `LAYER.md` (orchestration). The product vision is `docs/product/vision.md`.
- **Biggest product/technical risks:**
  - Optional charged booking **widens** the vision MVP. Charged path is pass-through (providers charge the user); card-integration and provider checkout still add liability and brittleness.
  - Budget coordination across agents is the core proof; race conditions, stale remaining-budget, and infeasible combinations are the main failure modes.
  - Curated KBs will go stale; low-quality allowlist entries plus brittle web fallback undercut “actionable” links.
  - Web fallback is still brittle (site changes, bot blocking, geo/language).
  - The acquisition thesis depends on proving cohesive flights + hotels + dining; a weak concierge or missing deep links undercuts the story.

---

## Open Questions

None remaining.

## Resolved with Product Owner

- [x] **Channel:** Web + CLI, both chat-like. Not a multi-field form as primary intake, not API-only.
- [x] **Data sources:** Curated allowlist first; live web only as fallback when the allowlist has no hit. No vendors named yet.
- [x] **“Optimal” flight:** User scores named dimensions (at least price, duration, stops) 1–5; Supervisor uses that matrix, still bound by budget and dates.
- [x] **No feasible combination:** Rebalance first; then fail closed and ask which constraint to relax.
- [x] **Booking links:** Direct/deep booking or reservation URLs required. Search-result URLs do not count.
- [x] **“Book dining” (links path):** Reservation/booking page the user completes. Not a paid hold, not a listing.
- [x] **Party size:** Required; ask if missing.
- [x] **Destination coverage:** Any destination the tools can reach. Tokyo is the example, not a lock.
- [x] **Persistence:** Accounts and itinerary history are in MVP (scope add), as part of **Epic 1**.
- [x] **Epic acceptance:** **mjbvilhena** (spec owner).
- [x] **Payments:** Optional dual-mode in MVP (charged booking vs. links). Widens the vision. Charged path is **pass-through** (providers charge the user); this product is not merchant of record.
- [x] **Per-agent KB:** Yes — internal curated KB per specialist, not a consumer-facing editor.

---

## Next step

Epics are approved. Do not write sprint-level tasks in this spec. Track delivery status in `docs/product/backlog.md`. Epic 1 user stories are in `docs/product/user-stories/epic-1/`. Continue `/sdlc-user-story-refiner` (or equivalent) on remaining epics in this order:

1. Epic 1 — Natural-language intake of trip constraints (includes accounts and itinerary history) — stories: `docs/product/user-stories/epic-1/`
2. Epic 2 — Supervisor and specialist-agent delegation
3. Epic 3 — Shared remaining-budget coordination
4. Epic 4 — Finalized itinerary with fulfillment choice
