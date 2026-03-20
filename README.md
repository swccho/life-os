# LifeOS — Backend API

REST API for the LifeOS personal productivity app: **tasks**, **habits** (with logs), **journal**, **mood**, and a **dashboard** summary. Built with **Laravel 12**, **PHP 8.2+**, and **Laravel Sanctum** (Bearer tokens).

## Requirements

- PHP 8.2+ with extensions: `mbstring`, `openssl`, `pdo`, `pdo_mysql`, `tokenizer`, `xml`, `ctype`, `json`
- [Composer](https://getcomposer.org/)
- MySQL 8.x (or compatible)

## Local setup

1. Clone the repository and install dependencies:

   ```bash
   composer install
   ```

2. Environment:

   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

3. Configure **MySQL** in `.env` (example):

   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=lifeos_db
   DB_USERNAME=root
   DB_PASSWORD=
   ```

4. Create the database, then migrate:

   ```bash
   php artisan migrate
   ```

   Optional: `php artisan db:seed` if seeders are configured.

5. Run the application:

   ```bash
   php artisan serve
   ```

   With **Laragon**, point a virtual host at the `public` directory or use `http://127.0.0.1:8000` after `artisan serve`.

## API overview

- **Base URL**: `{APP_URL}/api` (e.g. `http://127.0.0.1:8000/api`)
- **Auth**: `POST /api/register`, `POST /api/login` (no token). All other routes use `Authorization: Bearer {token}`.
- **JSON shape** (success): `{ "success": true, "message": string, "data": ... }` — paginated list responses may include `"meta"`.
- **JSON shape** (validation error): `{ "success": false, "message": string, "errors": { ... } }`.

Main route groups:

| Area | Routes |
|------|--------|
| Auth | `POST /register`, `POST /login`, `POST /logout`, `GET /me` |
| Dashboard | `GET /dashboard` |
| Tasks | `apiResource` `tasks` |
| Habits | `apiResource` `habits`; `GET/POST /habits/{id}/logs`; `DELETE /habit-logs/{id}` |
| Journal | `apiResource` `journal-entries` (query: `entry_date`, `from`, `to`) |
| Mood | `apiResource` `mood-entries` (same date filters) |

See [`routes/api.php`](routes/api.php) for the canonical list.

### Postman

Import [`postman/LifeOS.postman_collection.json`](postman/LifeOS.postman_collection.json). Set collection variable **`baseUrl`** to your app origin (no trailing slash). **Register** or **Login** saves **`accessToken`** for Bearer auth on other requests.

## Documentation

- [MVP database blueprint](docs/LifeOS_MVP_Database_Design_Blueprint.md)
- [Product documentation](docs/LifeOS_Product_Documentation.md)

## Tests

PHPUnit uses **MySQL** and a dedicated database **`lifeos_testing`** (see [`phpunit.xml`](phpunit.xml)) so migrations do not touch your dev database.

Create the database once:

```sql
CREATE DATABASE lifeos_testing;
```

Adjust `DB_*` in `phpunit.xml` if your MySQL user/password differ from the defaults.

Run:

```bash
php artisan test
```

Optional: copy [`.env.testing.example`](.env.testing.example) to `.env.testing` and set `APP_KEY` if you prefer file-based overrides.

## Code style

```bash
vendor/bin/pint
```

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
