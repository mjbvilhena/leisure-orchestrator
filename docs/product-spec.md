# Product Specification: Leisure Orchestrator

Standard product specification / epic pack that bridges the vision document and later user stories.

**Quality bar:** A reader can understand the why, who it is for, what is strictly in MVP, and the primary workflows, without needing to ping the author. No sprint-level tasks or UI pixel details.

**Source:** `/home/mjbvilhena/Documents/ResearchProjects/leisure_orchestrator_product_vision.md`

**Consultant notes:** `get_domain_consultant` (`travel`) and `get_layer_consultant` (`orchestration`) returned empty catalogs in this workspace. This spec is grounded only in the vision document. No personas, KPIs, or success metrics were invented.

---

## Background & Value Proposition

- **What problem are we solving?** Current consumer AI provides *advice*. It can plan an itinerary and then abandon the user when it is time to do the work. Complex travel still means a multi-tab, multi-platform headache: flights, lodging, and dining coordinated by hand, with a budget the traveler must reconcile themselves.
- **Why is it important to solve now?** The landscape is shifting from single-agent chatbots to Digital Assembly Lines managed by multi-agent organizations. The strategic goal is to prove the orchestration framework. A platform that cohesively handles the *entire* trip (flights + hotels + dining) is a prime acquisition target for industry giants such as Amex, Expedia, Airbnb, or Google Travel, who are in a race to build the ultimate autonomous concierge.
- **How do we measure success?** The vision does not state quantitative KPIs. MVP success is proving the **Multi-Agent Orchestration Engine**: accept a constrained natural-language prompt, autonomously delegate to specialist agents, keep the combined itinerary inside budget, and return a finalized itinerary with actionable direct-booking links.

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

What MUST be delivered to validate the hypothesis: prove the Multi-Agent Orchestration Engine. The initial release **will not execute real financial transactions** (liability and credit-card integration overhead).

1. Accept a natural-language prompt with strict constraints (budget, dates, preferences).
2. Autonomously delegate tasks to specialist agents.
3. Validate that the combined itinerary respects the budget (e.g. if the flight agent spends $1,500, the hotel agent knows it only has $1,500 left).
4. Output a finalized, perfectly coordinated itinerary with actionable, direct-booking links for the user to execute.

**MVP agent team (explicit in the vision):**

- **Supervisor** — breaks down constraints and manages the budget
- **Flight Broker** — uses tools to find and validate the optimal flight route
- **Lodging Broker** — secures accommodations within the remaining budget
- **Concierge Agent** — navigates the web to book local dining or events (in MVP this means producing bookable/reservation links, not charging a card)

**Canonical example:** *"Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."*

### Future Scope (v2+)

What we are explicitly deferring:

- Real financial transactions and credit-card integration
- System-executed bookings (vs. the user clicking direct-booking links)
- Broader autonomous back-office errands beyond travel (stated in the philosophy; the product itself is complex travel)

### Out of Scope / Non-Goals

- Charging the user or holding payment instruments
- Acting as the merchant of record
- Advice-only chatbot output with no coordinated itinerary or booking links
- Invented channels or markets not in the vision (B2B travel desks, white-label for OTAs, etc.)

---

## Core Workflows

Keep this narrative. Leave Given/When/Then to later user stories.

### 1. Constrained trip request → coordinated itinerary

1. The consumer submits a natural-language prompt that includes budget, dates, and preferences (destination, trip purpose, dining/event needs, as in the Tokyo example).
2. The Supervisor extracts constraints and holds the overall budget.
3. The Supervisor delegates to the Flight Broker, Lodging Broker, and Concierge Agent.
4. Specialists use tools (flight search/validation, lodging search, web navigation for dining/events) and return candidates that fit their slice of remaining budget.
5. The Supervisor validates that the combined package still respects the original budget.
6. The user receives a single finalized itinerary: flights + lodging + dining/events, internally consistent, with direct-booking links to complete each booking themselves.

### 2. Cross-agent budget handoff (planning, not payment)

1. A specialist consumes part of the budget in planning terms (e.g. Flight Broker selects a $1,500 route).
2. Remaining budget is visible to the next specialist (Lodging Broker has $1,500 left on a $3,000 cap).
3. Concierge selections must still fit whatever remains after flights and lodging, or the Supervisor must rebalance or reject combinations that overflow.
4. The user never sees a payment flow in MVP; they only see priced components and links.

### 3. User executes bookings off-platform

1. The user reviews the coordinated itinerary and the per-item direct-booking links.
2. The user completes each booking on the destination site (airline, lodging, restaurant/event).
3. The product’s job for MVP ends at a bookable, budget-valid package, not a confirmed paid reservation.

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
- [ ] **Stakeholder acceptance** — a named **role** accepted the outcome (do not invent sign-off)

Not done if half the stories shipped a different product than the epic described and nobody updated the epic; if documentation is “later” with no ticket; or if integration was only tested on a developer laptop.

### Epic 1 — Natural-language intake of trip constraints

**Outcome:** A consumer can submit a trip prompt and the system has a structured, machine-usable set of constraints (budget, dates, preferences) for the Supervisor.

**MVP includes:** Parsing/accepting budget, dates, and preferences from free text (Tokyo-style request).

**Not this epic:** Booking, payments, or UI pixel details.

### Epic 2 — Supervisor and specialist-agent delegation

**Outcome:** A single request spawns a team—Supervisor, Flight Broker, Lodging Broker, Concierge Agent—and work is autonomously delegated; the user does not manually assign agents.

**MVP includes:** Tool use for finding/validating a flight route; lodging search within remaining budget; concierge web navigation for dining/events.

**Not this epic:** Charging cards or confirming paid reservations.

### Epic 3 — Shared remaining-budget coordination

**Outcome:** The combined itinerary cannot silently overflow the user’s cap. If one specialist consumes part of the budget, others operate on what is left; the package is validated as a whole.

**MVP includes:** The vision’s example semantics (flight $1,500 → lodging knows $1,500 remains).

**Open inside this epic:** What happens when no feasible combination exists (failure UX is not specified in the vision).

### Epic 4 — Finalized itinerary with direct-booking links

**Outcome:** The consumer receives one coordinated itinerary (flights + hotels + dining) with actionable, direct-booking links they can execute themselves.

**MVP includes:** Output is not “just text advice.”

**Not this epic:** Completing the purchase in-product.

---

## Risks & Dependencies

- **Teams, APIs, or existing systems:** The vision does not name vendors. Implied dependencies are flight search/validation tools for the Flight Broker, lodging search tools for the Lodging Broker, web-capable tools for the Concierge Agent, and some product surface to submit a prompt and read an itinerary (channel not specified). Domain and layer consultant catalogs are empty; travel and orchestration constraints are not yet encoded in `DOMAIN.md` / `LAYER.md`.
- **Biggest product/technical risks:**
  - No live bookings in MVP vs. the philosophy of executing errands from start to finish — links may feel incomplete if they expire, are wrong, or cannot be reserved.
  - Budget coordination across agents is the core proof; race conditions, stale remaining-budget, and infeasible combinations are the main failure modes.
  - “Optimal” flight is undefined (price vs. duration vs. stops).
  - “Secures accommodations” / “book local dining” language vs. MVP “no transactions” — specialists must stop at validated options + links, not paid holds.
  - Web navigation for concierge is brittle (site changes, bot blocking, geo/language).
  - The acquisition thesis depends on proving cohesive flights + hotels + dining; a weak concierge or missing links undercuts the story.

---

## Open Questions

- [ ] What product channel is MVP? (chat, web form, API-only) — not in the vision
- [ ] Which flight, lodging, and dining data sources or tools are in bounds?
- [ ] What does “optimal” flight route mean when budget and dates are the only named constraints?
- [ ] When no combination fits the budget, what does the user get? (fail, ask to relax, partial itinerary)
- [ ] Are booking links required to be live/deep links, or is a search-result URL enough?
- [ ] Does “book dining” in MVP mean a reservation hold, a booking page link, or a restaurant listing?
- [ ] Single traveler vs. party size? Only implied by the example prompt
- [ ] Destination coverage: Tokyo example only, or any destination the tools can reach?
- [ ] Persistence / accounts / itinerary history? Unmentioned
- [ ] Named role for epic stakeholder acceptance? Unmentioned — do not invent one

---

## Next step

Do not write sprint-level user stories yet. After these epics are approved, run `/sdlc-user-story-refiner` on each epic (recommended order: Epic 1 → 2 → 3 → 4).
