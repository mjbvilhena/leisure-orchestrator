# Layer: Orchestration

Seed for `get_layer_consultant` (`orchestration`). Place this file at the repository root unless a later convention is documented.

**Authority:** `docs/product/specification.md` (grounded in `docs/product/vision.md`). Do not treat this file as a source of new product decisions.

**Rule:** Every bound below cites its specification source. If an orchestration fact is not cited, it is not a product rule. Travel-domain inventory rules live in `DOMAIN.md`.

## Why this layer exists

- Current consumer AI provides advice and then abandons the user when it is time to do the work. The strategic goal is to prove the **orchestration framework**. *(Source: Background & Value Proposition)*
- MVP success is proving the **Multi-Agent Orchestration Engine**: accept a constrained natural-language prompt, autonomously delegate to specialist agents, keep the combined itinerary inside budget, and return a finalized itinerary. *(Source: Background & Value Proposition)*
- A platform that cohesively handles the *entire* trip (flights + hotels + dining) is the proof, not advice-only chat. *(Source: Background & Value Proposition)*

## Consumer surfaces

- **Channel:** Web + CLI, both **chat-like**. Not a multi-field form as primary intake, not API-only. *(Source: Resolved with Product Owner — Channel; In Scope MVP)*
- The consumer is **signed in** (accounts are in MVP). **Google sign-in** is in scope as a way the consumer authenticates on web and CLI. *(Source: Core Workflows §1; Resolved with Product Owner — Persistence; Resolved with Product Owner — Google sign-in)*
- Intake is a natural-language prompt with budget, dates, destination, preferences, and required party size, plus a 1–5 scoring matrix. *(Source: Epic 1; Core Workflows §1)*

## Agent team (named)

The user does **not** manually assign agents. A single request spawns this team and work is autonomously delegated. *(Source: Epic 2)*

| Agent | Orchestration responsibility | Source |
| --- | --- | --- |
| **Supervisor** | Breaks down constraints, holds the budget, applies the user’s 1–5 scoring matrix, rebalances or rejects overflow | In Scope MVP — MVP agent team |
| **Flight Broker** | Uses the curated flight KB (web fallback if empty) to find and validate a flight route | In Scope MVP — MVP agent team |
| **Lodging Broker** | Secures accommodations within the remaining budget (validated option + deep link, or charged booking if the user opted in) | In Scope MVP — MVP agent team |
| **Concierge Agent** | Uses the curated hospitality/event KB (web fallback if empty) to produce reservation/booking page links; charges a card only if the user chose that fulfillment path | In Scope MVP — MVP agent team |

## Delegation and data sources

- Autonomously delegate tasks to specialist agents. *(Source: In Scope MVP; Epic 2)*
- Each specialist uses an **internal curated knowledge base / allowlist first**; **live web only if the allowlist has no hit**. *(Source: In Scope MVP; Resolved with Product Owner — Data sources)*
- **Per-agent KB:** internal curated KB per specialist, **not** a consumer-facing editor. *(Source: Resolved with Product Owner — Per-agent KB; Future Scope)*
- Unbounded web as the first/only source is **not** this product. *(Source: Epic 2 — Not this epic)*
- Specialists return candidates that fit their remaining-budget slice and the scoring matrix. *(Source: Core Workflows §1)*

## Shared remaining-budget coordination

Budget coordination across agents is the core proof. *(Source: Risks)*

1. The Supervisor extracts constraints, **holds the overall budget**, and keeps the scoring matrix. *(Source: Core Workflows §1)*
2. A specialist consumes part of the budget in planning terms (vision example: Flight Broker selects a $1,500 route). *(Source: Core Workflows §2; Epic 3)*
3. Remaining budget is visible to the next specialist (Lodging Broker has $1,500 left on a $3,000 cap). *(Source: Core Workflows §2; Epic 3)*
4. Concierge selections must still fit whatever remains after flights and lodging, or the Supervisor must rebalance or reject combinations that overflow. *(Source: Core Workflows §2)*
5. The Supervisor validates that the **combined package** still respects the original budget. *(Source: Core Workflows §1; Epic 3)*
6. The combined itinerary **cannot silently overflow** the user’s cap. *(Source: Epic 3)*

Scoring is judgement **still bound by budget and dates**. *(Source: Resolved with Product Owner — “Optimal” flight)*

## Fail-closed infeasibility

Sequence required by the specification *(Source: Core Workflows §3; Epic 3; Resolved with Product Owner — No feasible combination)*:

1. The Supervisor first tries to **rebalance** slices so the package fits the cap, using the user’s 1–5 matrix.
2. If no combination fits, the user does **not** receive an overflowing itinerary.
3. The user receives a **closed failure**: why it cannot be met, the closest in-budget attempt if one exists, and which constraints they can relax (budget, dates, destination, dining/event, party size).
4. If they relax a constraint in the chat-like surface, the request re-enters the constrained trip-request workflow.
5. Returning an overflowing itinerary or a partial package that pretends the cap was met is **out of this product**. *(Source: Epic 3 — Not this epic)*

## Finalized itinerary and fulfillment choice

- The consumer receives **one** coordinated itinerary (flights + lodging + dining), internally consistent. Output is not “just text advice.” *(Source: Core Workflows §1; Epic 4)*
- The itinerary is **saved to their account history**. *(Source: Core Workflows §4; Epic 1 — Persistence)*
- The user then chooses **direct-booking links** or **in-product charged booking**. *(Source: Core Workflows §1; Epic 4; Resolved with Product Owner — Payments)*
- **Links path:** they complete each booking on the destination site via deep links. Product job ends at a bookable, budget-valid package. *(Source: Core Workflows §4)*
- **Charged path:** optional; **pass-through** (providers charge the user). This product is not merchant of record. *(Source: Core Workflows §4; Out of Scope)*
- Payment appears **only if** the user opted into charged booking. *(Source: Core Workflows §2)*
- Dual-mode fulfillment **widens** the vision’s “no real financial transactions” stance; liability and card integration remain risks, not invented vendors. *(Source: In Scope MVP; Risks)*

## Persistence (orchestration-relevant)

- **Accounts and itinerary history** are in MVP and belong to Epic 1. *(Source: Resolved with Product Owner — Persistence)*
- **Google sign-in:** the consumer authenticates with Google on the MVP web and CLI chat-like surfaces as a way to be a signed-in account holder. Other social providers, generic SSO/SAML, password-reset, and guest/anonymous intake are not in scope. *(Source: Resolved with Product Owner — Google sign-in)*
- A signed-in consumer can retrieve past coordinated itineraries. *(Source: Epic 1)*

## Explicitly out of scope (orchestration)

- Advice-only chatbot output with no coordinated itinerary or booking links. *(Source: Out of Scope / Non-Goals)*
- Search-result URLs presented as booking links. *(Source: Out of Scope / Non-Goals)*
- Acting as merchant of record. *(Source: Out of Scope / Non-Goals)*
- API-only B2C or a multi-field form as the primary intake. *(Source: Out of Scope / Non-Goals; Resolved with Product Owner — Channel)*
- Social login other than Google; generic SSO/SAML; password-reset flows; guest/anonymous intake; multi-user trip workspaces; sharing. *(Source: Resolved with Product Owner — Google sign-in; Epic 1 — Not this epic)*
- Consumer-facing KB editor. *(Source: Future Scope; Epic 2)*
- The user manually assigning agents. *(Source: Epic 2)*

## Unset — do not invent

The specification does not state the following. Omit them from implementation guesses; do not add them here as rules.

- Orchestration runtime, framework name, message bus, or workflow engine
- Parallel vs sequential specialist execution
- How remaining budget is stored or locked (race conditions are named as a **risk**, not as a chosen design) *(Source: Risks)*
- Named vendors for KBs, web fallback, or payments *(Source: Resolved with Product Owner — Data sources: “No vendors named yet”)*
- Identity providers other than Google *(Source: Resolved with Product Owner — Google sign-in names Google only)*
- KB file format, allowlist schema, or refresh cadence (staleness is a **risk**, not a policy) *(Source: Risks)*
- Authentication protocol, SDK, or session store beyond Google sign-in as the in-scope method *(Source: Resolved with Product Owner — Google sign-in names the provider, not the protocol)*
- Card-integration provider or checkout UX beyond pass-through vs links
- Feature flags, rollout rings, or SLA/latency numbers
- Partial-itinerary UX other than the specified fail-closed path
