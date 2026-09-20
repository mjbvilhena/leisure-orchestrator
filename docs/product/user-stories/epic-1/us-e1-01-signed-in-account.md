# US-E1-01: Signed-in consumer account

**Epic:** 1 — Natural-language intake of trip constraints
**Issue Type:** User Story
**Status:** Approved by **mjbvilhena** (2026-09-20, named human sign-off of the story artefact). Ready for later development gates. Not Done as shipped software.
**Source:** Core Workflows §1; Resolved with Product Owner — Persistence; Resolved with Product Owner — Google sign-in; Epic 1

## 1. Description

**As a** consumer in the travel market,
**I want to** authenticate with Google and use the product as a signed-in account holder,
**So that** my trip prompts and coordinated itineraries can belong to me and support itinerary history.

## 2. Business Context

Accounts and itinerary history are a Product Owner scope add in MVP and are part of Epic 1. **Google sign-in** (the consumer authenticates with Google on the MVP web and CLI chat-like surfaces as a way to be a signed-in account holder) is a **Product Owner decision** by **mjbvilhena** (this review session, 2026-09-20). The primary workflow starts with a signed-in consumer on web or CLI. The specification does not name additional personas.

## 3. Acceptance Criteria

All acceptance criteria below are **Must**.

### AC1: Web surface requires a signed-in consumer

- **Given** a consumer in the travel market
- **When** they use the web chat-like surface to work on a trip request
- **Then** they do so as a signed-in account holder

### AC2: CLI surface requires a signed-in consumer

- **Given** a consumer in the travel market
- **When** they use the CLI chat-like surface to work on a trip request
- **Then** they do so as a signed-in account holder

### AC3: Account is the persistence identity for history

- **Given** a signed-in consumer
- **When** the product stores or retrieves itinerary history
- **Then** that history is associated with their account (see US-E1-07)

### AC4 (Must): Google sign-in on the web surface

- **Given** a consumer in the travel market on the web chat-like surface
- **When** they authenticate with Google
- **Then** they are a signed-in account holder on that surface

### AC5 (Must): Google sign-in on the CLI surface

- **Given** a consumer in the travel market on the CLI chat-like surface
- **When** they authenticate with Google
- **Then** they are a signed-in account holder on that surface

## 4. Technical Constraints & Out of Scope

- **Constraints:** Web and CLI are both in MVP. Google sign-in is in scope as a way a consumer becomes a signed-in account holder. Do not invent other identity vendors, an authentication protocol, or UI pixels in this story.
- **Out of Scope:** Password reset, generic SSO/SAML, social login other than Google (Apple, Facebook, and other providers), multi-user trip workspaces, sharing, guest/anonymous intake, API-only access.

## 5. Design & UI/UX

N/A — the specification forbids UI pixel details. Surfaces are chat-like web and CLI.

## 6. Definition of Done

- [ ] All acceptance criteria are verified
- [ ] Behavior matches `docs/product/specification.md` (no invented capabilities)
- [ ] `DOMAIN.md` / `LAYER.md` updated if this story moved a boundary
- [x] Stakeholder acceptance: **mjbvilhena** (2026-09-20 — story-artefact approval, not implementation Done)
