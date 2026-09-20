# Threat model: Epic 1 intake (Google sign-in and history)

High-level, **defensive** STRIDE review of the **proposed** Epic 1 design. This is not a penetration test, not a certification, and not a vulnerability disclosure. Residual risk is **not** accepted by a named human in this draft.

## Metadata

| Field | Value |
| --- | --- |
| Subject | Epic 1 intake: RFC-0001, intake API, UX artefact (all Draft) |
| Author role | `sdlc-threat-modeler` |
| Inputs reviewed | `docs/technical_design/rfc-0001-epic-1-intake-architecture.md`; `docs/technical_design/api-design-epic-1-intake.md`; `docs/technical_design/api-contract-epic-1-intake.md`; `docs/technical_design/ux-epic-1-intake.md`; `docs/product/user-stories/epic-1/` US-E1-01–07; `docs/product/specification.md`; `DOMAIN.md`; `LAYER.md`; `get_domain_consultant` (`leisure orchestrator`); `get_layer_consultant` (`orchestration`, `leisure orchestrator`). Layer names `api`, `ui`, `database` are **not** in the consultant catalog. Domain `auth` is **not** published; Google sign-in is a Product Owner rule in the spec/LAYER. |
| Residual risk accepted by | none (Draft) |

`security change` DoD: this note is the design-time STRIDE file. Verify-time `security_review` against an actual diff is still required when code lands. No exploit PoCs. No certification claims.

## System under review

Architecture **as proposed** in RFC-0001 (not implemented; no application source in the repo today).

**Trust boundaries (evidenced by the RFC/API drafts):**

- Consumer browser (web chat-like UI) ↔ Google identity provider
- Consumer CLI (chat-like TUI) ↔ Google identity provider (proposed device grant)
- Web/CLI ↔ intake backend (`/v1`)
- Intake backend ↔ application session store and Account / ConstraintSet / ItineraryHistory store
- Intake backend ↔ Google token endpoint (web complete / device poll)

**Actors and privileges:**

- Unauthenticated consumer: only Google start/complete/device operations (API design table).
- Signed-in consumer: session bound to application `Account`; trip requests they own; itinerary list for that account only.
- No admin actor in Epic 1 stories. No guest actor (out of scope).

**Sensitive assets:**

- Google authorization `code`, PKCE `code_verifier`, `device_code`, application `session_token`
- Application `Account` identity (Google `sub` stored server-side per RFC; not in URLs)
- ConstraintSet trip details (dates, destination, party size, preferences) — personal data
- Itinerary history records (when Epic 4 writes them; Epic 1 reads)

**Out of scope for this review:**

- Epic 2 specialist KBs and live-web fallback
- Epic 3 budget coordination
- Epic 4 charged booking / pass-through payments (money movement is **not** an Epic 1 surface)
- Pixel UX and widget libraries
- Named persistence engine (RFC open question) — findings about “the store” are **hypothesis** until that engine exists
- Architecture not in the drafts (no invented CDN, WAF, or KMS)

## STRIDE findings

| ID | Category | Asset / component | Evidence | Impact | Mitigation (defensive) | Observed or hypothesis |
| --- | --- | --- | --- | --- | --- | --- |
| T-1 | Spoofing | Google sign-in / application session | RFC-0001 proposed OAuth Code+PKCE (web) and device grant (CLI); US-E1-01 requires Google on both surfaces; protocol was unset in `LAYER.md` | A session not bound to a Google authentication would let someone use intake and history as another account holder | Issue application session only after Google exchange succeeds; do not treat a client-supplied Google access token as the durable history key; bind history to `Account` keyed by Google `sub` (RFC proposal) | hypothesis (design only) |
| T-2 | Spoofing | `POST /v1/auth/google/web/complete` | API contract: `state` must match start; `redirect_uri` must match | Completing with a mismatched `state` or URI could attach a session to the wrong browser flow | Reject `state` / `redirect_uri` mismatch with `401` `unauthenticated`; do not create a session | observed in contract text |
| T-3 | Spoofing | Device poll | API contract: `device_code` in body; `202` while pending | A guessed or leaked `device_code` could collect a session | Treat `device_code` as secret (CLI must not print it; UX artefact); expire device codes; rate-limit poll; never log the code | observed (secret handling in contract) / hypothesis (expiry duration unset) |
| T-4 | Tampering | ConstraintSet | US-E1-03 named fields only; API `PUT` scoring-matrix closed field set | Extra fields or scores outside 1–5 would hand the Supervisor invented judgement | Schema-constrained extractor; `400` on unknown scoring fields or values outside 1–5; do not persist extra required dimensions | observed in contract |
| T-5 | Tampering | Idempotency-Key | API design: same key + different body → `409` | Replaying a key with a different prompt could overwrite another trip request | Store key with hash of body; conflict on mismatch | observed in contract |
| T-6 | Repudiation | Auth and intake | API design names audit events `auth.session_created`, `auth.session_ended`, `intake.trip_request_created`, `history.list` without secret payloads | Without audit, account isolation incidents cannot be attributed | Emit those events with application `Account` id and trip-request id only; never log tokens or Google codes | observed as proposed control; not implemented |
| T-7 | Information disclosure | History list | US-E1-07 AC2–AC3; `GET /v1/itineraries` has no `account_id` query; non-owner trip-request GET is `404` | Returning another account’s itineraries or ConstraintSet would violate the story | Object-level authz; no account-id parameter; contract tests 8–9; empty list must not include others | observed in stories + contract |
| T-8 | Information disclosure | Logs / URLs / error bodies | RFC security section; API: tokens never in query or `error.message` | Prompt text and tokens in logs or URLs leak trip personal data and credentials | No secrets in URLs; no prompt dump at info; error messages without tokens; ConstraintSet treated as personal data | observed as proposed; implementation absent |
| T-9 | Information disclosure | Google `sub` / email | Contract: `GET /v1/me` returns `id` only; no email | Email in v1 would invent a profile API and widen PII | Keep `me` as application id only until a later approved story | observed in contract |
| T-10 | Denial of service | Unauthenticated auth routes and prompt POST | API contract proposes rate and size limits | Unbounded start/poll/prompt could exhaust extractor or Google quota | Enforce documented rate limits and 8000-character prompt/turn cap; `429` / `prompt_too_large` | hypothesis (numeric caps are engineering proposals, not product SLOs) |
| T-11 | Denial of service | Extractor | RFC open question on extractor runtime | Unbounded model calls per turn | Size limits + rate limits; completeness gate so missing party size does not start Epic 2 planning (planning is out of this API) | hypothesis |
| T-12 | Elevation of privilege | Trip-request and history objects | US-E1-01 AC3; API `404` for non-owner | IDOR on `trq_…` / `itn_…` would expose another consumer’s trip | Authorize by session `Account`; never return another account’s body; no guest path | observed in stories + contract |
| T-13 | Elevation of privilege | Guest / other IdPs | US-E1-01 out of scope; LAYER NEVER guest/other social | Adding guest or a second IdP would bypass the signed-in Google gate | Do not ship unauthenticated intake or extra IdPs | observed (product rule) |

### Not applicable

- **Spoofing of specialist agents / KB:** not an Epic 1 surface (Epic 2).
- **Tampering of remaining-budget or booking charges:** Epic 3/4.
- **Elevation via merchant-of-record or admin consoles:** no such actors in evidence.
- **Money-movement STRIDE:** charged path is not this slice.

## Missing controls (defensive)

The change **does** involve authn, session, personal trip data, and a new public-facing auth API. Checklist against the **draft** (not yet code):

- [x] Authentication / session — proposed in RFC/API (Google → application session)
- [x] Authorization checks on the new path — proposed per operation; tests listed, not written
- [x] Input validation — scoring range, prompt size, closed matrix fields
- [ ] Encryption in transit (and at rest if the store holds sensitive data) — **not stated** in RFC (unset). Hypothesis: TLS for all client↔backend and backend↔Google. At-rest is blocked on persistence open question.
- [x] Audit logging of sensitive actions (no secrets in logs) — proposed event names
- [x] Rate / size limits — proposed numbers in the contract (review may change them)

Session lifetime / sign-out UX remain RFC open question 4. `DELETE /v1/session` exists as an engineering control.

## Secrets handling

No credentials appear in the repository diff under review (docs only). Examples use placeholders (`ses_example_not_a_real_secret`, `google-auth-code-example`). **Do not commit** Google client secrets. If a secret is ever committed: record location only, rotate, do not repeat the value.

## Residual risk

- Design is **Draft**. Auth protocol, session store, persistence engine, and extractor runtime are still open questions. Mitigations above are not running code.
- Google as a third-party IdP: availability and account-recovery UX are outside this product (password reset is out of scope). Residual: consumers cannot sign in if Google is unavailable — no in-product fallback IdP (by design).
- Numeric rate limits are engineering proposals, not proven capacity.
- Encryption in transit/at rest is not yet an accepted ADR.
- Failed-Google UI is unnamed in stories (UX open question); do not invent a bypass that skips Google.

This review does **not** accept residual risk on behalf of **mjbvilhena**. It does not claim the product is secure or STRIDE-compliant.
