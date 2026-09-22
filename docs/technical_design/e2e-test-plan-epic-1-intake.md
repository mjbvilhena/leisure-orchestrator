# E2E test plan: Epic 1 chat-like journeys

Journey-level strategy **before** implementation. `sdlc-e2e-scripter` executes this at verify time. This file is not Playwright/Cypress scripts.

## Metadata

| Field | Value |
| --- | --- |
| Journeys in scope | US-E1-01–07 on **web** and **CLI** chat-like surfaces (approved artefacts). UX: `docs/technical_design/ux-epic-1-intake.md` (Draft). |
| Runner | **None in repo.** When application CI lands, match that runner. Do not introduce a second E2E stack. |
| Base URL source | Local / CI ephemeral only. Environment variable for the web origin. **Forbidden:** production URLs and production Google accounts. |
| Layer constraints | Orchestration `LAYER.md`: web+CLI chat-like; Google sign-in; widget not primary intake. UI layer consultant name not published. |

Google in CI: use a **test double / sandbox** for the IdP (RFC/API allow exchanging through the backend). Do not commit real refresh tokens. Device-grant `user_code` is only relevant if RFC-0001 is accepted.

Selectors: role/name/label from UX copy that is sourced from stories (“Authenticate with Google”; dimension names price, duration, stops). Do not depend on pixel layout. Party-size ask **exact string** is a UX open question — assert that the product **asks for party size** (AC language), not a guessed slogan.

## Journeys

### J-1: Signed-in web intake through a complete ConstraintSet

- **Actor:** consumer in the travel market. **Precondition:** test Google double will succeed; empty history allowed.
- **Steps (Given/When/Then):**
  1. Given a consumer on the web chat-like surface, When they are not signed in, Then they cannot use trip intake as a signed-in account holder (US-E1-01 AC1).
  2. When they authenticate with Google, Then they are a signed-in account holder on web (US-E1-01 AC4).
  3. When they submit the canonical Tokyo prompt, Then the product accepts it as primary intake (not a multi-field form) (US-E1-02 AC1, AC3).
  4. Then the product asks for party size and does not treat the set as complete (US-E1-04 AC1–AC2).
  5. When they supply party size in the chat-like surface, Then it is recorded (US-E1-04 AC3).
  6. When they rate price, duration, and stops 1–5, Then all required dimensions are visible together in the web widget (US-E1-05 AC1, AC2, AC5).
  7. Then intake holds a machine-usable set including those fields and the matrix, not an itinerary (US-E1-03).
- **Assertions:** accessible name of the Google control; prompt accepted; party-size ask present; widget shows three dimensions at once; no finalized itinerary/booking UI (Epic 1 non-goal).
- **Unhappy sibling:** skip Google → still not in trip intake (US-E1-01). Do not invent a guest button.

### J-2: Same complete path on CLI

- **Actor / precondition:** same, CLI chat-like surface.
- **Steps:** Mirror J-1 with US-E1-01 AC2/AC5, US-E1-02 AC2, US-E1-05 AC6 (TUI widget simultaneous).
- **Assertions:** TUI shows all required scoring dimensions together; chat-like prompt (not a multi-field form).
- **Unhappy sibling:** unauthenticated CLI cannot complete intake.

### J-3: Destination other than Tokyo

- **Actor:** signed-in consumer (web **or** CLI; one surface is enough if clients share the backend, but AC requires intake on both channels — run once per surface if cheap, else web + contract TP-9).
- **Steps:** Given signed-in, When they name a destination other than Tokyo in the prompt, Then intake does not reject it solely because it is not Tokyo (US-E1-06 AC2).
- **Assertions:** destination recorded; no city-picker as primary intake.
- **Unhappy sibling:** n/a (unreachable-destination UX is not this epic).

### J-4: Itinerary history isolation and empty

- **Actor A and B:** two signed-in test accounts (namespaced fixtures).
- **Steps:**
  1. Given A has no coordinated itineraries, When A retrieves history on web, Then A does not see B’s itineraries; empty is allowed; no marketing upsell (US-E1-07 AC3, AC4).
  2. Given B has seeded coordinated itinerary record(s), When B retrieves history, Then B sees those records (US-E1-07 AC1).
  3. When A retrieves history, Then A still does not see B’s records (US-E1-07 AC2).
  4. Repeat retrieval on CLI for at least one account (US-E1-07 AC4).
- **Assertions:** list empty vs own ids only; never B’s ids in A’s session.
- **Unhappy sibling:** empty list (named). How the user **opens** history is a UX open question — the journey must use whatever control/copy the Product Owner later agrees; until then, E2E may call the same backend list the UI will use, but a UI journey is required for AC4 once the trigger is named.

## Stability

- [ ] Roles/labels over brittle CSS or nth-child
- [ ] Wait on API `complete` / visible widget, not arbitrary `sleep`
- [ ] Isolation: namespaced accounts per test; no shared mutable production user
- [ ] Seeds idempotent or unique per run

## Data and secrets

- Fixtures only. Never commit real Google tokens.
- No real personal data in traces committed to git.
- Third-party Google production is **not** the CI IdP unless a later ADR says otherwise.

## Environments

| Env | When to run | Forbidden |
| --- | --- | --- |
| Local / CI ephemeral | default | production data, production Google users |
| Shared staging | only if the Product Owner later says so | mutating other people’s accounts |

## Out of scope

Visual snapshot farms; load tests; Epic 2–4 agent/budget/booking journeys; accessibility audit (verify-time `sdlc-a11y-auditor`); invented routes or marketing copy.

## Anti-patterns avoided

One script that “clicks the whole MVP”; production URLs; hard-coded session cookies in git; asserting only that a page loaded.
