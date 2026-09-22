# API design: Epic 1 intake backend

Design-time document for the first-party HTTP API used by the web and CLI chat-like clients. Pair with [`api-contract-epic-1-intake.md`](api-contract-epic-1-intake.md). Pair with Definition of Done `api change` (and `security change` — this surface crosses a trust boundary).

**Quality bar:** A client author can implement against this without a meeting. Breaking vs additive is explicit. Errors are a closed set. Authn/z is named, not "secure".

This document is **Draft**. It is not technical-design approval. RFC-0001 is also Draft. Do not implement until those artefacts have named human sign-off or an explicit “treat as approved” sentence.

## Metadata

| Field | Value |
| --- | --- |
| API name / surface | Leisure Orchestrator intake API |
| Style | REST + JSON. **House style is new:** this repository has no existing HTTP API. This document proposes the style; it does not claim a prior convention. |
| Status | Draft |
| Related RFC / ADR | [`rfc-0001-epic-1-intake-architecture.md`](rfc-0001-epic-1-intake-architecture.md). No ADR yet. |
| Domain / layer | `leisure orchestrator` (travel); orchestration. Consultants honor `DOMAIN.md` / `LAYER.md`. Layer name `api` is not published. |
| Consumers | First-party **web** chat-like UI and **CLI** chat-like TUI only. Not a consumer product channel (API-only B2C is out of scope). |

## Problem and consumers

- **Who calls this and why:** The approved Epic 1 stories require Google sign-in, natural-language intake, a structured ConstraintSet for the Supervisor, simultaneous scoring capture, and per-account itinerary history on web and CLI (`docs/product/user-stories/epic-1/`, US-E1-01 through US-E1-07). Both clients need a shared backend so Account is one persistence identity (US-E1-01 AC3; RFC-0001).
- **What is wrong with the current interface:** There is none. No application source exists (README; backlog Task 1.2).
- **Non-goals:** Supervisor/specialist operations (Epic 2); remaining-budget (Epic 3); itinerary write/fulfillment (Epic 4); public third-party developer API; guest access; identity providers other than Google; pagination/search/filter of history (unset in US-E1-07); pixel-level widget payloads.

`api change` DoD (design-time gaps, not permission to invent behavior): contract is the sibling markdown (OpenAPI path still **proposed**); compatibility labeled below; error model in this document; authn/z per operation; idempotency per write; validation and synthetic examples in the contract; provider tests are listed as **open work** for implement/verify. Changelog is not due until a shipped version exists.

`security change` DoD (design-time gaps): threat model is [`threat-model-epic-1-intake.md`](threat-model-epic-1-intake.md) (**Draft**; residual risk not accepted; verify-time `security_review` still required when code lands); authn/z is specified per operation; sensitive fields must not appear in logs or URLs; no hard-coded credentials; rate/size limits considered below; audit events named without secret payloads; authz negative tests are contract-test work; no exploit PoCs; no certification claims.

## Resources and operations

Base path: `/v1`. JSON request/response bodies unless noted. Session credential: `Authorization: Bearer <session_token>` (application session from RFC-0001, not a Google access token used as the durable identity).

| Operation | Method + path | Idempotent? | Authz | Success | Documented errors |
| --- | --- | --- | --- | --- | --- |
| Start Google sign-in (web, PKCE) | `POST /v1/auth/google/web/start` | no | public (unauthenticated) | 200 | 400, 429 |
| Complete Google sign-in (web) | `POST /v1/auth/google/web/complete` | yes (authorization `code` is single-use) | public | 200 | 400, 401, 429 |
| Start Google sign-in (CLI device) | `POST /v1/auth/google/device/start` | no | public | 200 | 429 |
| Poll Google device sign-in | `POST /v1/auth/google/device/poll` | yes (same `device_code` until issued or expired) | public | 200 or 202 | 400, 401, 429 |
| Current account | `GET /v1/me` | yes | signed-in `Account` | 200 | 401 |
| End application session | `DELETE /v1/session` | yes | signed-in `Account` | 204 | 401 |
| Submit trip prompt | `POST /v1/trip-requests` | yes if `Idempotency-Key` replayed | signed-in `Account`; creates a request owned by that account | 201 | 400, 401, 429 |
| Get trip request | `GET /v1/trip-requests/{id}` | yes | owner `Account` only | 200 | 401, 404 (non-owner is `404`, not another account’s body) |
| Append chat turn | `POST /v1/trip-requests/{id}/turns` | yes if `Idempotency-Key` replayed | owner `Account` only | 200 | 400, 401, 404, 409 |
| Put scoring matrix | `PUT /v1/trip-requests/{id}/scoring-matrix` | yes | owner `Account` only | 200 | 400, 401, 404 |
| List itinerary history | `GET /v1/itineraries` | yes | signed-in `Account`; **only** that account’s records | 200 | 401 |

`DELETE /v1/session` is an engineering session-end control (defensive). Product-facing sign-out **UX** and session lifetime remain RFC-0001 open question 4 — this operation does not invent a password-reset or multi-device account-center story.

`POST /v1/trip-requests/{id}/turns` is the chat-like follow-up (including the party-size answer). It is not a multi-field form as primary intake. The primary prompt is `POST /v1/trip-requests`.

`PUT .../scoring-matrix` requires **all** required dimensions in one body so the contract cannot capture scores one-at-a-time. Widget/TUI presentation is a client concern (`ux design`); the API does not describe pixels.

## Representation rules

- **Identity:** opaque prefixed strings (`acc_…`, `trq_…`, `itn_…`, `ses_…`). Not Google `sub` in URLs. Not email.
- **URL structure:** `/v1/{collection}` and `/v1/{collection}/{id}`. No email or token in path or query.
- **Pagination / filter / sort:** **not in v1** for itineraries (US-E1-07: retention, search, filter, pagination unset). `GET /v1/itineraries` returns the stored set for the account, which may be empty. Adding pagination later is an **additive** change.
- **Idempotency keys:** header `Idempotency-Key` (client-generated opaque string) on `POST /v1/trip-requests` and `POST .../turns`. Replay with the same key and same body returns the original success. Same key with a different body is `409`.
- **Long-running work:** device poll uses `202` while the consumer has not finished Google authorization. Constraint extraction is synchronous in this design (`hypothesis:` if extraction later becomes async, that is a new job resource and a breaking or additive revision — not this draft).
- **ConstraintSet** fields are only those named in the specification (RFC-0001 table). Extra required fields are forbidden. `complete` is true only when `party_size` and `scoring_matrix` are present. Incomplete sets are returned; they are not “ready for the Supervisor.”
- **Itinerary list items in Epic 1:** `id` only. Flights/lodging/dining body is Epic 4; Epic 1 retrieval is “these records exist for this account.” Additive fields later must not change `id` meaning.

## Error model

House envelope (new; use everywhere in this API):

```json
{
  "error": {
    "code": "unauthenticated",
    "message": "An application session is required."
  }
}
```

`code` is a stable machine token. `message` is safe to show in a chat-like surface; it must not include tokens or Google subjects. No `200` with an error body.

| Code | HTTP | When | Client action |
| --- | --- | --- | --- |
| `invalid_request` | 400 | Missing/malformed JSON, missing PKCE fields, scoring values outside 1–5, missing required matrix dimensions, prompt empty | Fix request |
| `prompt_too_large` | 400 | Prompt or turn text exceeds the documented size limit | Shorten text |
| `unauthenticated` | 401 | Missing/expired/unknown application session; Google complete/poll failed to establish a session | Start Google sign-in again |
| `forbidden` | 403 | Reserved; Epic 1 trip-request non-owner access uses `404` instead (do not confirm another account’s ids) | Treat as missing |
| `not_found` | 404 | Unknown `trip-requests/{id}` **for this account** (do not confirm existence on another account) | Treat as missing |
| `idempotency_conflict` | 409 | Same `Idempotency-Key` with a different body | New key |
| `not_complete` | 409 | Client attempts a Supervisor-planning call — **no such operation in this API**; reserved if a later epic adds one. Epic 1 clients must not call planning. | N/A in Epic 1 |
| `authorization_pending` | 202 body unused; status 202 | Device poll, user has not finished Google authorization | Retry after `interval_seconds` |
| `rate_limited` | 429 | Auth start/complete/poll or prompt submit exceeded the engineering rate limit | Honor `Retry-After` |

`not_complete` is documented so later epics do not invent a 200-with-error for “party size missing.” Epic 1 signals incompleteness **inside** the ConstraintSet (`complete: false`, `missing` array), not as a failed prompt submit.

## Compatibility and versioning

- Prefix `/v1`. Additive optional fields and new endpoints under `/v1` do not require a bump.
- **Breaking:** removing a field, changing a field’s type or meaning, changing error `code` strings, requiring a new request field, putting secrets in URLs, returning another account’s itineraries.
- No deprecation window is stated in the product specification — do not invent one.
- Enum additions (`missing` values): clients must tolerate unknown `missing` strings (tolerant readers).
- OpenAPI file in-repo is **proposed** at `docs/technical_design/openapi/intake-v1.yaml` (not written in this draft). The markdown contract is the checked-in contract until that file exists (`api change` DoD).

## Security (defensive)

- **Authentication:** Google as the only consumer IdP (product rule). Application session after exchange (RFC-0001 proposal). Public operations are the Google start/complete/device pair only.
- **Authorization:** trip requests and history are object-level: the session’s `Account` only. `GET /v1/itineraries` has no `account_id` query parameter (that would invite IDOR). Unknown ids and non-owner trip-request ids are `404`; a documented test must prove account A cannot read account B’s `trq_…` (never B’s ConstraintSet).
- **Sensitive fields:** Google `code`, `code_verifier`, `device_code`, refresh tokens, `session_token` — never in logs, never in query strings, never in error messages. ConstraintSet trip details are personal data: do not log full prompts at info.
- **Rate limits:** apply to unauthenticated auth endpoints and to `POST /v1/trip-requests`. Numeric caps are an engineering constant in the contract, not a product SLO.
- **Size limits:** prompt and turn text have a maximum character length in the contract.
- **Audit (no secret payloads):** `auth.session_created`, `auth.session_ended`, `intake.trip_request_created`, `history.list`. Identifiers: application `Account` id and trip-request id only.
- Do not write exploit examples. Do not claim SOC/ISO/“compliant.”

## Observability

- Propagate `X-Request-Id` (client-supplied or server-issued); echo it on responses.
- Metrics **proposed** (none exist in the repo): `auth_session_created_total`, `trip_request_complete{complete="true|false"}`, `itineraries_list_total{empty="true|false"}`. No latency SLO numbers.

## Open questions

1. Numeric rate-limit and prompt size constants — **Engineering** (contract proposes values; review may change them).
2. Session lifetime / refresh — **Product Owner / Engineering** (RFC-0001 Q4). `DELETE /v1/session` exists; expiry duration is unset.
3. Extractor runtime — **Engineering** (RFC-0001 Q2). The API returns ConstraintSet; it does not expose the extractor.
4. Persistence engine — **Engineering** (RFC-0001 Q1).
5. Whether device poll uses `202` vs OAuth-style `400` + `authorization_pending` — **Engineering**. This design uses `202` so clients do not treat pending as a malformed request.
6. OpenAPI YAML generation — **Engineering**; markdown contract is SSOT until the YAML exists.

## `api change` / `security change` DoD checklist (this draft)

| Item | This artefact |
| --- | --- |
| Contract updated | Sibling `api-contract-epic-1-intake.md` (OpenAPI YAML still proposed) |
| Compatibility labeled | Additive `/v1`; breaking listed above |
| Error model | Closed `code` set; no 200-with-error |
| Authn/z per operation | Table above; negative tests listed in the contract |
| Idempotency | Header on creating POSTs; PUT scoring-matrix is naturally idempotent |
| Validation | Contract field tables |
| Examples | Synthetic in the contract |
| Provider/consumer tests | Listed; **not implemented** (no application source) |
| Changelog | Not applicable until first ship |
| Threat model | **Draft** at [`threat-model-epic-1-intake.md`](threat-model-epic-1-intake.md); residual risk not accepted; not named-human-approved |
| Secrets | None in examples |
| Certification claims | None |
