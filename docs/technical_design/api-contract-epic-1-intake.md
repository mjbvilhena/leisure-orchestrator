# API contract: Epic 1 intake backend

Field-level contract for the first-party intake API. Pair with [`api-design-epic-1-intake.md`](api-design-epic-1-intake.md) and RFC-0001. Pair with Definition of Done `api change`.

This contract is **Draft**. Examples are synthetic. They contain **no secrets, tokens, or personal accounts**.

## Metadata

| Field | Value |
| --- | --- |
| Surface | Leisure Orchestrator intake API `/v1` |
| Spec artifact | proposed — `docs/technical_design/openapi/intake-v1.yaml` (not yet in repo). This markdown is the checked-in contract. |
| Compatibility | Additive vs a future frozen v1. Greenfield: no version N to break. |
| Related | `docs/technical_design/rfc-0001-epic-1-intake-architecture.md`, US-E1-01–07 |

Shared request header on authenticated operations: `Authorization: Bearer <session_token>`.

Optional on mutating POSTs: `Idempotency-Key` (string, 1–64 characters, `[A-Za-z0-9_-]+`).

Optional on all: `X-Request-Id` (echoed).

Engineering size limit (proposal, not a product copy policy): `prompt` and turn `text` max **8000** Unicode characters.

Engineering rate limit (proposal, not an SLO): unauthenticated auth routes **30 requests / 60 seconds / client address**; `POST /v1/trip-requests` **20 / 60 seconds / Account**. Exceeded → `429` with `Retry-After`.

---

## Endpoints

### `POST /v1/auth/google/web/start`

- **Summary:** Begin Google Authorization Code + PKCE for the web client.
- **Authn:** none
- **Authz:** public
- **Idempotency:** not idempotent
- **Headers:** none required

#### Path/query parameters

None.

#### Request body

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `code_challenge` | string | yes | PKCE S256 challenge | Do not send `code_verifier` here |
| `redirect_uri` | string | yes | Absolute HTTPS URI registered for the web client | Must match complete |

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | start ok | `authorization_url` (string), `state` (string) |
| 400 | missing/invalid body | error envelope `invalid_request` |
| 429 | rate limited | error envelope `rate_limited` |

**Example (synthetic):**

```json
{
  "code_challenge": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk",
  "redirect_uri": "https://web.example.invalid/oauth/google/complete"
}
```

```json
{
  "authorization_url": "https://accounts.google.com/o/oauth2/v2/auth?example=synthetic",
  "state": "state_example_1"
}
```

### `POST /v1/auth/google/web/complete`

- **Summary:** Exchange Google authorization `code` for an application session and `Account`.
- **Authn:** none (Google `code` is the proof)
- **Authz:** public
- **Idempotency:** same `code` replay: second call `401` (`unauthenticated`) after Google has consumed the code — do not return a second session from a captured code
- **Headers:** none required

#### Request body

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `code` | string | yes | Google authorization code | Never log; never put in query |
| `state` | string | yes | Must match start | |
| `code_verifier` | string | yes | PKCE verifier | Never log |
| `redirect_uri` | string | yes | Same as start | |

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | session created | `session_token`, `account` (`id` only) |
| 400 | malformed | `invalid_request` |
| 401 | Google exchange failed or `state` mismatch | `unauthenticated` |
| 429 | rate limited | `rate_limited` |

**Example (synthetic):**

```json
{
  "code": "google-auth-code-example",
  "state": "state_example_1",
  "code_verifier": "pkce-verifier-example",
  "redirect_uri": "https://web.example.invalid/oauth/google/complete"
}
```

```json
{
  "session_token": "ses_example_not_a_real_secret",
  "account": {
    "id": "acc_example_1"
  }
}
```

### `POST /v1/auth/google/device/start`

- **Summary:** Begin Google device authorization for the CLI.
- **Authn:** none
- **Authz:** public
- **Idempotency:** not idempotent

#### Request body

Empty object `{}`.

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | device codes issued | `device_code`, `user_code`, `verification_url`, `interval_seconds`, `expires_in_seconds` |
| 429 | rate limited | `rate_limited` |

**Example (synthetic):**

```json
{
  "device_code": "device_code_example",
  "user_code": "ABCD-EFGH",
  "verification_url": "https://www.google.com/device",
  "interval_seconds": 5,
  "expires_in_seconds": 1800
}
```

`device_code` is a secret to the CLI process. Do not print it in the TUI. The consumer sees `user_code` and `verification_url` only.

### `POST /v1/auth/google/device/poll`

- **Summary:** Poll until Google authorization completes; then issue an application session.
- **Authn:** none
- **Authz:** public
- **Idempotency:** polling the same `device_code` is expected until 200 or expiry

#### Request body

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `device_code` | string | yes | From start | Never log |

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | session created | same as web complete |
| 202 | user has not finished Google authorization | empty body; client waits `interval_seconds` |
| 400 | unknown/expired device code | `invalid_request` |
| 401 | user denied or Google refused | `unauthenticated` |
| 429 | rate limited | `rate_limited` |

### `GET /v1/me`

- **Summary:** Return the signed-in application `Account`.
- **Authn:** application session
- **Authz:** the session’s account
- **Idempotency:** yes

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | ok | `id` |
| 401 | no/invalid session | `unauthenticated` |

**Example (synthetic):**

```json
{
  "id": "acc_example_1"
}
```

No email, Google `sub`, or name fields in v1 (unset; do not invent profile APIs).

### `DELETE /v1/session`

- **Summary:** Invalidate the application session.
- **Authn:** application session
- **Authz:** the session’s account
- **Idempotency:** yes (second DELETE is `401`)

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 204 | ended | empty |
| 401 | already invalid | `unauthenticated` |

### `POST /v1/trip-requests`

- **Summary:** Accept the natural-language trip prompt as primary intake and return a ConstraintSet (possibly incomplete).
- **Authn:** application session
- **Authz:** creates a resource owned by the session `Account`
- **Idempotency:** `Idempotency-Key` recommended

#### Request body

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `prompt` | string | yes | 1–8000 characters | Canonical Tokyo sentence is valid |

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 201 | accepted | `id`, `constraint_set` (see shared types) |
| 400 | empty/too large | `invalid_request` or `prompt_too_large` |
| 401 | no session | `unauthenticated` |
| 409 | idempotency key reuse with different body | `idempotency_conflict` |
| 429 | rate limited | `rate_limited` |

**Example (synthetic) — canonical prompt, party size missing:**

Request:

```json
{
  "prompt": "Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."
}
```

Response `201`:

```json
{
  "id": "trq_example_1",
  "constraint_set": {
    "budget": { "text": "under $3,000" },
    "dates": { "text": "4-day" },
    "destination": { "text": "Tokyo" },
    "preferences": { "text": "reservation at a high-end sushi place" },
    "party_size": null,
    "scoring_matrix": null,
    "complete": false,
    "missing": ["party_size", "scoring_matrix"]
  }
}
```

`budget` / `dates` / `destination` / `preferences` use `{ "text": "..." }` so the contract does **not** invent a currency code, calendar type, or geo identifier. Amounts stay as given (DOMAIN unset currency). Destination is not checked against a city list.

### `GET /v1/trip-requests/{id}`

- **Summary:** Return the current ConstraintSet for a trip request owned by the caller.
- **Authn:** application session
- **Authz:** owner only
- **Idempotency:** yes

#### Path/query parameters

| Name | In | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- | --- |
| `id` | path | string | yes | `trq_` prefix opaque id | |

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | owner | `id`, `constraint_set` |
| 401 | no session | `unauthenticated` |
| 404 | unknown to this account, including non-owner ids (do not confirm another account’s trip requests) | `not_found` |

Non-owner access: **`404`** with `not_found` (see design: do not confirm another account’s ids).

### `POST /v1/trip-requests/{id}/turns`

- **Summary:** Append a chat-like turn (for example the party-size answer). Re-runs extraction into the same ConstraintSet.
- **Authn:** application session
- **Authz:** owner only
- **Idempotency:** `Idempotency-Key` recommended

#### Request body

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `text` | string | yes | 1–8000 characters | Natural language; not a structured party-size form field |

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | updated | `id`, `constraint_set` |
| 400 | empty/too large | `invalid_request` / `prompt_too_large` |
| 401 | no session | `unauthenticated` |
| 404 | unknown to this account | `not_found` |
| 409 | idempotency conflict | `idempotency_conflict` |

**Example (synthetic) — party size supplied:**

```json
{
  "text": "2"
}
```

```json
{
  "id": "trq_example_1",
  "constraint_set": {
    "budget": { "text": "under $3,000" },
    "dates": { "text": "4-day" },
    "destination": { "text": "Tokyo" },
    "preferences": { "text": "reservation at a high-end sushi place" },
    "party_size": { "text": "2" },
    "scoring_matrix": null,
    "complete": false,
    "missing": ["scoring_matrix"]
  }
}
```

`party_size` is `{ "text": "..." }` so the contract does not invent adult/child splits or a numeric min/max policy (US-E1-04). The extractor may store digits-as-text.

If `text` does not yield party size, `party_size` stays `null` and `missing` still includes `party_size`. The product still must **ask** in the chat-like surface (client/UX); the API does not send pixel copy beyond ConstraintSet.

### `PUT /v1/trip-requests/{id}/scoring-matrix`

- **Summary:** Store the 1–5 matrix for **all** required dimensions in one request.
- **Authn:** application session
- **Authz:** owner only
- **Idempotency:** natural key = resource + body (PUT)

#### Request body

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `price` | integer | yes | 1–5 inclusive | 1 = not important, 5 = critical |
| `duration` | integer | yes | 1–5 inclusive | |
| `stops` | integer | yes | 1–5 inclusive | |

No other properties. Extra required dimensions are unset — do not accept unknown fields as required; unknown fields → `400` `invalid_request`.

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | stored | `id`, `constraint_set` with `scoring_matrix` filled; `complete` true if `party_size` also present |
| 400 | missing dimension or out of range | `invalid_request` |
| 401 | no session | `unauthenticated` |
| 404 | unknown to this account | `not_found` |

**Example (synthetic):**

```json
{
  "price": 5,
  "duration": 3,
  "stops": 2
}
```

```json
{
  "id": "trq_example_1",
  "constraint_set": {
    "budget": { "text": "under $3,000" },
    "dates": { "text": "4-day" },
    "destination": { "text": "Tokyo" },
    "preferences": { "text": "reservation at a high-end sushi place" },
    "party_size": { "text": "2" },
    "scoring_matrix": {
      "price": 5,
      "duration": 3,
      "stops": 2
    },
    "complete": true,
    "missing": []
  }
}
```

When `complete` is true, this is a ConstraintSet for the Supervisor — **not** an itinerary (US-E1-03 AC3). This API has no plan/book operation.

### `GET /v1/itineraries`

- **Summary:** Retrieve coordinated itineraries for the signed-in account (may be empty).
- **Authn:** application session
- **Authz:** only the session `Account` (no `account_id` parameter)
- **Idempotency:** yes

#### Path/query parameters

None in v1 (no pagination, search, or filter).

#### Responses

| Status | When | Body fields |
| --- | --- | --- |
| 200 | ok | `items` array of `{ "id": "itn_…" }` |
| 401 | no session | `unauthenticated` |

Empty history:

```json
{
  "items": []
}
```

Non-empty (synthetic; Epic 4 may additively extend item objects):

```json
{
  "items": [
    { "id": "itn_example_1" },
    { "id": "itn_example_2" }
  ]
}
```

Account A’s session must never receive Account B’s `itn_…` ids.

---

## Shared types and error envelope

### Error envelope

```json
{
  "error": {
    "code": "unauthenticated",
    "message": "An application session is required."
  }
}
```

Closed `code` set: `invalid_request`, `prompt_too_large`, `unauthenticated`, `forbidden`, `not_found`, `idempotency_conflict`, `rate_limited`. (`not_complete` is reserved for later epics; not returned by Epic 1 operations listed here.)

### `constraint_set`

| Field | Type | Required | Constraints | Notes |
| --- | --- | --- | --- | --- |
| `budget` | object or null | yes | `{ "text": string }` or null | Cap as given |
| `dates` | object or null | yes | `{ "text": string }` or null | |
| `destination` | object or null | yes | `{ "text": string }` or null | Not a city enum |
| `preferences` | object or null | yes | `{ "text": string }` or null | Prompt remainder |
| `party_size` | object or null | yes | `{ "text": string }` or null | Required for `complete` |
| `scoring_matrix` | object or null | yes | `{ "price","duration","stops": 1–5 }` or null | Required for `complete` |
| `complete` | boolean | yes | true only if party_size and scoring_matrix non-null | Supervisor-ready gate |
| `missing` | string array | yes | subset of `party_size`, `scoring_matrix`, and optionally named fields if absent | Clients tolerate unknown strings |

---

## Pagination and lists

None in v1. `GET /v1/itineraries` `items` may be empty. Max list size is “whatever is stored for the account”; no page size. A later cursor is additive.

---

## Compatibility rules

- [x] New optional fields only, or a documented `/v2` — this draft is additive-only on `/v1`
- [x] Enum additions (`missing`): tolerant readers
- [x] Field removals / type changes listed as breaking in the design doc
- [x] Default value changes: none (no defaults for party size or scores)

---

## Contract tests

Add at implement/verify (no runner in repo yet; README expects TypeScript tests when code lands):

1. Unauthenticated `POST /v1/trip-requests` → `401` `unauthenticated`.
2. Unauthenticated `GET /v1/itineraries` → `401`.
3. Canonical prompt creates a trip request with `destination.text` Tokyo, budget/dates/preferences as given, `complete` false, `missing` includes `party_size`.
4. Destination other than Tokyo is accepted (not rejected solely for not being Tokyo).
5. Turn that supplies party size sets `party_size` and still `complete` false until matrix exists.
6. `PUT` scoring-matrix with all three 1–5 values; `complete` true only with party size also present.
7. `PUT` with a missing dimension or `6` → `400`.
8. Account B `GET /v1/trip-requests/{A's id}` → `404` (never A’s body).
9. Account A `GET /v1/itineraries` does not include Account B’s `itn_…` (seed B’s records in the test; A sees `[]` or only A’s ids).
10. Idempotent `POST /v1/trip-requests` with the same key and body returns the same `id`.
11. `session_token` / `code` / `device_code` never appear in `error.message`.

These must stay frozen in CI once implemented. They do not replace the later `test_plan`.

## `api change` DoD (contract slice)

- [x] Contract checked in (this file); OpenAPI YAML still proposed
- [x] Compatibility labeled
- [x] Error model documented
- [x] Authn/z on every operation
- [x] Idempotency stated
- [x] Validation / size limits stated
- [x] Synthetic examples
- [ ] Provider/consumer tests — open work for implement/verify
- [ ] Changelog — at first ship
- [x] Domain/layer: named fields only; no API-only B2C; no extra IdP; no city allowlist; scoring is one PUT of all required dimensions
