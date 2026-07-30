---
name: start-work
description: Use when the user says they are starting work on a ticket (e.g. "start work on VPWU-1234", "I'm starting work on VPWU-1234", "let's start VPWU-1234") — creates a git worktree/branch for the ticket and documents it in Confluence.
---

# Start work: $ARGUMENTS

This command sets up a new work item by creating a git worktree and documenting the analysis in your Confluence personal knowledge base.

Follow these steps exactly:

1. **Ensure latest main**: Run `git pull origin main`
2. **Read the Jira ticket**: Use the Atlassian MCP to read the ticket and prime the context.
3. **Analyze the Jira ticket**: Understand requirements, acceptance criteria, and technical implications
4. **Create worktree and branch**: Use the `git-conventions` skill to create a new worktree and branch. Parse `$ARGUMENTS` for a `--type` flag (e.g. `--type feature`). If provided, use that as the branch type prefix. If not provided, infer the type from the ticket (Story → feature, Bug → fix, Task → chore). Important: follow rules in git-workflow.md for workflow names and path. Branch name should match the path.
5. **Explore the codebase**: Based on the ticket details, identify and read the relevant files in the codebase to understand the current state of code that will be affected.
6. **Create Confluence documentation**: In your personal knowledge base (space ID: 464257119), create a new page under "🚀 Project Documentation" (parent ID: 6578405465) with the ticket number and title as the page name (e.g., "VPWU-3639 - Feature Description"). Use the Atlassian MCP with HTML content format to create a well-structured page with the following sections:

## Confluence Page Structure

Create the page with this HTML structure:

- **Title**: `$ARGUMENTS - <Brief Description from Ticket>`
- **Parent**: Project Documentation page (ID: 6578405465)
- **Labels**: Add appropriate labels like the ticket type (story, bug, task), technology stack, and status

Page content should include:

1. **Overview Section**
   - Jira ticket link
   - Summary of the requirement
   - Current status

2. **Technical Analysis**
   - Affected files and components
   - Implementation approach
   - Architecture decisions

3. **Acceptance Criteria** (as task list)
   - Use Confluence task lists for trackable criteria

4. **Implementation Plan**
   - Step-by-step approach
   - Dependencies and blockers
   - Risk assessment

5. **Testing Strategy**
   - Unit tests needed
   - Integration tests
   - Manual testing steps

6. **Progress Tracking**
   - Implementation tasks as checkboxes
   - PR/commit links (to be updated as work progresses)

7. **Notes & Learnings**
   - Discoveries during implementation
   - Gotchas and edge cases
   - Future improvements

Remember to:
- Link to the Jira ticket using Confluence's smart links
- Use status badges for progress tracking
- Add code blocks for technical details
- Use panels (info/warning/note) for important callouts
- Make the page shareable if collaboration is needed
