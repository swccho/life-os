# LifeOS Flutter Feature Structure

## Overview

Flutter app uses a feature-based architecture.

Each feature is isolated and contains its own:
- models
- repositories
- providers
- screens
- widgets

---

## Root Structure

lib/

- core/
- shared/
- features/

---

## Core

Contains:
- API client (Dio setup)
- interceptors
- auth token handler
- constants
- base utilities

---

## Shared

Reusable UI components:
- buttons
- inputs
- cards
- loaders
- empty states
- error widgets

Do not put feature-specific logic here.

---

## Features

### Auth

features/auth/

- models/
- repository/
- providers/
- screens/
- widgets/

---

### Tasks

features/tasks/

- models/task_model.dart
- repository/task_repository.dart
- providers/task_provider.dart
- screens/
  - task_list_screen.dart
  - create_task_screen.dart
- widgets/
  - task_item.dart

---

### Habits

features/habits/

- models/
  - habit_model.dart
  - habit_log_model.dart
- repository/
- providers/
- screens/
- widgets/

---

### Journal

features/journal/

- models/
- repository/
- providers/
- screens/
- widgets/

---

### Mood

features/mood/

- models/
- repository/
- providers/
- screens/
- widgets/

---

### Insights

features/insights/

- models/
- repository/
- providers/
- screens/
- widgets/

---

## Provider Rules

- one provider per feature responsibility
- avoid giant providers
- separate data fetching from UI state

---

## Repository Rules

- one repository per feature
- handles API calls
- returns typed models

---

## Screen Rules

- one main screen per feature view
- break into smaller widgets
- keep UI clean

---

## Widget Rules

- reusable within feature
- move to shared only if reused across features

---

## Naming Rules

Use clear naming:

- task_repository.dart
- habit_provider.dart
- journal_screen.dart
- mood_log_model.dart

Avoid vague names.

---

## Navigation

Use GoRouter:
- /login
- /register
- /tasks
- /habits
- /journal
- /mood
- /insights

Protect authenticated routes.

---

## Summary

This structure ensures:
- scalability
- clean separation
- maintainability

Do not mix features together.
Do not create global messy architecture.
