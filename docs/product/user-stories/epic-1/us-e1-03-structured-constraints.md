# US-E1-03: Structured constraints for the Supervisor

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Approved by **mjbvilhena** (2026-09-20, named human sign-off of the story artefact). Ready for later development gates. Not Done as shipped software.
**Source:** Epic 1; In Scope MVP; Core Workflows §1

## 1. Description

**As a** signed-in consumer,
**I want** my trip prompt turned into structured, machine-usable constraints,
**So that** the Supervisor can later plan from budget, dates, destination, preferences, party size, and the scoring matrix — not from leftover chat prose.

## 2. Business Context

Epic 1 is done only when the system has a structured constraint set for the Supervisor. This story covers extracting the fields the specification names. Capturing party size when missing is US-E1-04. Capturing the 1–5 matrix is US-E1-05. Applying those constraints through specialist agents is Epic 2.

## 3. Acceptance Criteria

### AC1: Named fields become structured when present

- **Given** a signed-in consumer has submitted a natural-language trip prompt that includes budget, dates, destination, preferences, and party size
- **When** intake completes
- **Then** the product holds a machine-usable constraint set containing those fields for the Supervisor

### AC2: Canonical example fields

- **Given** the prompt *"Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."* plus a party size from US-E1-04 and a scoring matrix from US-E1-05
- **When** intake completes
- **Then** the structured set includes a duration of 4 days, destination Tokyo, a budget cap of $3,000, and the dining preference for a high-end sushi reservation

### AC3: Output is constraints, not an itinerary

- **Given** structured constraints have been produced
- **When** this story is satisfied
- **Then** the result is a constraint set for the Supervisor, not a finalized itinerary and not a booking

### AC4: Scoring matrix is part of the set

- **Given** the consumer has provided the 1–5 scoring matrix (US-E1-05)
- **When** the constraint set is assembled
- **Then** that matrix is included with budget, dates, destination, preferences, and party size

## 4. Technical Constraints & Out of Scope

- **Constraints:** Do not invent a schema, serialization format, or extra required fields. Currency is unset beyond the canonical `$` example.
- **Out of Scope:** Supervisor delegation, specialist search, remaining-budget math, fulfillment, inventing preference taxonomies beyond prompt text plus the named scoring dimensions.

## 5. Design & UI/UX

N/A — no pixel details. Structured output is for the Supervisor, not a consumer form.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [x] Stakeholder acceptance: **mjbvilhena** (2026-09-20 — story-artefact approval, not implementation Done)
