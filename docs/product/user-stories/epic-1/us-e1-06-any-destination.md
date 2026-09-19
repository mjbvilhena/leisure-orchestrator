# US-E1-06: Any destination the tools can reach

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Ready for development (story only; no application delivery in this change)
**Source:** Product Owner scope add; Resolved with Product Owner — Destination coverage; Epic 1

## 1. Description

**As a** signed-in consumer,
**I want to** name any destination the curated tools (plus web fallback) can reach,
**So that** Tokyo remains the golden-path example without locking the product to one city.

## 2. Business Context

Destination coverage is a Product Owner add: any destination the tools can reach. Tokyo is the example, not a lock. Whether a destination is actually reachable is a property of the curated tools and web fallback (Epic 2), not a hard-coded city list in intake.

## 3. Acceptance Criteria

### AC1: Tokyo is accepted as the golden-path example

- **Given** a signed-in consumer
- **When** they name Tokyo as the destination (canonical example)
- **Then** intake accepts Tokyo as a destination constraint

### AC2: Intake is not locked to Tokyo

- **Given** a signed-in consumer
- **When** they name a destination other than Tokyo
- **Then** intake does not reject it solely because it is not Tokyo

### AC3: Coverage rule is tool reach, not a city allowlist in Epic 1

- **Given** destination coverage as resolved with the Product Owner
- **When** a destination is submitted at intake
- **Then** the destination is recorded as a constraint for the Supervisor; Epic 1 does not introduce a product-owned list of permitted cities

### AC4: Destination is part of the structured set

- **Given** a destination in the prompt or a later chat turn
- **When** the constraint set is assembled
- **Then** destination is included with the other Epic 1 fields (US-E1-03)

## 4. Technical Constraints & Out of Scope

- **Constraints:** “Tools can reach” includes curated allowlist first and live web only if the allowlist has no hit (data-source rule). Do not invent a destination catalog here.
- **Out of Scope:** Specialist search (Epic 2); what to return when tools cannot reach a destination (unset beyond later fail-closed workflow in Epic 3); visa/geo policy.

## 5. Design & UI/UX

N/A — destination comes from the chat-like prompt; no destination-picker pixel specs.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [ ] Stakeholder acceptance: **mjbvilhena**
