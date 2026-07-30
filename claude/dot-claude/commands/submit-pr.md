---
name: submit-pr
description: Review changes, commit, and open a pull request on GitHub using the GitHub MCP server. Handles branch creation if currently on main/master. Optionally accepts a PR template name as an argument (e.g. /submit-pr feature).
---

Follow these steps to submit a pull request. Use the GitHub MCP server tools (mcp__github__*) for all GitHub operations.

The user may have invoked this skill with an argument specifying a template name, e.g. `/submit-pr feature`. If so, $ARGUMENTS will contain that template name — use it to pre-select the template in step 3.

## Attribution

All commits and the PR description must include the following trailer/signature:

```
Co-Authored-By: Claude Sonnet 4.6 <claude-sonnet-4-6@anthropic.com>
```

## 1. Check current branch

Run `git branch --show-current` to get the current branch.

If on `main` or `master`:
- Ask the user for a branch name, or suggest one based on the staged/unstaged changes
- Create and switch to it: `git checkout -b <branch-name>`

## 2. Review outstanding changes

Run `git status` and `git diff` (and `git diff --staged`) to understand what has changed.

Summarize the changes for the user — what files were modified, what was added/removed, and the overall intent of the changes.

## 3. Check for PR templates

Look for PR templates in the following locations (in order) (NOTE: Be sure to be in the root of the folder and not just in packages/client or packages/server):

- `.github/PULL_REQUEST_TEMPLATE/` — directory containing multiple templates (e.g. `jira.md`, `no-jira.md`)
- `.github/pull_request_template.md` — single default template
- `.github/PULL_REQUEST_TEMPLATE.md` — single default template (uppercase)
- `docs/pull_request_template.md`
- `pull_request_template.md` (repo root)

**If a template name was passed as an argument (`$ARGUMENTS`):**
- Find the matching template file in `.github/PULL_REQUEST_TEMPLATE/` (case-insensitive match on filename)
- If not found, inform the user and list available templates

**If no argument was given and multiple templates exist:**
- List the available templates by name and ask the user which one to use

**If no argument was given and only one template exists:**
- Use it automatically

**If no templates exist:**
- Use the default PR body structure from step 5

### Jira template: resolving the story number

If a Jira-based template is selected, try to determine the Jira story number automatically before prompting:

1. Check the **branch name** for a Jira key pattern (e.g. `VCPT-1234`, `ABC-567`) — most branches are named like `VCPT-1234-short-description`
2. Check recent **commit messages** (`git log --oneline -10`) for a Jira key
3. Check `$ARGUMENTS` — the user may have passed it directly (e.g. `/submit-pr jira VCPT-1234`)

If a Jira key is found via any of the above, use it and inform the user.
If no Jira key can be determined, ask: **"What is the Jira story number for this PR?"** before proceeding.

## 4. Commit

Stage and commit the changes:
- Prefer staging specific files over `git add -A`
- Commit messages must follow **Conventional Commits** (semantic commits):

```
<type>(<optional scope>): <short description>
```

Valid types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `ci`, `build`, `revert`

Examples:
- `feat(auth): add OAuth2 login flow`
- `fix(api): handle null response from user endpoint`
- `chore: update dependencies`
- `refactor(checkout): extract payment validation logic`

- Always append the Co-Authored-By trailer to every commit message:

```
git commit -m "$(cat <<'EOF'
<type>(<scope>): <short description>

Co-Authored-By: Claude Sonnet 4.6 <claude-sonnet-4-6@anthropic.com>
EOF
)"
```

If there are already committed changes ahead of origin, skip directly to step 5.

## 5. Push the branch

Push to origin: `git push -u origin <branch-name>`

## 6. Create the PR via GitHub MCP

Use `mcp__github__create_pull_request` to create the PR with:
- The repo owner and name (derive from `git remote get-url origin`)
- **Title format:** `[NO-JIRA] <description>` or `[VCPT-1234] <description>` depending on the template chosen — use the Jira key resolved in step 3, or `NO-JIRA` for the no-jira template. Keep the description portion under 60 chars.
- `head` set to the current branch, `base` defaulting to `main`
- Body: fill in the selected PR template with relevant details, or use the default structure below if no template was found:

```
## Summary
- <bullet points describing what changed and why>

## Test plan
- [ ] <testing steps>

Co-Authored-By: Claude Sonnet 4.6 <claude-sonnet-4-6@anthropic.com>
🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

Always append the Co-Authored-By and Claude Code lines to the bottom of the body, even when using a template.

## 7. Share the result

Output the PR URL to the user when done.