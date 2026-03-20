# LifeOS MVP Database Design Blueprint (Step 2)

## Goal
Define the initial production-ready MVP schema before writing migrations.

This blueprint covers only:
- `users`
- `tasks`
- `habits`
- `habit_logs`
- `journal_entries`
- `mood_entries`

No extra tables are introduced in this step.

## 1) Table Schemas

### `users` (existing Laravel default)
Use the existing Laravel users table:
- `id` (bigint, PK)
- `name` (string, required)
- `email` (string, unique, required)
- `email_verified_at` (timestamp, nullable)
- `password` (string, required)
- `remember_token` (nullable)
- `created_at`, `updated_at`

### `tasks`
Purpose: user task management.

Columns:
- `id` (bigint, PK)
- `user_id` (bigint, FK -> `users.id`, required)
- `title` (string, required)
- `description` (text, nullable)
- `status` (string, required, default `pending`)
- `priority` (string, nullable)
- `due_date` (date, nullable)
- `completed_at` (timestamp, nullable)
- `created_at`, `updated_at`

Enum-like values:
- `status`: `pending`, `in_progress`, `completed`
- `priority`: `low`, `medium`, `high`

### `habits`
Purpose: repeating habit definitions.

Columns:
- `id` (bigint, PK)
- `user_id` (bigint, FK -> `users.id`, required)
- `name` (string, required)
- `description` (text, nullable)
- `frequency_type` (string, required)
- `target_count` (unsigned integer, required, default `1`)
- `is_active` (boolean, required, default `true`)
- `created_at`, `updated_at`

Enum-like values:
- `frequency_type`: `daily`, `weekly`

### `habit_logs`
Purpose: historical completion logs for habits.

Columns:
- `id` (bigint, PK)
- `habit_id` (bigint, FK -> `habits.id`, required)
- `user_id` (bigint, FK -> `users.id`, required)
- `logged_date` (date, required)
- `count` (unsigned integer, required, default `1`)
- `notes` (text, nullable)
- `created_at`, `updated_at`

### `journal_entries`
Purpose: user daily writing entries.

Columns:
- `id` (bigint, PK)
- `user_id` (bigint, FK -> `users.id`, required)
- `title` (string, nullable)
- `content` (longText, required)
- `entry_date` (date, required)
- `created_at`, `updated_at`

### `mood_entries`
Purpose: user mood tracking.

Columns:
- `id` (bigint, PK)
- `user_id` (bigint, FK -> `users.id`, required)
- `mood_score` (unsigned tiny integer, required)
- `mood_label` (string, nullable)
- `notes` (text, nullable)
- `entry_date` (date, required)
- `created_at`, `updated_at`

## 2) Relationships

- User has many Tasks (`users.id` -> `tasks.user_id`)
- User has many Habits (`users.id` -> `habits.user_id`)
- User has many HabitLogs (`users.id` -> `habit_logs.user_id`)
- User has many JournalEntries (`users.id` -> `journal_entries.user_id`)
- User has many MoodEntries (`users.id` -> `mood_entries.user_id`)
- Habit has many HabitLogs (`habits.id` -> `habit_logs.habit_id`)
- HabitLog belongs to Habit and User
- Task belongs to User
- JournalEntry belongs to User
- MoodEntry belongs to User

## 3) Foreign Keys and Deletion Behavior

Use foreign keys with `cascadeOnDelete()` for all user-owned records:
- `tasks.user_id` -> `users.id` cascade delete
- `habits.user_id` -> `users.id` cascade delete
- `habit_logs.user_id` -> `users.id` cascade delete
- `habit_logs.habit_id` -> `habits.id` cascade delete
- `journal_entries.user_id` -> `users.id` cascade delete
- `mood_entries.user_id` -> `users.id` cascade delete

This keeps data ownership strict and avoids orphans.

## 4) Required vs Nullable

Required fields:
- `tasks`: `user_id`, `title`, `status`
- `habits`: `user_id`, `name`, `frequency_type`, `target_count`, `is_active`
- `habit_logs`: `habit_id`, `user_id`, `logged_date`, `count`
- `journal_entries`: `user_id`, `content`, `entry_date`
- `mood_entries`: `user_id`, `mood_score`, `entry_date`

Nullable fields:
- `tasks`: `description`, `priority`, `due_date`, `completed_at`
- `habits`: `description`
- `habit_logs`: `notes`
- `journal_entries`: `title`
- `mood_entries`: `mood_label`, `notes`

## 5) Index Strategy (MVP)

### `tasks`
- index: (`user_id`, `status`)
- index: (`user_id`, `due_date`)

### `habits`
- index: (`user_id`, `is_active`)
- index: (`user_id`, `frequency_type`)

### `habit_logs`
- index: (`user_id`, `logged_date`)
- index: (`habit_id`, `logged_date`)
- unique (recommended): (`habit_id`, `logged_date`) for one aggregate row per habit per day

### `journal_entries`
- index: (`user_id`, `entry_date`)
- unique (optional product rule): (`user_id`, `entry_date`) for one journal entry per day

### `mood_entries`
- index: (`user_id`, `entry_date`)
- unique (recommended): (`user_id`, `entry_date`) for one mood check-in per day
- optional index: (`user_id`, `mood_score`)

## 6) Domain Constraints (App + DB Friendly)

- `tasks.status` allowed set: `pending`, `in_progress`, `completed`
- `tasks.priority` allowed set: `low`, `medium`, `high`
- `habits.frequency_type` allowed set: `daily`, `weekly`
- `habits.target_count >= 1`
- `habit_logs.count >= 1`
- `mood_entries.mood_score` must be in `1..5`
- If task status is `completed`, set `completed_at`

For MVP, enforce allowed values in request validation and optionally harden later with DB checks/enums.

## 7) Why This Design Works for MVP

- Simple, direct schema for core modules only.
- Strong user ownership with explicit foreign keys.
- Practical indexes for expected list/filter/calendar queries.
- No premature complexity (no tags, reminders, analytics tables, attachments).
- Scales cleanly into next steps (migrations, models, API resources, and policies).

## 8) Step 3 Input Checklist

Use this document as the source of truth when generating migrations:
- create table fields and nullability exactly as defined
- add FKs with cascade deletes
- add indexes listed above
- add defaults (`status`, `target_count`, `is_active`, `count`)
- implement unique constraints where chosen by product rule
