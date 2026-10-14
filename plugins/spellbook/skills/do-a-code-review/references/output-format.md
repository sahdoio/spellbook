# Review output format

Write the review in the language the user chose. Keep code, identifiers, commands, and Jira keys in English.

## Structure

```markdown
## Code Review: <PR title or branch> (<PR link or number>)

**Summary:** <2–4 sentences: what the PR does, overall assessment, and the most important issues.>

### 1. Critical Issues
<Findings that must be fixed before merge: bugs that break behavior, security vulnerabilities, data loss or corruption, missing core requirements. "None found." if empty.>

### 2. Important Issues
<Findings that should be fixed: likely bugs, missing validation or tests on important paths, meaningful performance regressions, partial requirements. "None found." if empty.>

### 3. Suggestions
<Optional improvements: readability, simplification, minor test gaps. Keep these short.>

### 4. Checks Performed
<See the checklist below.>
```

## Finding format

Each finding includes every field below:

```markdown
#### <Short title>
- **Severity:** Critical | Important | Suggestion
- **Status:** Verified defect | Risk (needs more evidence)
- **Location:** [`path/to/file.ext:42`](<link>), or `path/to/file.ext` with the function or class name
- **Description:** <what is wrong>
- **Impact:** <concrete failure scenario: inputs or state → wrong result, crash, or exposure>
- **Suggested fix:** <specific change, with a short code snippet if it helps>
```

Rules:

- Mark a finding **Verified defect** only when the code, a reproduction, a test, or a tool result proves it. Otherwise mark it **Risk** and say what evidence would confirm it.
- Within each section, put correctness, security, data integrity, and missing requirements before performance and maintainability.
- Don't pad the review. A short review with real findings is better than a long one with filler.
- If the PR may be affected by local, uncommitted changes (current-folder review), say which findings could come from the local changes rather than the PR.

## Checks Performed

Document each item, including when something was skipped and why:

- **Workspace:** current folder or temporary worktree (path), any branch mismatch, and uncommitted changes.
- **Branch and commit:** target branch, base branch, and the head commit SHA reviewed.
- **Jira:** ticket key, whether it was accessible, and what was read (description, acceptance criteria, comments). If unavailable, say so and say what was used instead.
- **Requirements coverage:** summary of met, partly met, and missing requirements.
- **Architecture review:** short assessment.
- **Static analysis:** commands run, results, how new errors were separated from existing ones (baseline method), and any limitations.
- **Tests executed:** commands run, with pass, fail, error, and not-run counts or details.
- **Test coverage assessment:** important scenarios that are not covered.
- **Limitations:** unavailable tools, failed commands, missing dependencies, and anything else that lowers confidence in the review.

If no issues were found, say so clearly and state the limits of the checks above.

## Formatting a GitHub comment

When posting to GitHub (only after explicit approval):

- Start with the summary and a one-line count per severity, for example `Critical: 1 · Important: 2 · Suggestions: 3`.
- For long reviews, wrap each section in a `<details>` block, and leave Critical Issues expanded:
  ```markdown
  <details>
  <summary><b>Important Issues (2)</b></summary>

  ...findings...

  </details>
  ```
  Leave a blank line after `<summary>` so the Markdown inside renders.
- Link files and lines to the reviewed commit so links stay stable:
  `https://github.com/<owner>/<repo>/blob/<head-sha>/<path>#L<start>-L<end>`
- Never include secrets, `.env` contents, or tokens, even when they appear in tool output.
