#!/usr/bin/env bash
# Validate the Spellbook marketplace. Used locally and in CI.
# Requires: node. Uses the `claude` CLI for official validation when available
# (set REQUIRE_CLAUDE=1 to fail if it is missing, as CI does).
set -uo pipefail

cd "$(dirname "$0")/.."
fail=0
err() { echo "✘ $*" >&2; fail=1; }
ok() { echo "✔ $*"; }

# 1. Required repository files.
for f in .claude-plugin/marketplace.json README.md LICENSE CONTRIBUTING.md CHANGELOG.md; do
  [[ -f "$f" ]] || err "Missing required file: $f"
done

# 2-5. JSON syntax, plugin sources, skill frontmatter, internal links.
node - <<'EOF' || fail=1
const fs = require("fs"), path = require("path");
let failed = false;
const err = (m) => { console.error(`✘ ${m}`); failed = true; };
const readJson = (f) => {
  try { return JSON.parse(fs.readFileSync(f, "utf8")); }
  catch (e) { err(`${f}: invalid JSON (${e.message})`); return null; }
};

const market = readJson(".claude-plugin/marketplace.json");
for (const p of market?.plugins ?? []) {
  if (typeof p.source !== "string") continue; // remote sources are checked at install time
  const dir = path.normalize(p.source);
  if (!fs.existsSync(dir) || !fs.statSync(dir).isDirectory()) {
    err(`plugin "${p.name}": source ${p.source} is not a directory`);
    continue;
  }
  const manifest = readJson(path.join(dir, ".claude-plugin/plugin.json"));
  if (manifest && manifest.name !== p.name)
    err(`plugin "${p.name}": plugin.json name "${manifest.name}" differs from marketplace entry`);

  const skillsDir = path.join(dir, "skills");
  const skills = fs.existsSync(skillsDir) ? fs.readdirSync(skillsDir) : [];
  for (const s of skills) {
    const skillFile = path.join(skillsDir, s, "SKILL.md");
    if (!fs.existsSync(skillFile)) { err(`${path.join(skillsDir, s)}: missing SKILL.md`); continue; }
    const fm = fs.readFileSync(skillFile, "utf8").match(/^---\n([\s\S]*?)\n---\n/);
    if (!fm) { err(`${skillFile}: missing YAML frontmatter`); continue; }
    for (const key of ["name", "description"])
      if (!new RegExp(`^${key}:\\s*\\S`, "m").test(fm[1])) err(`${skillFile}: frontmatter missing "${key}"`);
  }

  // Every relative Markdown link inside the plugin must resolve.
  const walk = (d) => fs.readdirSync(d, { withFileTypes: true }).flatMap((e) =>
    e.isDirectory() ? walk(path.join(d, e.name)) : e.name.endsWith(".md") ? [path.join(d, e.name)] : []);
  for (const md of walk(dir)) {
    const text = fs.readFileSync(md, "utf8").replace(/```[\s\S]*?```/g, "");
    for (const [, target] of text.matchAll(/\]\(([^)\s]+)\)/g)) {
      if (/^(https?:|mailto:|#|<)/.test(target)) continue;
      const resolved = path.join(path.dirname(md), target.split("#")[0]);
      if (!fs.existsSync(resolved)) err(`${md}: broken link "${target}"`);
    }
  }
}
if (!failed) console.log("✔ Structure, plugin sources, skill frontmatter, and internal links");
process.exit(failed ? 1 : 0);
EOF

# 6. Official Claude Code validation.
if command -v claude >/dev/null 2>&1; then
  claude plugin validate --strict . || fail=1
  for dir in plugins/*/; do
    claude plugin validate --strict "$dir" || fail=1
  done
elif [[ "${REQUIRE_CLAUDE:-0}" == 1 ]]; then
  err "claude CLI not found; install it with: npm install -g @anthropic-ai/claude-code"
else
  echo "⚠ claude CLI not found; skipped official validation. Run: claude plugin validate --strict ."
fi

if (( fail )); then echo "Validation failed." >&2; exit 1; fi
ok "All checks passed"
