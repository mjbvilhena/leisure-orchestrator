# US-E1-07: Retrieve itinerary history

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Drafted — awaiting named human approval (not ready for development)
**Source:** Epic 1; Resolved with Product Owner — Persistence; Core Workflows §4

## 1. Description

**As a** signed-in consumer,
**I want to** retrieve past coordinated itineraries on my account,
**So that** previous trips remain available instead of disappearing after a single chat.

## 2. Business Context

Accounts and itinerary history are in MVP as part of Epic 1. Coordinated itineraries are saved to account history when produced (workflow 4 / Epic 4). This story is **retrieval**. Creating the itinerary is not this epic. Social sharing and multi-user workspaces are unmentioned and out of scope.

## 3. Acceptance Criteria

### AC1: Retrieve past coordinated itineraries

- **Given** a signed-in consumer whose account already has one or more coordinated itineraries
- **When** they retrieve itinerary history
- **Then** they can see those past coordinated itineraries

### AC2: History is per account

- **Given** two different signed-in consumers
- **When** each retrieves itinerary history
- **Then** each sees only itineraries associated with their own account

### AC3: Empty history

- **Given** a signed-in consumer with no coordinated itineraries yet
- **When** they retrieve itinerary history
- **Then** they do not receive another account’s itineraries (empty is allowed; do not invent a marketing upsell)

### AC4: Available from MVP surfaces

- **Given** a signed-in consumer on web or CLI
- **When** they retrieve itinerary history
- **Then** retrieval works on that chat-like surface (no extra channel)

## 4. Technical Constraints & Out of Scope

- **Constraints:** Persistence identity is the account from US-E1-01. Retention, search, filter, and pagination are unset — do not invent them as requirements.
- **Out of Scope:** Producing or fulfilling an itinerary (Epics 2–4); sharing; multi-user trip workspaces; editing other people’s history.

## 5. Design & UI/UX

N/A — no pixel details for a history list or search UI.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [ ] Stakeholder acceptance: **mjbvilhena**
