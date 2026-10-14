# Frontend review

Applies to React, Vue, TypeScript, JavaScript, and related frontend code and tests.

## Checklist

Inspect the changed code, and the code it interacts with, for:

- **Runtime failures.** Logical and syntax errors that can crash at runtime, such as wrong conditionals, unreachable branches, bad comparisons, or misspelled properties.
- **Async race conditions.** Out-of-order responses overwriting newer state, state updates after unmount, effects that do not cancel or ignore stale requests (`AbortController`, ignore flags), and duplicate submissions.
- **Uncaught promise rejections.** Missing `catch` or `try/catch` around `await`, fire-and-forget promises, and errors that are silently swallowed.
- **Null and undefined handling.** Missing checks on API data, optional props, route params, `find()` results, and DOM refs. Look for optional chaining that hides a real bug.
- **Props.** Incorrect prop types, missing required props, mismatched TypeScript interfaces, and Vue `props` definitions that do not match usage.
- **Memory leaks.** Timers, intervals, subscriptions, observers, and event listeners without cleanup (`useEffect` return, `onUnmounted` / `onBeforeUnmount`).
- **Hook dependency arrays.** Missing dependencies (stale closures), unstable dependencies that cause loops or refetches, and suppressed `react-hooks/exhaustive-deps` warnings without a justification. For Vue, check `watch` sources, `immediate`/`deep` options, and computed side effects.
- **State synchronization.** Duplicated or derived state that can drift, local state that should come from the server or store, and optimistic updates without a rollback.
- **API integration.** Request and response shapes that do not match the backend contract, missing error and loading states, wrong HTTP methods or status handling, and pagination or filtering bugs.
- **Requirements and regressions.** Behavior the ticket asked for that is missing, and existing behavior the change can break.
- **Tests.** Missing or weak tests for new behavior, and regression tests for fixed bugs.

## Type checking

1. Find the package manager from the lockfile: `yarn.lock` for Yarn, `package-lock.json` for npm, `pnpm-lock.yaml` for pnpm, and `bun.lockb` or `bun.lock` for Bun. Check the `packageManager` field in `package.json`.
2. Check `package.json` scripts for an existing type-check script (for example `type-check`, `typecheck`, or `tsc`) and prefer it. Check `tsconfig*.json` for project references. These may need `tsc -b` or a specific `-p` path.
3. Typical command when Yarn and a root `tsconfig.json` are used:
   ```bash
   yarn tsc --noEmit
   ```
   Equivalents: `npx tsc --noEmit`, `pnpm exec tsc --noEmit`, or the project script. Vue projects often use `vue-tsc --noEmit`.
4. If dependencies are not installed (common in a fresh worktree), tell the user before installing. Use the lockfile-respecting command (`yarn install --frozen-lockfile` or `yarn install --immutable`, `npm ci`, `pnpm install --frozen-lockfile`).

### Report only new errors

- Run the same check on the base commit and on the PR, then compare the error lists by file and message. Line numbers may shift.
- If you cannot run the baseline, list errors only in files the PR touched, and say clearly that you could not confirm they are new.
- Never describe an error as introduced by the PR without that evidence.

## Linting and tests

- Run the project's lint script on the changed files when one exists (for example `yarn lint`, `eslint <files>`). Report only issues in changed lines unless an existing issue matters to the change.
- Run the test files the PR adds or changes with the project's runner (Jest, Vitest, Cypress component tests, and so on). Use its filtering options rather than the full suite when the suite is slow.
