# LifeOS Database Schema Plan

## Overview

This document defines the core database structure for the LifeOS MVP.

All data is user-owned and must be properly related and secured.

---

## Users Table

Default Laravel users table (extended if needed)

Fields:
- id
- name
- email (unique)
- password
- created_at
- updated_at

---

## Tasks Table

Fields:
- id
- user_id (foreign key)
- title
- description (nullable)
- due_date (nullable)
- priority (string or enum: low, medium, high)
- is_completed (boolean, default false)
- completed_at (nullable)
- created_at
- updated_at

Indexes:
- user_id
- due_date

Relationships:
- belongsTo user

---

## Habits Table

Fields:
- id
- user_id (foreign key)
- name
- description (nullable)
- created_at
- updated_at

Indexes:
- user_id

Relationships:
- belongsTo user
- hasMany habit_logs

---

## Habit Logs Table

Tracks daily habit completion

Fields:
- id
- habit_id (foreign key)
- user_id (foreign key)
- completed_on (date)
- created_at

Constraints:
- unique (habit_id, completed_on)

Indexes:
- habit_id
- user_id
- completed_on

Relationships:
- belongsTo habit
- belongsTo user

---

## Journal Entries Table

Fields:
- id
- user_id (foreign key)
- title (nullable)
- content (text)
- entry_date (date)
- created_at
- updated_at

Indexes:
- user_id
- entry_date

Relationships:
- belongsTo user

---

## Mood Logs Table

Fields:
- id
- user_id (foreign key)
- mood_value (string or enum)
- note (nullable)
- logged_on (date)
- created_at
- updated_at

Indexes:
- user_id
- logged_on

Relationships:
- belongsTo user

---

## Insights (Derived Data)

Insights are NOT stored initially.

They are computed dynamically from:
- tasks
- habits + habit_logs
- journal_entries
- mood_logs

Later optimization (optional):
- cache insights in a table if needed

---

## Enum Suggestions

### Task Priority
- low
- medium
- high

### Mood Values
- very_bad
- bad
- neutral
- good
- great

---

## Data Ownership Rule

Every table must enforce:
- user_id ownership
- no cross-user access

---

## Future Tables (Post-MVP)

Do NOT implement now:

- notifications
- reminders
- attachments
- teams/workspaces
- AI insights cache
- activity logs

---

## Migration Rules

- use foreign key constraints
- cascade delete where appropriate
- keep schema explicit
- avoid nullable unless necessary
- avoid JSON columns unless justified

---

## Summary

This schema is:
- simple
- scalable
- clean
- aligned with MVP scope

Do not overcomplicate it.
