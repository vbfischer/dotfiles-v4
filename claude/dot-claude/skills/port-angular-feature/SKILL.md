---
name: port-angular-feature
description: Port an AngularJS feature to the ui3 React UI using research agents, an Obsidian flow note, a plan, worktree implementers, and review. Use when asked to port, convert, or migrate an Angular feature to React/ui3.
---
Feature to port: $ARGUMENTS

1. In parallel (single message), launch `angular-researcher`, `backend-contract-researcher`,
   and `ui3-conventions-researcher` for the feature. Give each a narrow brief with the
   feature name and any ticket key.
2. Merge the reports into an Obsidian note in "📚 Tech Library" (flow, states, gating,
   endpoints, plus a gap table of ticket acceptance criteria vs. current Angular behavior).
3. STOP. Ask the user (AskUserQuestion) every scope question the gap table raises.
   Do not plan until they are answered.
4. Launch a Plan agent with the merged findings and the decisions. Save the plan to
   Obsidian as well as the local plan file.
5. After the user approves, implement with the `ui3-implementer` agent. Give it the plan
   path (and ticket key). It first proposes a stage list (small, dependency-ordered,
   each verified with lint + tests, nothing user-visible until the integration stage).
   Launch it first in propose-only mode (no edits), show the list to the user, and
   get a go-ahead before it edits. It then implements ONE stage and stops. After each
   stage, present the checkpoint (files, test results, deviations, suggested commit)
   and WAIT for the user to review. Only when the user explicitly approves, resume the
   same agent with SendMessage ("continue to stage N", plus any requested changes).
   Never resume it on your own, and never tell it to run all stages unless the user
   explicitly asks for that. It does not commit.
   - Small change: one implementer, stages in sequence.
   - Larger change: split into non-overlapping file sets, write shared types first,
     and run one implementer per set with `isolation: "worktree"`.
   Relay each checkpoint to the user and suggest a commit per stage.
6. Review the combined diff with fresh context (`/code-review`) against the Angular
   behavior checklist. Report blocking issues separately from nits.
