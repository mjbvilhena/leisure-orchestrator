# Test plan: Epic 1 intake

Plan for proving Epic 1 at unit, integration, and contract level **before** implementation. `sdlc-test-writer` executes this at verify time. Journeys: [`e2e-test-plan-epic-1-intake.md`](e2e-test-plan-epic-1-intake.md). This file does **not** contain executable tests.

## Metadata

| Field | Value |
| --- | --- |
| Subject | Epic 1 — US-E1-01 through US-E1-07 (approved story artefacts, 2026-09-20). Delivery not Done. |
| Framework | **None in repo today.** README: TypeScript is a likely language; linting and unit tests for it will be added when application code lands. Do not switch stacks if setup-repo later adds a TypeScript runner — match that runner. Status below is **planned**. |
| Related DoD | `user story` (implementation Done = automation green **and** all Must AC); `feature`; `api change`; `ui change`; `security change` |
| Evidence cited | Stories under `docs/product/user-stories/epic-1/`; `docs/product/specification.md`; RFC-0001; API design/contract (Draft); UX artefact (Draft); `DOMAIN.md`; `LAYER.md` |

## Scope

- **In:** Application session after Google; ConstraintSet assembly (named fields only); party-size completeness gate; scoring-matrix 1–5 closed set; destination not city-allowlisted; itinerary history isolation; HTTP operations in the intake contract.
- **Out:** Executable test files (verify-time); performance/load; security lab / pentest (threat model is separate); Epic 2–4 planning, budget, booking; pixel screenshot tests; coverage-percentage goals.
- **Oracles:** API contract statuses and ConstraintSet shape; story Given/When/Then; fixtures seeded per account. Do not invent extra fields.

`feature` / `user story` DoD gaps: no automation yet; Must AC not shipped. Do not soft-pass. `api change` contract tests are listed in the contract file and mirrored below.

## Risk-based coverage

Order by user/data risk, not by file.

| ID | Behavior | Level | Risk if wrong | Status | AC |
| --- | --- | --- | --- | --- | --- |
| TP-1 | Unauthenticated caller cannot create a trip request or list itineraries | contract / integration | Guest intake (out of scope) and history leak | planned | US-E1-01 AC1–AC2 |
| TP-2 | Session is bound to an application `Account`; history reads use that identity | integration | History attached to the wrong person | planned | US-E1-01 AC3 |
| TP-3 | Canonical prompt is accepted; ConstraintSet maps duration 4-day, Tokyo, under $3,000, high-end sushi preference; not an itinerary | unit (extractor) + contract | Golden path unusable; Epic 2 gets prose | planned | US-E1-02 AC3; US-E1-03 AC2–AC3 |
| TP-4 | Primary intake is `prompt` string, not a required multi-field budget/dates form | contract | Violates channel decision | planned | US-E1-02 AC4 |
| TP-5 | Missing party size → `complete` false, `missing` includes `party_size`; extractor must not invent a default of one | unit + contract | Planning starts without a required constraint | planned | US-E1-04 AC1–AC4 |
| TP-6 | Chat turn can record party size into ConstraintSet | integration | Ask path does not complete US-E1-03 | planned | US-E1-04 AC3; US-E1-03 AC1 |
| TP-7 | Scoring PUT requires price, duration, stops each 1–5 together; unknown fields / `6` fail closed | contract | One-at-a-time or invalid judgement stored | planned | US-E1-05 AC1–AC3 |
| TP-8 | `complete` true only with party size **and** matrix; matrix does not replace budget/dates fields | unit | Supervisor-ready gate wrong | planned | US-E1-05 AC4; US-E1-03 AC4 |
| TP-9 | Destination other than Tokyo is stored; no city allowlist in intake | unit + contract | Product locked to Tokyo | planned | US-E1-06 AC1–AC4 |
| TP-10 | Account A never receives Account B’s itinerary ids or ConstraintSet (non-owner GET `404`) | integration | Cross-account disclosure | planned | US-E1-07 AC2–AC3 |
| TP-11 | Empty history returns `items: []` for an account with no records | contract | False data or upsell-shaped payload (forbidden) | planned | US-E1-07 AC3 |
| TP-12 | Idempotent POST trip-request (same key + body) returns the same `id`; different body `409` | contract | Duplicate or swapped prompts | planned | api change DoD |
| TP-13 | Error bodies do not include `session_token`, Google `code`, or `device_code` | integration | Credential leak in client-visible errors | planned | security change; threat model T-8 |
| TP-14 | Prompt/turn over size limit → `prompt_too_large` | contract | Unbounded extractor input | planned | API contract size limit |
| TP-15 | Google web complete with mismatched `state` does not create a session | integration | Wrong-flow session (threat T-2) | planned | US-E1-01; API contract |

Happy path: TP-3 + TP-6 + TP-7 + TP-8 (canonical prompt → party size turn → matrix → `complete` true).

Authorization / empty: TP-1, TP-10, TP-11.

Not a bugfix: no regression-from-old-code row.

## Fixtures and doubles

- **Accounts:** `acc_example_a`, `acc_example_b` — synthetic ids only. No real emails or Google subjects in git.
- **Prompts:** specification canonical Tokyo sentence; a second destination string that is not Tokyo (e.g. a generic city name in fixtures — not a real traveler’s trip).
- **History seed:** insert `itn_example_b` owned by B when testing A’s empty or A-only list.
- **Mock:** Google token endpoint (do not call production Google in CI). Clock/UUID: inject for deterministic `trq_` ids if the implementation needs it.
- **Real:** ConstraintSet schema validation; authz checks against the store used in integration tests (in-memory is acceptable if it is the same authz code path).

## Unhappy paths

| Expected | Test |
| --- | --- |
| `401` `unauthenticated` | TP-1, TP-15 |
| `404` `not_found` for non-owner trip-request | TP-10 |
| `400` `invalid_request` on scoring | TP-7 |
| `400` `prompt_too_large` | TP-14 |
| `409` `idempotency_conflict` | TP-12 |
| `complete: false` when party size missing | TP-5 |

## Definition of ready for this plan

- [ ] Framework and paths match the repo — **blocked** on `sdlc-setup-repository` / first application tree (README currently docs+CI only)
- [x] No secrets or production URLs in this plan
- [ ] Bugfix reproduce-then-pass — n/a
- [x] Domain/layer: named fields only; no guest; no city list; no extra IdP; scoring simultaneous at API (all dimensions in one PUT)

Do not claim a coverage percentage. Do not mark stories implementation-Done from this document.
