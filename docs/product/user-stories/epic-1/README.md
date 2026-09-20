# Epic 1 user stories

**Epic:** Natural-language intake of trip constraints
**Source:** `docs/product/specification.md` (Epic 1; Core Workflows §1; Resolved with Product Owner)
**Backlog:** Task 1.1 *(In progress)* — files drafted, awaiting named human approval (**mjbvilhena**); drafted or merged files are not approval. Task 1.2 *(Not done)* until the outcome ships in an application

## Outcome this epic must enable

A signed-in consumer can submit a trip prompt on web or CLI (chat-like), retrieve past coordinated itineraries, and the system has a structured, machine-usable set of constraints (budget, dates, destination, preferences, required party size, 1–5 scoring matrix) for the Supervisor.

## Stories

| ID | File | Title |
| --- | --- | --- |
| US-E1-01 | [`us-e1-01-signed-in-account.md`](us-e1-01-signed-in-account.md) | Signed-in consumer account (Google sign-in in scope) |
| US-E1-02 | [`us-e1-02-submit-trip-prompt.md`](us-e1-02-submit-trip-prompt.md) | Submit a chat-like trip prompt |
| US-E1-03 | [`us-e1-03-structured-constraints.md`](us-e1-03-structured-constraints.md) | Structured constraints for the Supervisor |
| US-E1-04 | [`us-e1-04-party-size-required.md`](us-e1-04-party-size-required.md) | Ask when party size is missing |
| US-E1-05 | [`us-e1-05-preference-scoring.md`](us-e1-05-preference-scoring.md) | Capture the 1–5 scoring matrix |
| US-E1-06 | [`us-e1-06-any-destination.md`](us-e1-06-any-destination.md) | Any destination the tools can reach |
| US-E1-07 | [`us-e1-07-itinerary-history.md`](us-e1-07-itinerary-history.md) | Retrieve itinerary history |

## Not this epic

Do not extend these stories into Epics 2–4:

- Completing bookings or choosing fulfillment (Epic 4)
- Spawning or assigning Supervisor / specialist agents (Epic 2)
- Remaining-budget handoff, rebalance, or fail-closed overflow (Epic 3)
- UI pixel details
- Social features, sharing, or multi-user trip workspaces (unmentioned in the specification)
- Social login other than Google; generic SSO/SAML; password-reset flows; guest/anonymous intake
