---
paths:
  - "**/*.css"
---
# CSS Guidelines

## Core Principles

- Use CSS custom properties (`--var`) to manage design tokens (colors, spacing, font sizes, border radii)
- Prefer semantic naming for custom properties (e.g., `--color-primary` instead of `--blue-500`)

## Layout

- Use Flexbox or CSS Grid for layout instead of relying on floats or positioning hacks
- Avoid deeply nested selectors; aim for flat and maintainable structure