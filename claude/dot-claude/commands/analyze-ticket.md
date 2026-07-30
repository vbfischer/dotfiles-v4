# Analyze ticket: $ARGUMENTS

The Obsidian vault is at: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Programming/Programming`

Follow these steps exactly:

1. **Read the ticket**: Use the Atlassian MCP to fetch the full details of ticket $ARGUMENTS - summary, description, acceptance criteria, subtasks, comments, linked issues, etc.
2. **Choose the project**: List the subfolders inside `🚧 Projects/` in the Obsidian vault. Prompt me to pick which project this ticket belongs to (or create a new one). If a project is selected, the file will be saved to `🚧 Projects/<project>/Jira/$ARGUMENTS-<summary>.md` where `<summary>` is the ticket summary with invalid filename characters (`/ \ : * ? " < > |`) replaced with hyphens and leading/trailing whitespace trimmed. Create the `Jira` subfolder if it doesn't exist.
3. **Explore the codebase**: Based on the ticket details, identify and read the relevant files in the codebase to understand the current state of the code that will be affected.
4. **Write the analysis**: Create the markdown file using the Jira story template frontmatter and enriched body:

```markdown
---
created: <today's date YYYY-MM-DD>
tags: [jira, story]
jiraKey: $ARGUMENTS
jiraUrl: <full Jira URL for the ticket>
project: <selected project name>
epic: <epic name if available>
sprint: <sprint name if available>
status: <current ticket status>
type: <issue type - Story, Bug, Task, etc.>
---

# $ARGUMENTS — <ticket summary>

## Link
- <full Jira URL>

## Summary
<ticket description, reformatted for clarity>

## Acceptance criteria
<acceptance criteria as a checklist using - [ ] format>

## Implementation notes
### Affected files
<list of files that will need changes, with brief explanation of why>

### Approach
<recommended implementation approach>

### Risks & edge cases
<anything to watch out for>

### Dependencies
<any blockers, related tickets, or upstream/downstream dependencies>

## Test notes
<testing strategy - how to verify the changes>

## PRs / commits
-

## Tasks
<break down the implementation into checklist items using - [ ] format>