<p align="center">
  <img src="assets/logo.svg" alt="Spellbook: a spellbook of powerful skills, plugins, and workflows for AI coding agents" width="640">
</p>

Spellbook is a personal [Claude Code plugin marketplace](https://code.claude.com/docs/en/plugins/create-marketplace). Install it once and its spells (skills) work in every project and session, versioned and distributed from this repository instead of being copied into each one.

The vocabulary:

- **Spellbook**: this toolkit, which is both a marketplace and a plugin.
- **Spell**: one skill or workflow, such as `do-a-code-review`.
- **Plugin**: an installable package of spells. Everything ships in the `spellbook` plugin, so every spell runs as `/spellbook:<spell>`.

Spellbook currently targets the Claude Code CLI. The layout leaves room for other AI coding agents later.

## Features

| Spell | Command | What it does |
| --- | --- | --- |
| `do-a-code-review` | `/spellbook:do-a-code-review` | Guided, evidence-based PR review: Jira requirements coverage, frontend (React, Vue, TypeScript) and backend (PHP, Laravel) checklists, architecture, static analysis, tests, and opt-in GitHub publishing. |
| `jira-ticket-workflow` | `/spellbook:jira-ticket-workflow` | Analyzes a Jira ticket, the codebase, and the project docs, then proposes an implementation plan and waits for your approval before writing any code. |
| `ticket-test-report` | `/spellbook:ticket-test-report` | Runs the test plan defined in a Jira ticket (browser, API, test suites, code review), maps the results to acceptance criteria, and writes a self-contained HTML report. |

Details for each spell are in the [plugin README](plugins/spellbook/README.md).

## Repository structure

```text
spellbook/
├── .claude-plugin/marketplace.json     # Marketplace catalog
├── plugins/
│   └── spellbook/                      # The plugin; its name is the /spellbook: prefix
│       ├── .claude-plugin/plugin.json  # Plugin manifest (name, version)
│       ├── skills/
│       │   ├── do-a-code-review/
│       │   │   ├── SKILL.md            # Workflow orchestrator
│       │   │   └── references/         # Checklists and output format, loaded on demand
│       │   ├── jira-ticket-workflow/
│       │   │   └── SKILL.md
│       │   └── ticket-test-report/
│       │       ├── SKILL.md
│       │       └── assets/report-template.html
│       └── README.md
├── assets/logo.svg                     # README logo
├── scripts/validate.sh                 # Local and CI validation
└── .github/workflows/validate.yml      # CI
```

## Prerequisites

- [Claude Code](https://code.claude.com/docs/en/overview), installed and signed in.
- `git`.
- Read access to `sahdoio/spellbook`. While the repository is private, your machine needs GitHub credentials that work without prompting: an SSH key loaded in `ssh-agent`, or HTTPS credentials stored with `gh auth login && gh auth setup-git`.

## Installation

Inside a Claude Code session:

```text
/plugin marketplace add sahdoio/spellbook
/plugin install spellbook@spellbook
```

Or from your shell:

```bash
claude plugin marketplace add sahdoio/spellbook
claude plugin install spellbook@spellbook
```

The install id is `<plugin>@<marketplace>`, and both names are `spellbook`. The default scope is **user**, which means the plugin is available in every project on this machine. Pass `--scope project` to share it through a repository's `.claude/settings.json`, or `--scope local` for one repository only.

Restart Claude Code or run `/reload-plugins` to load it.

## Usage

```text
/spellbook:do-a-code-review
/spellbook:do-a-code-review https://github.com/acme/app/pull/123
/spellbook:do-a-code-review feature/GROW-1234-retry-logic
/spellbook:jira-ticket-workflow GROW-1234
/spellbook:ticket-test-report https://acme.atlassian.net/browse/GROW-1234
```

Claude can also pick a spell automatically when your request matches it, for example "review this PR" or "test ticket GROW-1234". Plugin skills are always namespaced by the plugin name, so the `/spellbook:` prefix is the reliable form.

## Managing the installation

| Task | Command |
| --- | --- |
| List installed plugins | `claude plugin list`, or the **Installed** tab in `/plugin` |
| Show components and context cost | `claude plugin details spellbook` |
| Refresh the catalog | `/plugin marketplace update spellbook` |
| Update the plugin | `claude plugin update spellbook@spellbook`, then restart |
| Turn on auto-update | `/plugin` → **Marketplaces** → `spellbook` → **Enable auto-update** |
| Disable or enable without uninstalling | `claude plugin disable spellbook@spellbook` / `claude plugin enable spellbook@spellbook` |
| Uninstall the plugin | `claude plugin uninstall spellbook@spellbook` |
| Remove the marketplace (also uninstalls its plugins) | `claude plugin marketplace remove spellbook` |

Updates arrive only when `version` in `plugins/spellbook/.claude-plugin/plugin.json` changes. See [CONTRIBUTING.md](CONTRIBUTING.md#releasing).

## Troubleshooting

- **`marketplace add` fails on a private repository.** Claude Code runs `git` without prompts. Check that `git ls-remote git@github.com:sahdoio/spellbook.git` works in your shell. If you have no SSH key, set `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` and store HTTPS credentials with `gh auth login && gh auth setup-git`.
- **`Plugin "x" not found in marketplace`.** Use the exact id `spellbook@spellbook`, then run `/plugin marketplace update spellbook`.
- **The skill doesn't show up after install.** Restart the session or run `/reload-plugins`. Check the **Errors** tab in `/plugin` and the output of `claude plugin list`.
- **You pushed changes but don't see them.** Bump `version` in `plugin.json`, then update the marketplace and the plugin.
- **The review reports a missing tool.** Jira, GitHub, Docker, and so on are configured outside the plugin. See [Security considerations](#security-considerations).

## Local validation

```bash
./scripts/validate.sh        # or: npm run validate
```

The script checks:

- JSON syntax.
- Required files.
- That every plugin source resolves to a directory, and that each plugin's `plugin.json` name matches its marketplace entry.
- Skill frontmatter (`name`, `description`).
- Relative Markdown links inside each plugin.

It also runs the official `claude plugin validate --strict` on the marketplace and on every plugin. CI (`.github/workflows/validate.yml`) runs the same script on pull requests and on pushes to `main`. No secrets are needed.

To try the plugin without installing it:

```bash
claude --plugin-dir ./plugins/spellbook
```

## Adding spells and plugins

- **New spell (the usual case):** add `plugins/spellbook/skills/<spell-name>/SKILL.md`. It runs as `/spellbook:<spell-name>`.
- **Separate plugin (only if it needs to be installed on its own):** add `plugins/<name>/` with its own `.claude-plugin/plugin.json` and an entry in `marketplace.json`. Its spells run as `/<name>:<spell>`, not `/spellbook:`.

Step-by-step instructions are in [CONTRIBUTING.md](CONTRIBUTING.md).

## Security considerations

- Installing the plugin does **not** configure Jira MCP, GitHub MCP, Claude in Chrome, GitHub CLI authentication, Docker, PHPStan, project dependencies, environment variables, or repository-specific settings. The review skill detects what is available and reports what is missing. It never assumes something worked.
- The spells treat code, PR text, Jira content, web pages, and tool output as untrusted, and ignore embedded instructions.
- Externally visible actions, such as posting PR or Jira comments, require your explicit approval in the conversation. The spells never switch branches, stash, or remove worktrees they did not create without asking, and `jira-ticket-workflow` writes no code before you approve its plan.
- `ticket-test-report` writes reports to `./reports/` in the project under review. They can contain internal URLs and screenshots, so consider adding `reports/` to that project's `.gitignore`.
- The repository contains no credentials. `.gitignore` excludes `.env*` and key files.
- Plugins run with your user privileges. Review changes to this repository before you update.

## Current limitations

- The `ticket-test-report` browser steps need the Claude in Chrome extension. Without it, UI cases are reported as Blocked.
- Claude Code only. Other agents are not supported yet.
- The repository is private, so installing it needs GitHub access on each machine. Making it public is a separate decision and is not covered here.
- The review checklists focus on React, Vue, TypeScript, PHP, and Laravel. Other stacks get the general review only.
- Cloud sessions (claude.ai/code) don't load plugins from your local settings.

## License

[MIT](LICENSE)
