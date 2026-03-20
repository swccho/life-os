# LifeOS — Backend API

REST API for LifeOS: tasks, habits (with daily logs), journal entries, mood entries, and an aggregated dashboard. Uses Laravel Sanctum (Bearer tokens).

**Stack:** PHP 8.2+, Laravel 12, MySQL.

## Setup

1. `composer install`
2. `cp .env.example .env` and `php artisan key:generate`
3. Set MySQL in `.env` (`DB_DATABASE`, `DB_USERNAME`, etc.) and create that database
4. `php artisan migrate` (optional: `php artisan db:seed`)
5. `php artisan serve` — or serve the `public` directory via Laragon

## API

- Base path: `/api` (e.g. `http://127.0.0.1:8000/api`)
- Register / login: `POST /api/register`, `POST /api/login` — other routes need `Authorization: Bearer {token}`
- Success body: `success`, `message`, `data` (lists may include `meta` for pagination)
- Validation errors: `success`, `message`, `errors`

Routes: [`routes/api.php`](routes/api.php)

**Postman:** [`postman/LifeOS.postman_collection.json`](postman/LifeOS.postman_collection.json) — set `baseUrl`; Register/Login store `accessToken`.

## Project docs

- [MVP database blueprint](docs/LifeOS_MVP_Database_Design_Blueprint.md)
- [Product documentation](docs/LifeOS_Product_Documentation.md)

## Tests

PHPUnit targets MySQL database **`lifeos_testing`** (see [`phpunit.xml`](phpunit.xml)). Create it: `CREATE DATABASE lifeos_testing;` — adjust credentials in `phpunit.xml` if needed. Then `php artisan test`. Optional: [`.env.testing.example`](.env.testing.example) → `.env.testing`.
