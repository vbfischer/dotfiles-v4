---
paths:
  - "packages/client/**/tsx"
  - "packages/client/**/ts"
  - "**/*.tsx"
---
# React Guidelines

## Basic Component Rules
- Functional components only, use hooks
- Use path aliases (`@api/`, `@common/`, `@hooks/`, etc.) not relative imports for cross-feature refs
- Colocate component, styles, tests, and types
- Use TanStack Query for server state; avoid redundant local state
- Accessibility: semantic HTML, ARIA labels, test with jest-axe
- Components are responsible only for UI; extract business logic into custom hooks

## Hook Rules

- Custom hook file names must have the `use` prefix: `useAuth.ts`
- A hook should do one thing only
- `useEffect` must have a correct dependency array; suppressing with `// eslint-disable-next-line` is forbidden
- `useEffect` with side effects must return a cleanup function
- Passing an async function directly to `useEffect` is forbidden

## Props

- Define with TypeScript interfaces, named `XxxProps`
- Prefer primitive types over objects for props
- Name callback props with `onXxx`: `onClick`, `onSubmit`

## Styling

- Use CSS Modules or `clsx`/`cn` for class name concatenation when dynamic styles are needed
- Inline style objects are forbidden (unless the values are truly dynamically computed)
- `!important` is forbidden
- Styled Components is deprecated so don't use it for new components.