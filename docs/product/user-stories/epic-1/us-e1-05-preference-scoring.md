# US-E1-05: Capture the 1–5 scoring matrix

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Ready for development (story only; no application delivery in this change)
**Source:** Product Owner scope add; Resolved with Product Owner — “Optimal” flight; Core Workflows §1; Epic 1

## 1. Description

**As a** signed-in consumer,
**I want to** score named dimensions from 1 (not important) to 5 (critical),
**So that** the Supervisor later has an explicit judgement matrix instead of an undefined “optimal” trip.

## 2. Business Context

The Product Owner resolved “optimal” as: the user scores named dimensions (at least price, duration, stops) 1–5; the Supervisor uses that matrix, still bound by budget and dates. This Epic 1 story only **captures** the matrix into the constraint set. Using it during flight/lodging/concierge search is Epic 2.

## 3. Acceptance Criteria

### AC1: Required named dimensions

- **Given** a signed-in consumer is submitting trip constraints
- **When** they provide preference scores
- **Then** they rate at least **price**, **duration**, and **stops**

### AC2: Scale is 1–5 with stated meaning

- **Given** a named dimension
- **When** the consumer scores it
- **Then** the score is from 1 (not important) to 5 (critical)

### AC3: Matrix is stored for the Supervisor

- **Given** the consumer has scored the required dimensions
- **When** the structured constraint set is assembled
- **Then** the 1–5 matrix is included for the Supervisor (US-E1-03)

### AC4: Bound by budget and dates (recorded, not applied here)

- **Given** the scoring matrix
- **When** it is handed to later epics
- **Then** it is judgement only; it does not replace the budget cap or dates (application of that bound is not this story)

## 4. Technical Constraints & Out of Scope

- **Constraints:** Minimum dimensions are price, duration, and stops. Extra dimensions are unset — do not invent a longer required list.
- **Out of Scope:** How the Supervisor weights flights vs lodging vs dining; UI widgets; applying the matrix to search results (Epic 2).

## 5. Design & UI/UX

N/A — capture scores in the chat-like web or CLI surface; no pixel details. Whether scores are in the first prompt or a follow-up turn is unset.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [ ] Stakeholder acceptance: **mjbvilhena**
