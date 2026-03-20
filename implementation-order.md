# LifeOS Implementation Order

## Goal

This file defines the recommended implementation sequence for building the LifeOS MVP in a clean and safe way.

The goal is to reduce chaos, preserve architecture, and make each feature build on top of stable foundations.

---

## Phase 1 — Foundation

### Step 1. Project setup
Backend:
- initialize Laravel project
- configure environment
- configure database
- install Sanctum
- configure API structure
- set base folders and conventions

Flutter:
- initialize Flutter app
- configure Riverpod
- configure GoRouter
- configure Dio
- set feature-based folder structure
- set shared/core structure

Goal:
- clean project foundation exists on both backend and mobile

---

### Step 2. Authentication system
Backend:
- register
- login
- logout
- authenticated user endpoint
- token auth via Sanctum
- auth validation and resources

Flutter:
- login UI
- registration UI
- auth repository/provider
- auth persistence
- protected route handling
- logout flow

Goal:
- users can securely access their own app data

---

## Phase 2 — Core Daily Tracking

### Step 3. Tasks module
Backend:
- tasks migration
- model
- request validation
- policy
- resource
- controller
- routes
- task completion flow

Flutter:
- task model
- repository/provider
- task list screen
- create/edit task screen
- task item widgets
- filters if included
- loading/empty/error states

Goal:
- users can fully manage personal tasks

---

### Step 4. Habits module
Backend:
- habits migration
- habit logs migration
- models and relationships
- validation
- policy
- resource
- service for streak logic
- check-in endpoint
- routes

Flutter:
- habit models
- repository/provider
- habits list screen
- create/edit habit screen
- habit check-in UI
- streak display basics
- loading/empty/error states

Goal:
- users can track routines and consistency

---

### Step 5. Journal module
Backend:
- journal entries migration
- model
- validation
- policy
- resource
- controller
- routes

Flutter:
- journal models
- repository/provider
- journal list screen
- create/edit journal screen
- entry detail screen if needed
- loading/empty/error states

Goal:
- users can privately reflect and review entries

---

### Step 6. Mood tracking module
Backend:
- mood logs migration
- model
- validation
- policy
- resource
- controller
- routes

Flutter:
- mood models
- repository/provider
- mood log screen
- mood history screen
- create/edit mood flow
- loading/empty/error states

Goal:
- users can track emotional state over time

---

## Phase 3 — Insights & Product Polish

### Step 7. Basic insights module
Backend:
- insight aggregation logic
- service or controller summary endpoint
- secure user-based calculations
- clean response shape

Flutter:
- insights model
- insights provider
- insights/dashboard screen
- summary cards/lists
- meaningful empty/loading states

Goal:
- users can see simple meaningful summaries from real data

---

### Step 8. UI polish and shared components
Flutter:
- reusable cards
- buttons
- input fields
- empty states
- loading skeletons
- spacing cleanup
- copy refinement
- consistent hierarchy

Goal:
- app feels cohesive, calm, and premium

---

### Step 9. Seed/demo data and portfolio readiness
Backend:
- realistic factories
- demo seeders
- polished example data

Flutter:
- final UX cleanup
- screenshot-ready views
- stable demo flows

Goal:
- project is strong enough for presentation and portfolio use

---

## Phase 4 — Stability

### Step 10. Testing and cleanup
Backend:
- feature tests
- unit tests for logic-heavy services
- auth/authorization coverage
- validation coverage

Flutter:
- code cleanup
- dead code removal
- final architecture review
- optional widget/unit testing where useful

Goal:
- project is stable, cleaner, and easier to maintain

---

## Recommended Working Rule

Implement one step fully before moving to the next.

For each step:
1. backend structure
2. backend logic
3. backend validation/auth
4. backend response layer
5. Flutter data layer
6. Flutter state layer
7. Flutter UI
8. error/loading/empty states
9. polish

Do not partially implement multiple modules at once.

---

## MVP Completion Point

The MVP is considered complete after:

- foundation is stable
- auth works correctly
- tasks work
- habits work
- journal works
- mood tracking works
- basic insights work
- app UI feels polished
- data is secure
- project is portfolio-ready
