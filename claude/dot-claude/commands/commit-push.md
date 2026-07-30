---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*)
description: Commit and push changes to remote
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits for style reference: !`git log --oneline -10`

## Your task

Based on the above changes:

1. Stage all relevant changed files (use specific file paths, not `git add -A`)
2. Create a single commit following this format: `TICKET-ID lowercase description`
   - Extract the ticket ID from the branch name (e.g. branch `jess/VPWU-3529-login` → `VPWU-3529`)
   - Description should be lowercase, concise, no period, no colon after the ticket
   - Example: `VPWU-3529 add mobile breakpoint styling`
   - Always append the trailer: `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`
3. Push the current branch to origin

You have the capability to call multiple tools in a single response. Stage, commit, and push using a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
