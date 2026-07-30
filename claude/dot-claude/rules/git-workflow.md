# Git Workflow & Commit Rules

## 🛑 Strict Restrictions (NEVER VIOLATE)
- Never commit directly to the `main` or `features/VPWU-2693-DETAILS-MAIN` branches.

## 💾 Commit Standards (Conventional Commits)
- Branch naming: `type/TICKET-ID-short-description` (e.g. `feat/VPWU-1234-add-filter`)

```
<type>/<Jira Ticket Id>-<subject>
```
- Commit messages: imperative mood, reference ticket ID, concise first line (<72 chars)

```
<Jira Ticket Id>: <subject>
```
a space follows the colon.

## 🚀 Pull Requests & Merges
- PRs: Look for PR template in root of project (or monorepo) in the following folder `.github/PULL_REQUEST_TEMPLATE`. If there is a JIRA ticket (VPWU-*), use the `jira.md` template, otherwise the `no-jira.md` 
- Prefer rebase over merge