# US-E1-05: Capture the 1–5 scoring matrix

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Drafted — awaiting named human approval (not ready for development)
**Source:** Product Owner scope add; Resolved with Product Owner — “Optimal” flight; Resolved with Product Owner — Scoring matrix capture; Core Workflows §1; Epic 1

## 1. Description

**As a** signed-in consumer,
**I want to** score named dimensions from 1 (not important) to 5 (critical) while seeing all required dimensions at the same time,
**So that** the Supervisor later has an explicit judgement matrix instead of an undefined “optimal” trip, and I can set each score in the context of the others.

## 2. Business Context

The Product Owner resolved “optimal” as: the user scores named dimensions (at least price, duration, stops) 1–5; the Supervisor uses that matrix, still bound by budget and dates. This Epic 1 story only **captures** the matrix into the constraint set. Using it during flight/lodging/concierge search is Epic 2.

**Simultaneous presentation** is a Product Owner decision by **mjbvilhena** (2026-09-20): all required dimensions must be presented together so the consumer can see their answer to each dimension in the context of the other dimensions. One-at-a-time chat that hides sibling scores is not this capture UX. On web, capture uses a **widget** (interaction pattern, not pixel specs). On CLI, capture uses a **TUI widget** with the same simultaneous multi-dimension presentation. Primary trip intake remains the chat-like natural-language prompt (US-E1-02).

## 3. Acceptance Criteria

All acceptance criteria below are **Must**.

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

### AC5 (Must): Web widget presents all required dimensions together

- **Given** a signed-in consumer on the web chat-like surface is capturing the scoring matrix
- **When** they rate the required dimensions
- **Then** all required dimensions are presented at the same time in a widget, so each score is visible in the context of the other dimensions (not one-at-a-time chat that hides sibling scores)

### AC6 (Must): CLI TUI widget presents all required dimensions together

- **Given** a signed-in consumer on the CLI chat-like surface is capturing the scoring matrix
- **When** they rate the required dimensions
- **Then** all required dimensions are presented at the same time in a TUI widget, so each score is visible in the context of the other dimensions (not one-at-a-time chat that hides sibling scores)

## 4. Technical Constraints & Out of Scope

- **Constraints:** Minimum dimensions are price, duration, and stops. Extra dimensions are unset — do not invent a longer required list. Capture UX must present all required dimensions together (web widget; CLI TUI widget). Do not invent pixel details (colors, spacing, layout measurements, or control look).
- **Out of Scope:** How the Supervisor weights flights vs lodging vs dining; applying the matrix to search results (Epic 2); inventing extra required dimensions; pixel-level UI; replacing the chat-like trip prompt (US-E1-02) with a multi-field form as primary intake.

## 5. Design & UI/UX

Web: a **widget** presents all required scoring dimensions at the same time. CLI: a **TUI widget** does the same. Interaction pattern only — no pixel specs. One-at-a-time chat that hides sibling scores is not the capture UX. Do not invent whether the widget appears before, during, or after the natural-language trip prompt; whenever scores are captured, all required dimensions are visible together.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [ ] Stakeholder acceptance: **mjbvilhena**
