---
paths: 
  - "**/*.ts"
---
# Typescript Guidelines

## Type System
- No `any`. Use `unknown` when the type is uncertain, then narrow with type guards
- Use `interface` for object shapes; use `type` for unions / intersections / mapped types
- Public functions must have explicit return types; internal functions may rely on inference
- Mark properties and parameters that won't be mutated with `readonly`
- Leverage built-in utility types: `Partial<T>`, `Pick<T, K>`, `Omit<T, K>`, `Record<K, V>`
- Generic parameter names should be meaningful: `TItem` rather than bare `T` (single generic parameter excepted)

## Naming
- Use `PascalCase` for types, interfaces, and classes
- Use `camelCase` for variables, functions, and object properties
- Use `UPPER_SNAKE_CASE` for constants
- Separate `import type` from value imports

## Functions

- Prefer arrow functions for anonymous functions
- Prefer `async/await`; do not chain more than 2 levels of `.then()`
- Handle errors with specific types; co not `catch(e: any)`

## Prohibited Patterns

- No `// @ts-ignore` or `// @ts-expect-error` (unless accompanied by a comment explaining why)
- No `as` type assertions (unless narrowing from `unknown` with good reason)
- No `!` non-null assertions (use optional chaining `?.` or early null checks instead)
- No `enum` (use `as const` objects or union types instead to avoid runtime overhead)