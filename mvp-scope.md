# LifeOS MVP Scope

## Goal of the MVP

Build the first production-style version of LifeOS with the core systems users need to manage daily life.

The MVP must be focused, clean, and complete.
It should solve the main problem well before adding advanced features.

---

## Included in MVP

## 1. Authentication
Users can:
- register
- log in
- log out
- fetch authenticated profile
- stay authenticated securely using token-based auth

Backend includes:
- Sanctum auth
- protected routes
- auth validation
- consistent auth responses

Frontend includes:
- login screen
- registration screen
- auth persistence
- protected routing
- logout flow

---

## 2. Task Management
Users can:
- create tasks
- list tasks
- view a task
- update tasks
- delete tasks
- mark tasks as completed
- optionally set due date
- optionally set priority

Suggested task fields:
- id
- user_id
- title
- description nullable
- due_date nullable
- priority enum or string
- is_completed boolean
- completed_at nullable
- created_at
- updated_at

MVP task filters may include:
- status
- priority

---

## 3. Habit Tracking
Users can:
- create habits
- list habits
- update habits
- delete habits
- check in / complete a habit for a day
- see current streak/basic consistency data

Suggested habit fields:
- id
- user_id
- name
- description nullable
- frequency or type
- created_at
- updated_at

Suggested habit log fields:
- id
- habit_id
- user_id
- completed_on
- created_at

MVP habit features:
- one completion per habit per day
- streak calculation
- consistency-friendly UX

---

## 4. Journal
Users can:
- create journal entries
- list entries
- view a single entry
- update entry
- delete entry

Suggested fields:
- id
- user_id
- title nullable
- content
- entry_date
- created_at
- updated_at

Journal data must remain private and secure.

---

## 5. Mood Tracking
Users can:
- log mood
- list mood logs
- update mood log
- delete mood log
- optionally attach note

Suggested fields:
- id
- user_id
- mood_value
- note nullable
- logged_on
- created_at
- updated_at

Mood values may be:
- very_bad
- bad
- neutral
- good
- great

Keep this simple in MVP.

---

## 6. Basic Insights
Users can see simple but meaningful insight summaries based on their own tracked data.

Examples:
- total tasks completed this week
- incomplete task count
- current active habit streaks
- number of journal entries this week
- mood trend summary for recent days
- simple productivity summary

Insights should come from real data.
Do not generate fake analytics.

---

## 7. Basic Profile Endpoint
Users can fetch their own profile data.

This may include:
- id
- name
- email
- created_at

This keeps the app grounded for auth and account flow.

---

## Excluded from MVP

The following should be excluded until after MVP:

- social features
- team/workspace support
- notifications system
- advanced AI insights
- file attachments
- calendar integrations
- reminders
- analytics dashboards with heavy chart complexity
- theme customization
- offline-first sync engine
- gamification system
- achievements/badges
- public sharing
- admin panel
- multi-device collaborative features

---

## MVP Quality Standard

The MVP is complete only when each included feature has:

### Backend
- proper migration
- model relationships
- validation
- authorization
- clean controllers
- service logic where needed
- API resources
- routes
- secure ownership protection

### Flutter
- typed models
- repository integration
- Riverpod state
- route integration
- clean UI
- loading state
- empty state
- error state
- user-friendly forms

---

## MVP Success Criteria

The MVP is successful when a user can:

- sign up and log in
- manage daily tasks
- track daily habits
- write journal entries
- log mood regularly
- review simple personal insight summaries

and the app feels:

- clean
- modern
- calm
- stable
- production-ready

---

## MVP Principle

Do fewer things, but do them properly.

LifeOS MVP should feel complete, not bloated.
