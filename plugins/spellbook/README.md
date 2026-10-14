# spellbook plugin

The installable plugin behind Spellbook. Every spell in it runs under the `/spellbook:` prefix.

```text
/plugin install spellbook@spellbook
```

## Spells

### `do-a-code-review`

```text
/spellbook:do-a-code-review [pr-url | pr-number | branch]
```

A guided, evidence-based pull request review:

1. **Language.** Asks whether to communicate in English or Portuguese. Code and identifiers always stay in English.
2. **Target and workspace.** Resolves the PR or branch (from the argument, `gh pr view`, or the GitHub MCP), shows the current branch and working-tree state, and asks whether to review in the current folder or in a temporary Git worktree. It recommends a worktree when the branch differs from the target or there are uncommitted changes.
3. **Requirements.** Extracts the Jira key from the PR and reads the ticket through the `jira-ticket` MCP when available. If the ticket can't be read, it says so instead of guessing.
4. **Review.** Covers requirements coverage, frontend and backend checklists, code quality, architecture, and test coverage. It runs type checks, PHPStan, and tests after inspecting the project's real setup, and reports only errors the PR introduces.
5. **Report.** Groups findings as Critical, Important, and Suggestions, followed by Checks Performed. Each finding has a location, impact, and fix, and is marked as either a verified defect or a risk.
6. **Publish (optional).** Asks before posting to the PR and lets you edit or omit parts first. If posting isn't possible, it gives you a ready-to-paste comment instead.
7. **Clean up.** Removes only the worktree it created.

Files:

| File | Purpose |
| --- | --- |
| [`skills/do-a-code-review/SKILL.md`](skills/do-a-code-review/SKILL.md) | Workflow, safety rules, and approval gates |
| [`references/frontend-review.md`](skills/do-a-code-review/references/frontend-review.md) | React, Vue, and TypeScript checklist, and type-check guidance |
| [`references/backend-review.md`](skills/do-a-code-review/references/backend-review.md) | PHP and Laravel checklist, and PHPStan and test guidance |
| [`references/architecture-review.md`](skills/do-a-code-review/references/architecture-review.md) | Code quality, architecture, and test coverage |
| [`references/output-format.md`](skills/do-a-code-review/references/output-format.md) | Report structure and GitHub comment format |

### `jira-ticket-workflow`

```text
/spellbook:jira-ticket-workflow [ticket-id | ticket-url]
```

Plans a ticket before any code is written:

1. **Discovery.** Reads the ticket (description, acceptance criteria, comments, attachments, and related tickets), `CLAUDE.md`, `README.md`, ADRs, and the impacted code. Asks about anything that is unclear.
2. **Workspace.** Asks whether to implement in the current folder or a new Git worktree on a `feature/<TICKET-ID>-…` branch.
3. **Plan.** Presents its ticket understanding, a technical analysis, the workspace, an implementation plan, and a testing strategy, covering requirements, architecture, backend, frontend, code quality, and tests.
4. **Approval gate.** Waits for your explicit approval before writing code. Commits, pushes, PRs, and Jira updates each need their own confirmation.

### `ticket-test-report`

```text
/spellbook:ticket-test-report [ticket-id | ticket-url]
```

Runs the test plan that is already in the ticket and reports on it:

1. **Language.** Asks for English or Portuguese. Ticket text is quoted verbatim, and only its own observations are translated.
2. **Ticket.** Fetches the acceptance criteria and test plan from Jira or a linked Confluence page. If the ticket has no test plan, it asks you how to proceed instead of inventing one.
3. **Workspace.** Asks whether to test in the current folder or a temporary worktree.
4. **Execution.** Runs each case in ticket order using browser automation (Claude in Chrome), API or CLI calls, automated suites, or code review. Every case gets Passed, Failed, Blocked, or Not Tested, and Passed requires evidence. A blocked case never stops the run.
5. **Traceability.** Maps acceptance criteria to test cases and flags any criterion that no case covers.
6. **Report.** Fills [`assets/report-template.html`](skills/ticket-test-report/assets/report-template.html) and saves it to `./reports/<TICKET-ID>-test-report.html`, with screenshots in `<TICKET-ID>-evidence/`. It then summarizes in chat and asks before posting to Jira.

## Optional integrations

The spells work without any of these and report which ones were missing:

- **GitHub:** `gh` CLI (`gh auth login`) or a GitHub MCP server, for PR metadata, diffs, and posting comments.
- **Jira / Confluence:** a `jira-ticket` MCP server, or another Jira or Atlassian MCP server, for tickets, acceptance criteria, and test plans.
- **Browser:** the Claude in Chrome extension, for the UI steps in `ticket-test-report`.
- **Project tooling:** Node and your package manager for `tsc`, and Docker Compose with PHPStan and PHPUnit or Pest for Laravel. These are taken from the project under review.

## Safety

No branch switches, stashes, commits, pushes, PR or Jira comments, or worktree removals happen without your explicit confirmation. The spells never print secrets, and never report a check or test as passed when it didn't run.
