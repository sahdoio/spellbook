# Code quality, architecture, and test coverage

Applies to every review, whatever the stack.

## Code quality

Inspect:

- **Readability and maintainability.** Clear naming, reasonable function size, and logic that is easy to follow.
- **Error handling.** Errors are handled at the right level, not swallowed, and not exposed to users in raw form.
- **Linting and formatting.** Violations of the project's configured linters and formatters. Rely on the project's tools rather than personal taste.
- **Unnecessary complexity.** Code that can be simpler without losing behavior, dead code, and duplicated logic that already exists in the codebase.
- **Inappropriate abstractions.** Interfaces with one implementation and no clear reason, premature generalization, and leaky abstractions.
- **Comments.** Excessively verbose comments, or comments that look AI-generated and restate what the code says. Prefer self-documenting code. Keep comments that explain *why*.
- **TODOs.** Every **new** TODO must reference a Jira ticket, for example:
  ```php
  // TODO GROW-1234: Handle retry logic
  ```
  Report new TODOs without a ticket reference.

Do not report subjective stylistic preferences as defects. If something is purely a preference, leave it out or mark it as an optional suggestion.

## Architecture

Evaluate:

- Separation of concerns.
- Cohesion and coupling.
- Consistency with the patterns already established in this codebase.
- Abstraction boundaries in the right places.
- Testability and dependency direction (high-level policy should not depend on low-level details).
- Pragmatic maintainability.

Apply Clean Architecture, Domain-Driven Design, or Hexagonal Architecture concepts **only when the codebase already uses them or the change clearly calls for them**. Avoid overengineering. Recommend an architectural change only when it gives a concrete benefit or fixes a demonstrated problem, and describe that benefit.

## Test coverage

Check that new functionality has meaningful tests, not just tests that execute lines. Consider:

- Positive and negative cases.
- Boundary conditions.
- Failure handling (exceptions, timeouts, external service errors).
- Authorization and validation paths.
- Concurrency, where relevant.
- Regression risks in existing behavior the change touches.

Execute new or modified tests when the environment permits. Report:

- Tests that passed.
- Tests that failed, with the relevant output.
- Command errors (for example a missing dependency or a container that is not running).
- Tests that could not run, and why.
- Important scenarios that are not covered.

Never claim a test passed unless it actually ran successfully.
