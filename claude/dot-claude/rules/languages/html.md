---
paths: 
  - "**/*.html"
  - "**/*.tsx"
---
# HTML Guidelines

## Core Principles

- Use semantic HTML elements (`<header>`, `<main>`, `<footer>`, `<article>`, `<section>`) to structure content
- Ensure all interactive elements are accessible (e.g., `<button>` for actions, `<a>` for navigation)
- Use `aria-*` attributes to enhance accessibility where necessary
- Keep the HTML structure flat and avoid unnecessary nesting
- Use meaningful `alt` text for images and descriptive link text for anchors
- Interactive elements: use `<button>` for actions and `<a>` for navigation

## Prohibited Patterns

- No inline `style` attributes (unless the value is dynamically computed)
- No `<br>` for spacing (use CSS margin/padding)
- No `<table>` for page layout