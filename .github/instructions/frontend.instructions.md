---
applyTo: "src/frontend/**,src/components/**,**/*.tsx,**/*.jsx"
---

# Frontend Instructions

## Component Rules

- Use functional components with hooks (no class components)
- Keep components under 150 lines; extract sub-components for complex UI
- Use named exports for components
- Co-locate styles, tests, and types with components

## State Management

- Use local state (`useState`) for component-scoped data
- Use context for shared UI state (theme, auth)
- Use a state library (Zustand/Redux) only for complex global state
- Never store derived data in state — compute it

## Styling

- Use CSS Modules or Tailwind CSS
- Follow mobile-first responsive design
- Use design tokens for colors, spacing, and typography
- Ensure accessible contrast ratios (WCAG AA minimum)

## Accessibility

- All images must have `alt` text
- Interactive elements must be keyboard accessible
- Use semantic HTML elements (`nav`, `main`, `article`)
- Include ARIA labels for custom interactive components
- Test with screen readers

## Performance

- Lazy load routes and heavy components
- Memoize expensive computations with `useMemo`
- Use `React.memo` for components that re-render with same props
- Optimize images (WebP, proper sizing, lazy loading)
