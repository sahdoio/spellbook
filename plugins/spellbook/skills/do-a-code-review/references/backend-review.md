# Backend review

Applies to PHP and Laravel code, migrations, jobs, events, API endpoints, and backend tests.

## Checklist

Inspect the changed code, and the code it interacts with, for:

- **Runtime and logic errors.** Wrong conditions, off-by-one errors, type juggling (`==` compared with `===`), null handling, and incorrect Carbon/date or timezone handling.
- **Race conditions and concurrency.** Check-then-act without locking, double submissions, non-idempotent jobs and webhooks, missing `lockForUpdate()` or atomic locks (`Cache::lock`), and jobs that may run concurrently or be retried.
- **N+1 queries and inefficient database access.** Relationships used in loops without `with()` / `load()`, queries inside loops, missing indexes on new filter or join columns, loading full models where `pluck`, `exists`, or `chunk`/`cursor` would do, and unbounded queries.
- **Validation.** Missing or weak Form Request rules, trusting client input, and mass-assignment exposure (`$fillable` / `$guarded`).
- **Authorization.** Missing policies, gates, or `authorize()` calls, broken tenant or ownership scoping, and IDOR (insecure direct object reference) on route-model binding.
- **Unhandled exceptions.** External calls without error handling, swallowed exceptions, and failures that leave partial state.
- **Security.** SQL injection (`DB::raw`, `whereRaw`, `selectRaw`, `orderByRaw` with interpolated input), XSS through unescaped `{!! !!}`, command injection, path traversal, SSRF, insecure deserialization, secrets in code or logs, and sensitive data in API responses or logs.
- **Transactions.** Multi-step writes without `DB::transaction`, transactions that are too broad or wrongly scoped, external calls or dispatched jobs inside a transaction (consider `afterCommit`), and missing rollback on failure.
- **Data consistency and backward compatibility.** Migrations that are not reversible or that lock large tables, column changes that break running code during deployment, changed API contracts, changed event or job payloads that are still queued, and nullable or default mismatches.
- **Requirements and tests.** Missing behavior from the ticket, and missing feature or unit tests for new paths.

## Static analysis (PHPStan / Larastan)

Inspect the project before running anything:

1. Find the Compose file and its location. It may be `docker-compose.yml`, `compose.yaml`, or an override, and may sit in the repository or a parent directory.
2. Find the application service name (for example `core-app`, `app`, `php`, `laravel.test`), and whether the project uses `docker compose` (v2) or `docker-compose` (v1).
3. Check the PHP and Laravel versions (`composer.json`), the PHPStan config (`phpstan.neon`, `phpstan.neon.dist`, baseline files), and any Composer scripts (for example `composer analyse`).
4. Check the container's volume mapping so the analysis runs against the code under review. This matters especially when reviewing in a worktree.

Example, only when it matches the project:

```bash
docker-compose -f ../docker-compose.yml exec core-app vendor/bin/phpstan analyse
```

Without Docker, the equivalent is `vendor/bin/phpstan analyse`. Restrict it to changed paths when the full run is slow, but keep the project config so the level and baseline apply.

### Report only new errors

- Run the analysis on the base commit and on the PR and compare the results, or rely on the project's PHPStan baseline when one is maintained.
- If you cannot establish a baseline, report errors only in changed files and say you could not confirm they are new.

## Tests

Examples, only when they match the project:

```bash
docker-compose -f ../docker-compose.yml exec core-app php artisan test --filter=TestClassName
docker-compose -f ../docker-compose.yml exec core-app vendor/bin/phpunit path/to/test/file.php
```

Equivalents: `php artisan test`, `vendor/bin/phpunit`, `vendor/bin/pest`, or Sail (`./vendor/bin/sail test`).

- Check the test environment (`phpunit.xml`, `.env.testing`, the test database) before running. Never run tests that could hit a non-test database. If the configuration is unclear, ask first.
- Run the tests the PR adds or changes, plus closely related existing tests.
