# LifeOS

LifeOS is a **full-stack productivity app** that keeps tasks, habits, journaling, and mood check-ins in one place. The goal is a calm, focused experience: see what matters on a dashboard, drill into each area when you need to, and sync everything through a single REST API.

This repository contains:

- **Backend** — Laravel 12 API with Sanctum authentication, MySQL persistence, and PHPUnit feature tests.
- **Mobile client** — Flutter app in [`life_os_app/`](life_os_app/) (Android-focused; see Flutter docs for other targets).

Screenshots of the mobile UI are in [Screenshots](#screenshots) below.

---

## What the product includes

| Area | What you get |
|------|----------------|
| **Dashboard** | Aggregated snapshot (tasks, habits, journal activity, mood). |
| **Tasks** | Create, list, complete, due dates, priorities; detail view. |
| **Habits** | Recurring habits, daily logs, streak-style feedback in the UI. |
| **Journal** | Dated entries; optional mood context from the journal flow. |
| **Mood** | Daily check-ins and history. |
| **Profile** | User profile, settings, and related screens in the app. |

The API exposes matching resources under `/api` (tasks, habits, habit logs, journal entries, mood entries, dashboard, profile). See [`routes/api.php`](routes/api.php) for the full route map.

---

## Repository layout

| Path | Role |
|------|------|
| [`app/`](app/) | Laravel domain: models, HTTP controllers, policies. |
| [`routes/api.php`](routes/api.php) | Public and authenticated API routes. |
| [`database/migrations/`](database/migrations/) | Schema for users, tasks, habits, logs, journal, mood, tokens, etc. |
| [`database/seeders/`](database/seeders/) | `DummyDataSeeder` — demo users and sample data (`php artisan db:seed`). |
| [`life_os_app/`](life_os_app/) | Flutter application (Riverpod, GoRouter, Dio). |
| [`docs/`](docs/) | Product and database design notes. |
| [`postman/`](postman/) | Postman collection for manual API testing. |

---

**Backend stack:** PHP 8.2+, Laravel 12, MySQL.

## Flutter app

- From the repo root: `cd life_os_app`
- Install dependencies: `flutter pub get`
- Run on a device or emulator: `flutter run`
- Point the app at your API base URL (must include the `/api` prefix where your client expects it) in [`life_os_app/lib/app/config/app_config.dart`](life_os_app/lib/app/config/app_config.dart)
- Release builds: `flutter build apk` or `flutter build appbundle`

## Screenshots

### Authentication

Sign in and create an account.

![LifeOS login screen](.github/screenshots/Login.jpeg)

![LifeOS register screen](.github/screenshots/Register.jpeg)

### Dashboard

Home overview and quick access to modules.

![LifeOS dashboard](.github/screenshots/Dashboard.jpeg)

### Tasks

Task list, create flow, and task details.

![LifeOS tasks list](.github/screenshots/Tasks.jpeg)

![LifeOS new task screen](.github/screenshots/New-Task.jpeg)

![LifeOS task details](.github/screenshots/Task-details.jpeg)

### Habits

Habit list, create flow, and habit details.

![LifeOS habits list](.github/screenshots/Habits.jpeg)

![LifeOS new habit screen](.github/screenshots/New-Habit.jpeg)

![LifeOS habit details](.github/screenshots/Habit-details.jpeg)

### Journal

Journal home and entries.

![LifeOS journal](.github/screenshots/Journal.jpeg)

### Profile

Profile and edit profile.

![LifeOS profile](.github/screenshots/Profile.jpeg)

![LifeOS edit profile](.github/screenshots/Edit-Profile.jpeg)

## Backend setup

1. `composer install`
2. Copy `.env.example` to `.env` and run `php artisan key:generate`
3. Configure MySQL in `.env` (`DB_DATABASE`, `DB_USERNAME`, etc.) and create the database
4. `php artisan migrate`
5. Optional sample data: `php artisan db:seed` (see **Demo accounts** below)
6. Run the API: `php artisan serve` or serve the `public` directory through Laragon (or your stack)

### Demo accounts (after `db:seed`)

Seeded by [`DummyDataSeeder`](database/seeders/DummyDataSeeder.php):

- `demo@lifeos.test` / `password` — primary demo dataset (tasks, habits, journal, mood).
- `alex@lifeos.test` / `password` — second user for multi-account checks.

A Sanctum token for the demo user is printed once when you run the seeder (useful for Postman or curl).

## API

- **Base path:** `/api` — example production: `https://life.os.thethemeai.com/api`; local: e.g. `http://127.0.0.1:8000/api`
- **Auth:** `POST /api/register`, `POST /api/login` — other routes use `Authorization: Bearer {token}`
- **Responses:** `success`, `message`, `data` (paginated lists may include `meta`)
- **Validation errors:** `success`, `message`, `errors`

**Postman:** [`postman/LifeOS.postman_collection.json`](postman/LifeOS.postman_collection.json) — set `baseUrl`; Register/Login can store `accessToken`.

## Project docs

- [MVP database blueprint](docs/LifeOS_MVP_Database_Design_Blueprint.md)
- [Product documentation](docs/LifeOS_Product_Documentation.md)

## Tests

PHPUnit uses MySQL database **`lifeos_testing`** (see [`phpunit.xml`](phpunit.xml)). Create it: `CREATE DATABASE lifeos_testing;` — adjust credentials in `phpunit.xml` if needed. Then:

```bash
php artisan test
```

Optional: copy [`.env.testing.example`](.env.testing.example) to `.env.testing` if you use env-based test configuration.
