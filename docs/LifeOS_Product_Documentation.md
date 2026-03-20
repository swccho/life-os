# 📱 LifeOS — Full Stack Product Documentation

---

# 📌 1. Overview

**LifeOS** is a full-stack personal life management platform that helps users track, organize, and improve their daily life.

It combines multiple systems into one unified app:

- Task Management
- Habit Tracking
- Journaling
- Mood Tracking
- Productivity Insights

---

# 🎯 2. Vision

> Help users become more consistent, mindful, and productive through structured daily tracking and meaningful insights.

LifeOS is not just a productivity app.  
It is a **life intelligence system**.

---

# 🧱 3. System Architecture

```text
Flutter Mobile App (Client)
        ↓
REST API (Laravel Backend)
        ↓
MySQL Database
```

---

# 🛠️ 4. Tech Stack

## Backend

- Laravel 12
- PHP 8.3
- MySQL
- Laravel Sanctum (auth)
- Laravel Queues (future)
- Redis (optional)

## Mobile (Frontend)

- Flutter
- Riverpod (state management)
- GoRouter (navigation)
- Dio (API client)
- Flutter Secure Storage (token)
- fl_chart (analytics)

---

# 🔐 5. Authentication System

## Approach

Token-based authentication using **Laravel Sanctum**

## Flow

1. User registers/logs in
2. Backend returns token
3. Flutter stores token securely
4. Every API request includes:

```http
Authorization: Bearer {token}
```

---

# 🧩 6. Core Features (Modules)

---

## 6.1 Dashboard (Today Screen)

### Backend:

- Aggregated endpoint

### Frontend:

- Main entry screen

### Features:

- Today’s tasks
- Today’s habits
- Mood check-in
- Latest journal entry
- Daily progress

---

## 6.2 Tasks Module

### Backend:

- CRUD API
- Filtering logic

### Frontend:

- Task list UI
- Create/edit screens

### Features:

- Create/update/delete
- Mark complete
- Priority
- Due date
- Filters (today/upcoming/completed)

---

## 6.3 Habits Module

### Backend:

- Habit logs
- Streak logic

### Frontend:

- Habit tracker UI
- Daily toggle

### Features:

- Daily habits
- Completion tracking
- Streak system
- History

---

## 6.4 Journal Module

### Backend:

- Daily entries

### Frontend:

- Writing interface

### Features:

- Daily journal
- Edit entries
- Attach mood

---

## 6.5 Mood Module

### Backend:

- Daily mood records

### Frontend:

- Simple selection UI (emoji/scale)

### Features:

- Log mood
- View history

---

## 6.6 Insights Module

### Backend:

- Aggregation logic

### Frontend:

- Charts & analytics UI

### Features:

- Weekly stats
- Productivity trends
- Habit consistency
- Mood patterns
- Life score

---

# 🗄️ 7. Database Design

---

## Users

- id
- name
- email
- password
- timestamps

---

## Tasks

- id
- user_id
- title
- description
- due_date
- priority
- is_completed
- timestamps

---

## Habits

- id
- user_id
- name
- timestamps

---

## Habit Logs

- id
- habit_id
- date
- is_completed

---

## Journals

- id
- user_id
- content
- mood
- date

---

## Moods

- id
- user_id
- value (1–5)
- date

---

# 🔗 8. API Design

---

## Base URL

```
/api/v1
```

---

## Auth

```
POST /register
POST /login
POST /logout
GET  /me
```

---

## Tasks

```
GET    /tasks
POST   /tasks
PUT    /tasks/{id}
DELETE /tasks/{id}
PATCH  /tasks/{id}/complete
```

---

## Habits

```
GET  /habits
POST /habits
POST /habits/{id}/complete
GET  /habits/{id}/logs
```

---

## Journal

```
GET  /journals
POST /journals
PUT  /journals/{id}
```

---

## Mood

```
GET  /moods
POST /moods
```

---

## Dashboard

```
GET /dashboard
```

---

## Insights

```
GET /insights/weekly
```

---

# 🧠 9. Business Logic

---

## Habit Streak

- Count consecutive days
- Reset on missed day

---

## Daily Reset

- New day → fresh habit state
- Tasks filtered per day

---

## Life Score

```
score =
  (tasks_completed * 0.4) +
  (habits_completed * 0.4) +
  (journal_written * 0.2)
```

---

# 🧱 10. Backend Architecture

---

## Structure

```text
app/
  Http/
    Controllers/Api/V1/
    Requests/
    Resources/
  Models/
  Services/
  Policies/
  Enums/
routes/
  api_v1.php
```

---

## Rules

- Controllers = thin
- Business logic = Services
- Validation = Form Requests
- Responses = API Resources
- Always scope by user_id

---

# 📱 11. Flutter Architecture

---

## Structure

```text
lib/
  core/
    api/
    config/
    services/
  features/
    auth/
    dashboard/
    tasks/
    habits/
    journal/
    mood/
    insights/
  shared/
    widgets/
    models/
```

---

## State Management

- Riverpod only
- Feature-scoped providers
- No global mutable state

---

## API Layer

- Dio client
- Interceptors for token
- Centralized error handling

---

# 🔌 12. Data Flow

---

## Example: Fetch Tasks

1. Flutter calls API via Dio
2. Token attached automatically
3. Laravel validates request
4. Data returned via Resource
5. Flutter updates state

---

# 🎨 13. UI Design System

---

## Style

- Minimal
- Calm
- Clean

## Components

- Cards
- Lists
- Bottom sheets
- Floating actions

## Guidelines

- 8pt spacing system
- Rounded corners (12–16)
- Soft shadows
- Limited color palette

---

# 🎬 14. UX Principles

- Fast interactions
- Minimal input steps
- Clear feedback
- Smooth transitions
- Daily-first experience

---

# ⚙️ 15. Development Rules

---

## Backend

- No logic in controllers
- Use services
- Use enums for constants
- Clean API structure

---

## Frontend

- No API calls inside UI widgets
- Use providers/services
- Reusable components only

---

# 🧪 16. Testing

---

## Backend

- Feature tests (auth, tasks, habits)

## Frontend

- API integration testing
- Basic UI testing

---

# 🚀 17. Implementation Phases

---

## Phase 1

- Backend foundation + auth

## Phase 2

- Tasks + Habits API

## Phase 3

- Journal + Mood API

## Phase 4

- Dashboard + Insights

## Phase 5

- Flutter app setup

## Phase 6

- Feature integration

---

# 🔮 18. Future Enhancements

- Push notifications
- Offline sync
- AI insights
- Web dashboard
- Social sharing
- Goal tracking

---

# 💥 19. Portfolio Impact

LifeOS demonstrates:

- Full-stack architecture
- Mobile + API integration
- Clean system design
- Product thinking
- Real-world usability

---

# ✅ Final Statement

LifeOS is not a demo app.

👉 It is a **production-style full-stack product**

If executed properly, it will:

- stand out strongly in your portfolio
- be usable in real life
- evolve into a SaaS product
