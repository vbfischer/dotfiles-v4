---
description: Generate release notes from recent changes (commits, PRs, tags)
user-invocable: true
arguments: version tag or range (e.g. "v2.4.0" or "v2.3.0..v2.4.0")
---

# Release Notes

Generate release notes for the given version or range. If no argument is provided, infer the range from the two most recent tags.

## Steps

1. Determine the commit range:
   - If a single tag is given (e.g. `v2.4.0`), find the previous tag and use `previous_tag..given_tag`.
   - If a range is given (e.g. `v2.3.0..v2.4.0`), use it directly.
   - If no argument, use `git tag --sort=-v:refname` to find the last two tags.
2. Collect all merge commits and PRs in that range using `git log` and `gh pr list --search` or `gh api`.
3. For each PR, extract the title, number, and author.
4. Write the release notes in the format below.

## Format

```
# Release <version> — <YYYY-MM-DD>

## What changed

- <Present-tense imperative bullet> ([#<PR number>](<PR URL>))
- ...

## Why it matters

<1-3 short paragraphs explaining the user-facing impact of these changes.>

## Migration steps

<If no migration is needed, write "No migration steps required.">
<Otherwise, numbered steps in imperative mood.>
```

## Rules

- No emojis.
- Every bullet links its PR.
- Present-tense imperative mood (e.g. "Add", "Fix", "Remove" — not "Added", "Fixes").
- Never use "we" — use the imperative or passive voice.
- Group bullets by theme if there are more than ~8 items (use ### subheadings inside "What changed").
- Keep bullets concise — one line each.
- If a PR is purely internal (CI, refactor with no behavior change), list it under a "### Internal" subgroup.
