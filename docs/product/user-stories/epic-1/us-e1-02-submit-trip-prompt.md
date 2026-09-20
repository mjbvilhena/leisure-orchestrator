# US-E1-02: Submit a chat-like trip prompt

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Approved by **mjbvilhena** (2026-09-20, named human sign-off of the story artefact). Ready for later development gates. Not Done as shipped software.
**Source:** In Scope MVP; Resolved with Product Owner — Channel; Core Workflows §1; Epic 1

## 1. Description

**As a** signed-in consumer,
**I want to** submit a natural-language trip prompt on web or CLI (chat-like),
**So that** I can describe a constrained trip in one conversation instead of filling a multi-field form.

## 2. Business Context

MVP must accept a natural-language prompt with strict constraints on **web and CLI**, both chat-like. A multi-field form is not the primary intake. API-only B2C is out of scope. Completing bookings is Epic 4, not this story.

## 3. Acceptance Criteria

### AC1: Web chat-like intake

- **Given** a signed-in consumer on the web surface
- **When** they submit a natural-language trip prompt
- **Then** the product accepts that prompt as the primary intake (not a multi-field form)

### AC2: CLI chat-like intake

- **Given** a signed-in consumer on the CLI surface
- **When** they submit a natural-language trip prompt
- **Then** the product accepts that prompt as the primary intake (not a multi-field form)

### AC3: Canonical example is a valid prompt

- **Given** a signed-in consumer on web or CLI
- **When** they submit: *"Book a 4-day anniversary trip to Tokyo for under $3,000, and I need a reservation at a high-end sushi place."*
- **Then** the product accepts that text as a trip prompt (party size is still required under US-E1-04 before planning)

### AC4: Channel non-goals

- **Given** the MVP channel decision
- **When** intake is offered to the consumer
- **Then** primary intake is not a multi-field form and not API-only

## 4. Technical Constraints & Out of Scope

- **Constraints:** Both web and CLI must exist and be chat-like. Parsing into structured fields is US-E1-03.
- **Out of Scope:** Agent delegation (Epic 2), budget rebalance (Epic 3), booking/fulfillment (Epic 4), UI pixel details, inventing extra channels.

## 5. Design & UI/UX

N/A — chat-like web and CLI only; no pixel specs.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [x] Stakeholder acceptance: **mjbvilhena** (2026-09-20 — story-artefact approval, not implementation Done)
