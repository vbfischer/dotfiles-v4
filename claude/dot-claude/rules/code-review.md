When reviewing code (PRs, diffs, or files):
- Check for correctness, readability, and maintainability
- Flag security issues (injection, auth gaps, exposed secrets)
- Note missing error handling and edge cases
- Verify test coverage for changed behavior
- Check naming consistency and adherence to project conventions
- Keep feedback actionable — suggest fixes, not just problems
- Distinguish blocking issues from nits

Flag these as violations that must be fixed:
- `console.log` / `console.error` in `src/` files
- casting a type using `as` unless really needed. Prefer narrowing or type guards
- any new translations added, but the languages files have not been updated (pnpm i18n)