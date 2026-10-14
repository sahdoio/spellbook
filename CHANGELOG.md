# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-10-14

### Added

- `spellbook` marketplace and `spellbook` plugin.
- `do-a-code-review` spell (`/spellbook:do-a-code-review`): guided PR review with language selection, an optional temporary worktree, Jira requirements coverage, frontend, backend, and architecture checklists, static analysis and tests that report only new errors, severity-ordered output, and opt-in GitHub publishing.
- `jira-ticket-workflow` spell (`/spellbook:jira-ticket-workflow`): ticket and codebase analysis, a workspace choice, and an implementation plan behind an explicit approval gate.
- `ticket-test-report` spell (`/spellbook:ticket-test-report`): runs a ticket's test plan, builds an acceptance-criteria traceability matrix, and writes a self-contained HTML report (EN/PT).
- `scripts/validate.sh` and GitHub Actions validation.
