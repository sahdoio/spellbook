# Contributing

Spellbook is a personal toolkit, but changes still go through the same checks.

## Workflow

1. Create a branch.
2. Make your change.
3. Run `./scripts/validate.sh`, which needs `node` and, for the official checks, the `claude` CLI.
4. Try the plugin locally: `claude --plugin-dir ./plugins/spellbook`. Run `/reload-plugins` after each edit.
5. Update `CHANGELOG.md` and open a PR. CI runs the same validation script.

## Add a spell (skill) to the spellbook plugin

1. Create `plugins/spellbook/skills/<spell-name>/SKILL.md`. Use a kebab-case directory name. It becomes the command `/spellbook:<spell-name>`.
2. Start the file with frontmatter:
   ```markdown
   ---
   name: <spell-name>
   description: What it does and when to use it. Put the key use case first.
   ---
   ```
   Other optional fields include `argument-hint` and `disable-model-invocation: true` (use it for spells that should run only when you type the command). See the [skills docs](https://code.claude.com/docs/en/skills).
3. Keep `SKILL.md` as the orchestrator and under about 500 lines. Move long checklists into `references/*.md` next to it, and link them with relative links that tell Claude when to read each one. Put deterministic helpers in `scripts/` and refer to them as `${CLAUDE_PLUGIN_ROOT}/skills/<spell-name>/scripts/...`.
4. Keep safety rules and approval gates in `SKILL.md` itself, not only in references.
5. Add the spell to the tables in `README.md` and `plugins/spellbook/README.md`.

## Add a separate plugin

Do this only when a group of spells needs to be installed or versioned on its own. Its commands use its own prefix (`/<name>:`), not `/spellbook:`.

1. Create `plugins/<name>/.claude-plugin/plugin.json` with at least `name` (kebab-case) and `version`.
2. Add `plugins/<name>/skills/...` and a `README.md`.
3. Register it in `.claude-plugin/marketplace.json`:
   ```json
   { "name": "<name>", "source": "./plugins/<name>", "description": "..." }
   ```
   The entry `name` must equal the `name` in `plugin.json`. Write `source` relative to the repository root, starting with `./`.
4. Run `./scripts/validate.sh`. It discovers every directory under `plugins/` automatically.

Don't add MCP servers, agents, or hooks without a concrete need.

## Releasing

Users receive a change only when the plugin's `version` changes.

1. Bump `version` in `plugins/spellbook/.claude-plugin/plugin.json`, using semver. Set it only there, not in `marketplace.json`.
2. Add a `CHANGELOG.md` entry.
3. Merge to `main`. Optionally tag the release with `claude plugin tag plugins/spellbook`.
4. Users run `/plugin marketplace update spellbook`, then `claude plugin update spellbook@spellbook`, or let auto-update pick it up.

## Rules

- Never commit credentials, `.env` files, or machine-specific paths.
- Don't rename the plugin or marketplace without a `renames` entry in `marketplace.json`, because renaming breaks existing installs.
