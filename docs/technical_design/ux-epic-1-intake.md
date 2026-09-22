# UX design: Epic 1 chat-like intake (web and CLI)

Structured UX artefact from approved Epic 1 stories. Pixel details are forbidden by the specification. This is interaction structure, flows, and copy sourced from those stories — not a visual mock.

**Status:** Draft. Not an agreed UX artefact and not technical-design approval. `sdlc-a11y-auditor` is verify-time; this document does not claim WCAG conformance.

## Metadata

| Field | Value |
| --- | --- |
| Slice / epic | Epic 1 — Natural-language intake of trip constraints |
| Stories / AC cited | `docs/product/user-stories/epic-1/us-e1-01-signed-in-account.md` through `us-e1-07-itinerary-history.md` (opened) |
| Related spec | `docs/product/specification.md` (Epic 1; Core Workflows §1, §4; Resolved with Product Owner — Channel, Google sign-in, Party size, Scoring matrix capture, Persistence) |
| Related design | `docs/technical_design/rfc-0001-epic-1-intake-architecture.md` (Draft); `docs/technical_design/api-design-epic-1-intake.md` (Draft) |
| Status | Draft |
| Skip? | no |

## Evidence

- Stories and Must AC: US-E1-01 AC1–AC5; US-E1-02 AC1–AC4; US-E1-03 AC1–AC4; US-E1-04 AC1–AC4; US-E1-05 AC1–AC6; US-E1-06 AC1–AC4; US-E1-07 AC1–AC4. Index: `docs/product/user-stories/epic-1/README.md`.
- Product spec claims used: consumers in the travel market; web + CLI chat-like; not a multi-field form as primary intake; not API-only; Google sign-in; party size required and ask if missing; scoring 1–5 on at least price, duration, stops, presented together (web widget; CLI TUI widget); any destination the tools can reach; itinerary history per account; empty history allowed; no marketing upsell. Canonical prompt quoted from the specification.
- Existing UX artefact: none.
- Domain / layer: `get_domain_consultant` (`leisure orchestrator` → travel `DOMAIN.md`); `get_layer_consultant` (`orchestration` and `leisure orchestrator` → `LAYER.md`). UI/frontend layer name is **not** in the consultant catalog. MUST/NEVER used: chat-like web+CLI; Google only; widget is not primary intake; pixel/library unset; no guest intake; no extra channels.
- `ui change` DoD: treat as **open work** at implement/verify (keyboard, accessible names, empty/error states that are in scope). Not permission to invent screens. No accessibility certification claims here.

If a control is required by an AC but unnamed in the stories, it is an **open question**, not a product claim.

## Flows

Do not add onboarding, settings, marketing, password reset, or sharing. Those stories do not exist.

| Flow | Actor | Trigger | Success path | Unhappy path (only if stories imply it) | AC mapping |
| --- | --- | --- | --- | --- | --- |
| A. Become a signed-in account holder (web) | Consumer in the travel market | Uses the web chat-like surface | 1. Surface requires a signed-in account holder. 2. Consumer authenticates with Google. 3. They are a signed-in account holder on web. | n/a — stories do not specify a failed-Google UI | US-E1-01 AC1, AC4 |
| B. Become a signed-in account holder (CLI) | Consumer in the travel market | Uses the CLI chat-like surface | Same as A on CLI (Google authenticate → signed-in). | n/a — failed-Google UI not in stories | US-E1-01 AC2, AC5 |
| C. Submit a chat-like trip prompt (web) | Signed-in consumer | Submits natural-language trip prompt | 1. Product accepts the prompt as primary intake (not a multi-field form). 2. Canonical Tokyo sentence is a valid prompt. | n/a — invalid-prompt copy not in stories | US-E1-02 AC1, AC3, AC4 |
| D. Submit a chat-like trip prompt (CLI) | Signed-in consumer | Submits natural-language trip prompt | Same as C on CLI. | n/a | US-E1-02 AC2, AC3, AC4 |
| E. Structured constraints | Signed-in consumer | Intake completes (prompt + later required fields) | Machine-usable ConstraintSet with named fields; canonical mapping after party size and matrix; result is constraints, not an itinerary or booking; matrix included. | n/a for consumer-facing error; incomplete set is the US-E1-04 path | US-E1-03 AC1–AC4 |
| F. Ask when party size is missing | Signed-in consumer | Submits a prompt without party size (including canonical example) | 1. Product asks for party size in the chat-like surface. 2. Does not treat the set as complete. 3. Does not hand a complete set to the Supervisor. 4. When the consumer supplies party size in chat, it is recorded. | n/a — default party of one is forbidden, not shown | US-E1-04 AC1–AC4 |
| G. Capture scoring matrix (web widget) | Signed-in consumer | Providing preference scores | Rates at least price, duration, stops; each 1 (not important) to 5 (critical); all required dimensions visible together in a widget (not one-at-a-time chat that hides sibling scores); matrix stored for Supervisor. | n/a — out-of-range copy not in stories (API may reject; UX pixels unset) | US-E1-05 AC1–AC5 |
| H. Capture scoring matrix (CLI TUI widget) | Signed-in consumer | Providing preference scores | Same simultaneous TUI widget presentation. | n/a | US-E1-05 AC1–AC4, AC6 |
| I. Any destination | Signed-in consumer | Names Tokyo or another destination | Tokyo accepted; other destinations not rejected solely for not being Tokyo; recorded as a constraint; no destination-picker as primary intake. | n/a — unreachable-destination UX is Epic 2/3, not these stories | US-E1-06 AC1–AC4; US-E1-02 (destination from prompt) |
| J. Retrieve itinerary history | Signed-in consumer on web or CLI | Retrieves itinerary history | Sees past coordinated itineraries for **their** account; empty is allowed and does not show another account’s itineraries; no extra channel. | Empty history (named): do not invent a marketing upsell | US-E1-07 AC1–AC4; US-E1-01 AC3 |

**Open in flows (not resolved here):**

- When the scoring widget appears relative to the prompt (US-E1-05: do not invent before/during/after).
- How the consumer **starts** history retrieval (chat turn vs unnamed control). AC requires that retrieval works on the same chat-like surface, not a new channel.

## Wireframes

Screens the stories require: **web chat-like surface** and **CLI chat-like surface**. Google authentication happens **on those surfaces**. Scoring is a **widget / TUI widget on those surfaces**, not a replacement for chat intake. History is retrieved **on those surfaces**. No destination-picker screen. No multi-field trip form. No settings. No pixel measurements.

`out of scope:` booking/fulfillment UI (Epic 4); agent assignment (Epic 2); budget rebalance UI (Epic 3); social login other than Google; guest mode; sharing; adult/child party widgets; extra scoring dimensions; loading spinners (not named).

### Web — not yet a signed-in account holder

US-E1-01 AC1, AC4. Control needed to “authenticate with Google”; exact chrome is unset.

```text
+--------------------------------------------------+
| Web chat-like surface                            |
|                                                  |
|  [ Authenticate with Google ]                    |
|                                                  |
|  Trip prompt compose: not available until        |
|  the consumer is a signed-in account holder      |
+--------------------------------------------------+
```

### Web — signed-in chat-like intake

US-E1-02, US-E1-06. Primary intake is the transcript + prompt, not a form of budget/dates/destination fields.

```text
+--------------------------------------------------+
| Web chat-like surface (signed-in account holder) |
|                                                  |
|  transcript                                      |
|   consumer: (natural-language trip prompt)       |
|   product:  (only messages the stories require;  |
|             see party-size ask)                  |
|                                                  |
|  compose: [ natural-language trip prompt ...... ]|
|           [ submit prompt ]                      |
|                                                  |
|  scoring widget: see next frame (placement TBD)  |
|  history: see history frames (trigger TBD)       |
+--------------------------------------------------+
```

Submit control is unnamed in stories; a way to submit the prompt is required for AC. Open question on label (working copy below from “submit a natural-language trip prompt”).

### Web — party size missing (canonical path)

US-E1-04. Ask **in the chat-like surface**. Exact sentence is an open question; structure is a product message in the transcript, then the consumer replies in compose (not a party-size form as primary intake).

```text
+--------------------------------------------------+
| transcript                                       |
|  consumer: Book a 4-day anniversary trip to      |
|            Tokyo for under $3,000, and I need    |
|            a reservation at a high-end sushi     |
|            place.                                |
|  product:  (ask for party size — copy TBD)       |
| compose:   [ reply in chat .................... ]|
+--------------------------------------------------+
```

Do not show a default party of one. Do not show adult/child splitters.

### Web — scoring widget (simultaneous dimensions)

US-E1-05 AC5. Same web surface. **All** required dimensions visible together. Not one-at-a-time chat that hides sibling scores. Not the primary trip intake. Pixel layout, colors, control look, and widget library: unset. ASCII is not a layout spec.

```text
+--------------------------------------------------+
| Scoring widget (web)                             |
|  price    [ 1 2 3 4 5 ]   1 not important        |
|  duration [ 1 2 3 4 5 ]   5 critical             |
|  stops    [ 1 2 3 4 5 ]                          |
|  (all three rows visible at the same time)       |
+--------------------------------------------------+
```

How the scores are committed to the backend (live vs unnamed confirm control): open question. The API contract requires one request with all three dimensions.

### Web — itinerary history (empty)

US-E1-07 AC3, AC4. Empty allowed. Do **not** add marketing upsell. Trigger/navigation unnamed.

```text
+--------------------------------------------------+
| Itinerary history (on the web chat-like surface) |
|  (empty — no other account’s itineraries)        |
+--------------------------------------------------+
```

### Web — itinerary history (has records)

US-E1-07 AC1, AC2. Consumer sees **their** past coordinated itineraries. List chrome, titles, and itinerary body layout are unset (Epic 4 produces the itinerary). Epic 1 only requires that they can see those records and not another account’s.

```text
+--------------------------------------------------+
| Itinerary history (on the web chat-like surface) |
|  - (coordinated itinerary belonging to account)  |
|  - (coordinated itinerary belonging to account)  |
+--------------------------------------------------+
```

### CLI — not yet signed in

US-E1-01 AC2, AC5. Device-style Google authentication is an RFC proposal; this wireframe only requires that the consumer authenticates with Google on the CLI surface.

```text
+--------------------------------------------------+
| CLI chat-like surface                            |
|  Authenticate with Google (CLI)                  |
|  (TUI shows the Google authentication step;      |
|   trip prompt not accepted until signed in)      |
+--------------------------------------------------+
```

CLI may show a `user_code` / verification URL if RFC-0001 device grant is accepted. That string is **not** product marketing copy; it is the OAuth device display. Exact TUI library unset.

### CLI — signed-in chat-like intake

US-E1-02 AC2. Same behaviors as web: transcript + natural-language compose. Not a multi-field form.

```text
+--------------------------------------------------+
| CLI chat-like TUI (signed-in)                    |
|  transcript (prompt and product asks)            |
|  compose: natural-language trip prompt           |
+--------------------------------------------------+
```

### CLI — scoring TUI widget

US-E1-05 AC6. All required dimensions visible together.

```text
+--------------------------------------------------+
| Scoring TUI widget                               |
|  price    1 2 3 4 5     (all visible together)   |
|  duration 1 2 3 4 5                              |
|  stops    1 2 3 4 5                              |
|  1 = not important; 5 = critical                 |
+--------------------------------------------------+
```

### CLI — itinerary history

US-E1-07 AC4. Same rules as web: empty allowed; own account only; no extra channel.

```text
+--------------------------------------------------+
| CLI: itinerary history on this chat-like surface |
|  (empty)  OR  (this account’s itineraries)       |
+--------------------------------------------------+
```

## Copy

Working strings use story/spec words. Exact party-size ask and unnamed control labels are **open questions** — do not treat them as Product Owner-approved microcopy.

| Screen | Element | Copy | Source (story / spec / existing UI) |
| --- | --- | --- | --- |
| Web / CLI not signed in | Sign-in control | Authenticate with Google | US-E1-01 (“authenticate with Google”) |
| Web / CLI signed in | Prompt compose (description) | (no placeholder marketing; consumer types the trip prompt) | US-E1-02 |
| Web / CLI | Canonical example the product must accept | Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place. | specification canonical example; US-E1-02 AC3 |
| Web / CLI | Party-size ask | **Open question** — stories say the product “asks for party size”; they do not give the sentence | US-E1-04 |
| Scoring widget / TUI | Dimension labels | price; duration; stops | US-E1-05 AC1; specification |
| Scoring widget / TUI | Scale meaning | 1 (not important) to 5 (critical) | US-E1-05 AC2 |
| History empty | Empty state | **Open question** — empty is allowed; do not invent a marketing upsell. Do not show another account’s itineraries. | US-E1-07 AC3 |
| History non-empty | List | **Open question** — how an itinerary is titled/shown; Epic 4 owns itinerary content | US-E1-07 AC1 |
| Any surface | Guest / Skip / Continue without Google | `out of scope` | US-E1-01 out of scope |
| Any surface | Destination picker / budget form fields as primary | `out of scope` | US-E1-02 AC4; US-E1-06 |

## Open questions

1. **Scoring widget placement** relative to the natural-language prompt (before / during / after) — **Product Owner**. US-E1-05 forbids inventing this. Blocks a single linear prototype; does not block the simultaneous-presentation rule.
2. **How the consumer starts itinerary history retrieval** on the chat-like surface (chat turn vs unnamed control) — **Product Owner**. US-E1-07 requires retrieval on web and CLI, not an extra channel.
3. **Exact party-size ask sentence** — **Product Owner**. Stories require an ask, not a specific string.
4. **Empty-history sentence** (without upsell) — **Product Owner**.
5. **Prompt submit control label** and **scoring commit control** (if any) — **Product Owner / UX follow-up**. Required to operate AC; unnamed.
6. **Failed Google authentication** UI — not in stories. Do not invent retry marketing. Engineering may use the API `unauthenticated` path without a new product screen until the Product Owner answers.
7. **CLI device `user_code` presentation** — depends on RFC-0001 acceptance. Not a new product channel.

## Relationship

- **Upstream:** approved Epic 1 stories; product spec.
- **Parallel:** RFC-0001 and intake API design/contract (Draft). Clients call that API; this artefact does not change field names.
- **Front door:** `sdlc-conductor` Job B should index this path. Sibling design-band drafts (still **Draft**): [`test-plan-epic-1-intake.md`](test-plan-epic-1-intake.md), [`e2e-test-plan-epic-1-intake.md`](e2e-test-plan-epic-1-intake.md), [`threat-model-epic-1-intake.md`](threat-model-epic-1-intake.md). Technical design still needs named human approval before implement.
- **Verify-time only:** `sdlc-a11y-auditor`.

## `ui change` DoD (design-time note)

Gaps for implement/verify, not extra screens: keyboard operation of chat compose, Google sign-in control, scoring widget (custom widget risk: must not be mouse-only); accessible names for 1–5 dimension controls; empty history state in scope; copy from this artefact / Product Owner answers — no invented claims; no color-only meaning for the 1–5 scale (scale is numeric + words already in the story). Do not claim legal accessibility compliance here.
