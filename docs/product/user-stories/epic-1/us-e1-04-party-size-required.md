# US-E1-04: Ask when party size is missing

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Drafted — awaiting named human approval (not ready for development)
**Source:** Product Owner scope add; Resolved with Product Owner — Party size; Core Workflows §1; Epic 1

## 1. Description

**As a** signed-in consumer,
**I want** the product to ask for party size when I omit it,
**So that** planning does not start without a required constraint.

## 2. Business Context

Party size is required. If omitted, ask before planning. The canonical Tokyo example does not include party size, so this story is on the golden path, not an edge case. The specification does not split party size into adults/children.

## 3. Acceptance Criteria

### AC1: Missing party size blocks planning

- **Given** a signed-in consumer submits a trip prompt that does not include party size
- **When** the product would otherwise begin planning
- **Then** it asks for party size and does not treat the constraint set as complete

### AC2: Canonical example needs party size

- **Given** the prompt *"Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."*
- **When** party size is not in that prompt
- **Then** the product asks for party size before planning

### AC3: Provided party size is recorded

- **Given** the product has asked for party size
- **When** the consumer supplies it in the chat-like surface
- **Then** party size is included in the structured constraint set (US-E1-03)

### AC4: Party size is required

- **Given** party size is still missing
- **When** intake is evaluated
- **Then** the Supervisor does not receive a complete constraint set to plan from

## 4. Technical Constraints & Out of Scope

- **Constraints:** Asking happens in the chat-like web or CLI surface. Do not invent adult/child splits, min/max party size, or a default party of one.
- **Out of Scope:** Asking for other omitted fields (budget, dates, destination) unless the specification later says so; agent planning itself (Epic 2).

## 5. Design & UI/UX

N/A — ask in the existing chat-like surface; no pixel details.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [ ] Stakeholder acceptance: **mjbvilhena**
