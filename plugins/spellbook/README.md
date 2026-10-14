# spellbook plugin

The installable plugin behind [Spellbook](../../README.md). Every spell runs under the `/spellbook:` prefix.

```text
/plugin install spellbook@spellbook
```

How each spell works, which stacks it covers, and which integrations it uses are documented in the [root README](../../README.md#workflows). This file maps the plugin's files.

## Files

| File | Purpose |
| --- | --- |
| [`skills/jira-ticket-workflow/SKILL.md`](skills/jira-ticket-workflow/SKILL.md) | Ticket discovery, workspace choice, plan format, and the approval gate |
| [`skills/do-a-code-review/SKILL.md`](skills/do-a-code-review/SKILL.md) | Review workflow, safety rules, and approval gates. Loads the references below on demand |
| [`skills/do-a-code-review/references/backend-review.md`](skills/do-a-code-review/references/backend-review.md) | PHP/Laravel checklist, and PHPStan/Larastan and PHPUnit/Pest guidance |
| [`skills/do-a-code-review/references/frontend-review.md`](skills/do-a-code-review/references/frontend-review.md) | React/Vue/TypeScript checklist, and `tsc`/`vue-tsc`, lint, and test guidance |
| [`skills/do-a-code-review/references/architecture-review.md`](skills/do-a-code-review/references/architecture-review.md) | Stack-agnostic code quality, architecture, and test coverage |
| [`skills/do-a-code-review/references/output-format.md`](skills/do-a-code-review/references/output-format.md) | Review structure, finding format, and GitHub comment format |
| [`skills/ticket-test-report/SKILL.md`](skills/ticket-test-report/SKILL.md) | Test-plan execution, statuses, traceability, and report generation |
| [`skills/ticket-test-report/assets/report-template.html`](skills/ticket-test-report/assets/report-template.html) | Self-contained HTML report template with English/Portuguese labels |

## Conventions

- `SKILL.md` orchestrates the workflow and keeps the safety rules and approval gates. Long checklists live in `references/`, and templates live in `assets/`.
- Stack-specific guidance goes in its own reference file, so you can add a stack without changing the workflow.
