# Review document

After every review, write a Markdown document that a developer can read later, without the conversation, to understand:

- What was checked, how, and with what result.
- How to fix each finding.

The review shown in chat (and optionally posted to GitHub) stays concise. This document is the detailed companion.

Write it in the chosen language. Keep code, identifiers, commands, paths, and Jira keys in English.

## Rules

- **Explain every step, including skipped ones.** For each step, record what you did, how (commands, files read, tools used), and the result. A skipped or failed step stays in the document with the reason.
- **Offer real alternatives.** For each finding, give 1–3 possible solutions. A trivial fix needs only one, so don't invent alternatives for the sake of it. For each solution, give its trade-offs and say which one you recommend and why. Base the solutions on the codebase's existing patterns, and name the existing helper, class, or pattern to reuse when there is one.
- **Show how to verify.** Every finding says how to confirm the fix: the test to add or change, the command to run, or the manual check.
- **Stay consistent with the review.** Use the same findings, severities, and statuses (verified defect or risk) as the review in chat. Don't add findings that weren't in the review.
- **Never include secrets, tokens, or `.env` contents**, even when they appear in tool output.
- **Use clickable locations:** `path/to/file.ext:42`. Add a GitHub link pinned to the reviewed commit when the repository is on GitHub.

## Template

````markdown
# Code Review: <PR title or branch>

| | |
| --- | --- |
| **PR** | <link or "none"> |
| **Branch** | `<head>` → `<base>` |
| **Commit reviewed** | `<head-sha>` |
| **Jira** | <KEY and link, or "not available: reason"> |
| **Workspace** | <current folder / worktree path, and any local changes> |
| **Date** | <YYYY-MM-DD> |
| **Verdict** | <Approve / Approve with suggestions / Changes requested> |

## Summary

<3–6 sentences: what the PR does, the overall assessment, and the most important problems.>

| Severity | Count |
| --- | --- |
| Critical | <n> |
| Important | <n> |
| Suggestions | <n> |

## Review steps

<!-- One subsection per step, in the order performed. Keep every step, even skipped ones. -->

### 1. Target and workspace
- **What:** Identified the review target and where the review ran.
- **How:** `gh pr view …`, `git status --short`, `git worktree add …`
- **Result:** <branch, commit, worktree path, any local changes or branch mismatch>

### 2. Requirements (Jira)
- **What:** Read the ticket and extracted the requirements and acceptance criteria.
- **How:** <MCP tool or source used>
- **Result:** <requirements list, or why Jira was unavailable and what was used instead>

### 3. Requirements coverage
- **Result:** <table or list: each requirement → met / partly met / missing, with the location of the evidence>

### 4. Frontend review
- **Scope:** <files reviewed, or "no frontend changes">
- **Result:** <what was checked and what was found>

### 5. Backend review
- **Scope:** <files reviewed, or "no backend changes">
- **Result:** <what was checked and what was found>

### 6. Code quality and architecture
- **Result:** <assessment, and the patterns the change follows or breaks>

### 7. Static analysis
- **How:** `<exact commands>`
- **Baseline:** <how new errors were separated from existing ones, or why that wasn't possible>
- **Result:** <new errors, or "none introduced">

### 8. Tests
- **How:** `<exact commands>`
- **Result:** <passed / failed / errors / not run, with reasons>
- **Coverage:** <important scenarios that are not covered>

## Findings and possible solutions

<!-- One subsection per finding, ordered Critical → Important → Suggestion. -->

### [Critical] <Short title>

- **Location:** `path/to/file.ext:42` (<link pinned to commit>)
- **Status:** Verified defect | Risk (needs more evidence: <what evidence>)
- **Problem:** <what is wrong, and why>
- **Impact:** <concrete failure scenario>

**Possible solutions**

1. **<Option A name> (recommended).** <What to change.>
   ```<lang>
   <short illustrative snippet>
   ```
   *Trade-offs:* <cost, risk, scope>
2. **<Option B name>.** <What to change.>
   *Trade-offs:* <cost, risk, scope>

**Why the recommendation:** <one or two sentences>

**How to verify:** <test to add or change, command to run, or manual check>

## Limitations

<Unavailable tools, failed commands, missing dependencies, and anything else that lowers confidence. If there are none, write "None.">

## Next steps

- [ ] <Fix for finding 1>
- [ ] <Fix for finding 2>
- [ ] <Add missing test …>
- [ ] Re-run `<static analysis / test command>` after the fixes
````

If the review found no issues, keep the Review steps section, replace the findings section with a short statement that nothing was found, and list the limits of the checks in Limitations.
