---
name: jira-story-formatter
description: "Use this skill whenever the user wants to review, evaluate, format, or improve a Jira story against the VC+ User Story template. Triggers include: review this story, format this ticket, check my story, clean up this Jira ticket, does this story follow the template, fill in missing story details, update this story in Jira, or any request to evaluate a Jira issue against a story format or acceptance criteria template. Also triggers when the user pastes a Jira ticket key (e.g. VPWU-1234) and asks anything about its format or completeness. When the story touches the VCP Web app, the skill also cross-references the VCP Web code-level documentation in Confluence (space VPWU) to add a Dev Notes section, surface Possible Side Effects, and inform Testing Considerations. Requires the Atlassian MCP (Jira read/write + Confluence search/read) to be connected."
---

---
# Jira Story Formatter

This skill reads a Jira story, evaluates it against the VC+ User Story format, asks follow-up questions to fill any gaps, drafts improved content, shows a before/after diff for approval, and — only after explicit confirmation — writes the update back to Jira.

When the story maps to functionality in the **VCP Web app**, the skill additionally consults the app's **code-level documentation in Confluence** (space **VPWU**, rooted at the **Developer Documentation** index page) to enrich the ticket with developer- and QA-facing guidance: a **Dev Notes** section of concrete references (files, classes, config, doc links), a **Possible Side Effects** section for related areas the story does not already call out, and doc-informed **Testing Considerations**. These enrichment sections are agent/developer-facing and are kept strictly separate from the customer-facing story so the VC+ format stays clean.

---

## VC+ User Story Format Reference

### When to Use the User Story Template
Use when the story delivers a tangible outcome a customer would experience in VC+ — on screen, in a notification, in a printout, or anywhere else they directly interact with the product. If the story delivers value only to an internal system or team with no customer-facing aspect, flag it as a potential Technical Story.

---

### Section 1: Summary (Ticket Title)
**Required.** An active-verb phrase written in plain language the customer would recognize.

Rules:
- Must use an active verb
- Must be written in customer language, not internal/technical language
- Must not use internal system names, version codes, or technical identifiers as the primary title
- Must be scannable by non-technical stakeholders (POs, PMs) without translation
Good: "See a badge on the notification bell when new results arrive"
Bad: "TMS-4412 webhook integration for result notification"

---

### Section 2: User Statement
**Required.**

Format: As a [who], I want [what], so that [why].

Rules for "Who":
- Must name a specific role, not a broad category — "clinic staff member enrolled in the IDEXX courier program" not "VC+ user"
- Should almost always be a clinic staff member or similar customer-facing role
- Only use an internal system or team as the persona if the story genuinely delivers value exclusively to that system/team with zero customer-facing aspect
- If a PIMS integration controls something a customer will see, the customer is still the right persona — use "I understand that" in Section 4 to acknowledge the PIMS's role
- If the persona is a system or service, explicitly challenge whether there are any user-facing aspects before accepting it
Rules for "What":
- Names the capability at the right level of abstraction — meaningful but not prescriptive of the solution
- Detailed observable outcomes belong in Section 3, not here
Rules for "Why":
- Must always be present — never skip the "so that" clause
- Connects the feature to a real human motivation
- Enables the team to make better decisions on edge cases
---

### Section 3: I Will Know This Is Complete When
**Required.**

Format:
I will know this is complete when:
* [Observable customer outcome, including where and when it occurs]
* [Observable customer outcome]
Rules:
- Each bullet is a verifiable outcome the customer can observe — on screen, in a notification, on a printout, or wherever they directly experience VC+
- Write each bullet as if the customer is narrating what they see, what they can do, or what does not appear
- When and Where must be embedded directly in each bullet — name the specific screen, state, or moment as part of the criterion
- Each bullet must be self-contained and unambiguous
Test for each bullet: Can a QA engineer verify this by acting as the customer — clicking through VC+, viewing a screen, reading a notification? If verification requires a database query, a log file, or a developer tool, the bullet does NOT belong here. It belongs in Developer Considerations or Testing Considerations.

---

### Section 4: I Understand That
**Optional** — include only when needed.

Format:
I understand that:
* [What the customer observes or experiences as a result of the constraint]
Rules:
- Constraints, known limitations, or accepted behaviors the customer would directly notice or be affected by
- Written from the customer's perspective: what would they observe or experience?
- These are things QA should NOT file as defects
- Must be customer-observable — if the customer standing in front of VC+ would never notice it, it does not belong here
- Internal implementation details belong in Developer Considerations
- Test environment dependencies belong in Testing Considerations
---

### Section 5: Supporting Detail
**Optional.**

A link to Confluence spec, prototype, Figma design, or other reference material. Links only — no inline specs. The story stays readable and customer-focused; the detail stays accessible and traceable.

---

### Section 6: Dev Notes
**Optional — agent/developer-facing. Include only when the story maps to the VCP Web app and relevant code-level docs were found.**

Concrete, developer-focused pointers drawn from the VCP Web code-level docs (see "Code-Level Documentation Reference" below) that the implementing agent will find useful. This is the home the VC+ template refers to as "Developer Considerations".

Format:
*Dev Notes:*
* [Files/classes] — e.g. `lib/features/results/result_detail_screen.tsx`, `ResultDetailBloc`
* [Config] — e.g. feature flag / config file the change touches
* [Conventions to follow] — e.g. "use app_ui widgets before custom UI (see doc)"
* [Reference docs] — link to the relevant Confluence page(s): [Doc Title](confluence-url)

Rules:
- Every pointer must come from an actual doc, the ticket, or the user — never invent a filename, class name, or config key. If a pointer is inferred rather than confirmed, mark it "(unconfirmed — verify)".
- Prefer specifics (paths, class/widget names, config keys) over generic advice.
- Always link the source Confluence doc so the implementing agent can go deeper.
- Keep it a scannable list, not prose.

---

### Section 7: Possible Side Effects
**Optional — agent/developer-facing. Include ONLY when the docs reveal a related/impacted area the story description does NOT already cover. Omit entirely when the ticket already covers everything.**

Related features, shared components, or screens that this change may affect but which the story does not mention — discovered by reading the feature's docs and following their "See also" cross-links one hop out.

Format:
*Possible Side Effects:*
* [Related feature/area] — [what might be impacted and why], see [Doc Title](confluence-url)

Rules:
- Only include genuine, doc-grounded findings. Do not manufacture speculative side effects to fill the section.
- Each item must name the impacted area, why it could be affected, and link the doc that revealed it.
- If, after review, the ticket already accounts for the impacted areas, leave this section out completely.
- Example: a change to shared list styling that the story frames as one screen only, but the docs show the same widget backs three other screens → call those out.

---

### Section 8: Testing Considerations
**Optional — agent/QA-facing. Include when the story maps to the app and there is anything beyond the customer-observable acceptance criteria worth testing.**

What needs to be tested, informed by the docs — including regression surfaces implied by any Possible Side Effects, documented behaviors, and test environment or data dependencies that don't belong in the customer-facing acceptance criteria.

Format:
*Testing Considerations:*
* [What to test and where] — e.g. "regression-test the Patient List and Search screens (share IdexxTable)"
* [Env/data/config dependency] — e.g. "requires a clinic enrolled in the courier program"

Rules:
- Tie each item back to a doc finding, a Possible Side Effect, or a stated constraint where possible.
- This is where verification that needs dev tools, specific data, or environment setup lives — the things explicitly excluded from Section 3.
- Do not restate the customer-observable acceptance criteria; those are already Section 3.

---

### Section Checklist

| Section | Required | Key Test |
|---|---|---|
| Summary | Yes | Active verb? Customer language? No internal identifiers? |
| User Statement | Yes | Specific persona? Right abstraction for "what"? "So that" present? |
| I will know this is complete when | Yes | Each bullet customer-observable? When/Where embedded? QA-verifiable without dev tools? |
| I understand that | Optional | Customer-observable constraints only? Nothing that belongs in dev notes? |
| Supporting Detail | Optional | Links only — no inline specs? |
| Dev Notes | Optional | App-related? Every pointer doc/ticket-grounded (nothing invented)? Docs linked? |
| Possible Side Effects | Optional | Only real, doc-grounded impacts not already covered? Omitted if ticket covers everything? |
| Testing Considerations | Optional | Beyond Section 3? Tied to doc findings / side effects / constraints? |

---

## Code-Level Documentation Reference (VCP Mobile)

The VCP Web app's code-level documentation lives in Confluence space **VPWU**, rooted at the **VCP Web Developer Documentation** index page:
https://idexx.atlassian.net/wiki/spaces/VPWU/pages/6900514939/VCP+Web+Developer+Documentation

It is a flat set of pages under the "Agent Docs" folder, organized by the index into sections: **Architecture, Features, Widgets, Configs, Conventions, Tools, Archive**. Each page carries **"See also" cross-links** to related pages — those cross-links are the primary tool for discovering related/impacted features (Section 7).

How to use it:
- **Search** the VPWU space by feature keywords from the ticket (`confluence_search` / Atlassian search, space = VPWU).
- **Read** candidate pages (`confluence_get_page`) to extract file paths, class/widget names, config files, conventions, and documented behaviors.
- **Traverse** each relevant page's "See also" links one hop out to find adjacent features and shared components — these feed Possible Side Effects.
- Prefer this VPWU corpus over generic search when the story is about VCP Web.

---

## Workflow

### Step 0: Identify the Ticket
If the user has not provided a Jira issue key, ask for one before proceeding.

---

### Step 1: Read the Ticket
Use the Atlassian MCP to fetch the issue. You need:
- `summary` (the ticket title)
- `description` (the story body)
- `issuetype` (confirm it is a Story — if not, flag this to the user before continuing)
If the issue cannot be fetched, report the error and stop.

---

### Step 2: Research the Code-Level Docs (when the story maps to the VCP Web app)
Decide relevance first: does this story change something in the VCP Web app — a screen, widget, feature, service, or config?
- If **no** (pure process/non-app work), or if you search and find **no relevant docs**, note "no relevant code-level docs found" and skip the enrichment sections (6–8). Continue to Step 3.
- If **yes**, research the VPWU corpus (see "Code-Level Documentation Reference"):
  1. Search VPWU by the feature keywords from the summary / user statement / acceptance criteria.
  2. Read the direct docs for the feature; extract implementation pointers (files, classes/widgets, config files, conventions) and documented behaviors.
  3. Follow each relevant doc's "See also" cross-links one hop out to identify related features and shared components — candidate side effects.
  4. Build a short working list of `{doc title, Confluence URL, pointers, related-areas}` to feed Steps 3–5.

Keep this research scoped and time-boxed — a handful of the most relevant pages, not the whole space. This research informs the evaluation (Step 3), can reduce follow-up questions (Step 4), and produces Sections 6–8 in the draft (Step 5).

---

### Step 3: Evaluate the Current Content
Evaluate the fetched ticket against every required/optional section in the format above. For each section, note:
- ✅ Present and well-formed
- ⚠️ Present but has issues (explain what)
- ❌ Missing entirely
Apply the specific tests from the format reference:
- **Summary**: Active verb? Customer language? No internal identifiers?
- **User Statement**: Specific persona (not "VC+ user")? "What" at right abstraction? "So that" present?
- **I will know this is complete when**: Each bullet customer-observable? When/Where embedded? QA-verifiable without dev tools?
- **I understand that** (if present): Customer-observable only? Nothing that belongs in dev notes?
- **Supporting Detail** (if present): Links only?
- **Dev Notes / Possible Side Effects / Testing Considerations** (if app-related): Using the Step 2 findings — are there concrete references to add? Any doc-revealed impacted areas the story doesn't cover? Any test surfaces the acceptance criteria miss?
Present a concise evaluation summary to the user before asking questions. Show what is good, what needs work, what is missing, and — if you researched docs — a brief note of the most relevant docs found. Keep this readable — not a wall of text.

---

### Step 4: Ask Follow-Up Questions
Before drafting anything, ask the user for information needed to fill gaps or fix issues identified in Step 3. Only ask about things that are actually missing or broken — do not ask about sections that are already complete and well-formed, and do not ask for anything the docs already answered.

First ask: "Who is best placed to answer these questions — a product manager, designer, or developer?" Then frame questions in plain language suited to that role.

Question guidelines:
- Group questions by section
- Ask only what you need — don't ask for information you can infer from the ticket or the docs
- If the persona is a system or service, challenge it: "The current persona is [X] — is there a customer who ultimately experiences this outcome? If so, who are they?"
- For missing "so that" clauses: "What is the underlying motivation for the customer here — what problem does this solve for them?"
- For vague or missing acceptance criteria: "What would the customer see or be able to do on screen when this is working correctly? Where in the product would that happen?"
- For missing When/Where in bullets, ask about the specific screen, state, or moment
- If a doc-derived Possible Side Effect is uncertain, confirm it rather than asserting it: "The docs show [widget] also backs [screens X/Y]; does this change affect those too?"
Wait for the user's answers before proceeding to Step 5.

---

### Step 5: Draft the Updated Story
Using the original content, the user's answers, and the Step 2 doc findings, draft the full updated story.

Format the description using this structure (omit optional sections if not applicable):

*User Statement*
As a [who], I want [what], so that [why].

*I will know this is complete when:*
* [Observable customer outcome including when and where]
* [Observable customer outcome including when and where]

*I understand that:*
* [Customer-observable constraint] (only if applicable)

*Supporting Detail*
[Link(s)] (only if applicable)

---
*Dev Notes:* (only if app-related and docs found)
* [File/class/config/convention pointer] — [Doc Title](confluence-url)

*Possible Side Effects:* (only if docs reveal an impacted area the story doesn't already cover — omit otherwise)
* [Related area] — [why it may be impacted], see [Doc Title](confluence-url)

*Testing Considerations:* (only if there is anything beyond Section 3 worth testing)
* [What to test / dependency]

Keep the customer-facing sections (User Statement, acceptance criteria, I understand that) free of developer detail — all implementation/test specifics live in the Dev Notes / Possible Side Effects / Testing Considerations block, visually separated by a divider.

Also draft an updated Summary (ticket title) if the current one fails the format test.

Present the draft clearly in the conversation. Do not write to Jira yet.

---

### Step 6: Show the Diff and Ask for Approval
Show a before/after comparison with the original and proposed summary and description clearly labeled. Note what changed and why (one sentence per change). For the enrichment sections, name the docs that informed each finding so the user can sanity-check them.

Then ask explicitly: "Does this look right? Reply approve to update the ticket, or tell me what to change."

Do not proceed until the user approves. If they request changes, revise and re-show the diff.

---

### Step 7: Write to Jira (only after approval)
Once the user has approved, use the Atlassian MCP to update the issue:
- Update the `summary` field if it changed
- Update the `description` field with the approved content
Confirm success with the issue key and a link to the ticket. If the update fails, report the error and show the approved content again so the user can copy it manually.

---

## Guardrails
- **Never write to Jira without explicit user approval** — "looks good", "yes", or "approve" all count; anything ambiguous does not
- **Never invent customer context** — if you don't have enough information to write a bullet or a "so that" clause, ask; do not fill in plausible-sounding details
- **Never invent code references** — every Dev Notes pointer (file, class, config, doc) must come from an actual doc, the ticket, or the user. Mark anything inferred "(unconfirmed — verify)". Do not guess file paths or class names.
- **Only ground findings in the docs** — Possible Side Effects and doc-informed Testing Considerations must trace to a real VPWU page (link it). Do not manufacture side effects; if the ticket already covers everything, omit the Possible Side Effects section entirely.
- **Keep the layers separate** — customer-facing sections stay customer-observable (no dev tools, no file names); developer/QA detail stays in Sections 6–8. This preserves the VC+ template's core rule.
- **Enrichment is best-effort, not blocking** — if the story isn't app-related or no relevant docs exist, proceed with the normal formatting and note that no code-level docs applied. Don't stall the core review on doc research.
- **Surface the Technical Story flag** — if no customer-facing aspect can be identified after questioning, note that this story may belong in the Technical Story template and let the user decide whether to continue
- **Preserve intent** — the goal is to improve format and completeness, not to rewrite the product decision; keep the scope and intent of the original story intact