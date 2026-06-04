# UI Standards

> Platform-agnostic UI rules. Referenced by `.github/instructions/frontend.instructions.md`,
> `.cursor/rules/ui-rules.mdc`, and Claude Code agents.

## Component Principles

1. **Single Responsibility** — Each component does one thing well
2. **Composability** — Build complex UIs from small, reusable pieces
3. **Accessibility First** — WCAG AA compliance is mandatory, not optional
4. **Performance Aware** — Lazy load, memoize, and virtualize where appropriate

## Design Tokens

Centralise all visual constants (colors, spacing, typography, border radius) in a shared tokens file or design system. Components must reference tokens rather than hardcoded values.

Key token categories:

- **Colors** — primary, secondary, semantic (success, warning, error), background, surface, text
- **Spacing** — xs, sm, md, lg, xl, 2xl using a consistent scale (e.g. 4px base unit)
- **Border radius** — sm, md, lg, full
- **Typography** — font family, size scale (xs through 3xl), line heights

## Component Patterns

### Container/Presenter Pattern

Separate data-fetching logic from rendering logic:

- **Container** — handles data loading, state management, and error states; passes resolved data down as props/parameters
- **Presenter** — receives data and handles rendering only; contains no side effects or async calls

The presenter must be independently testable with mock data.

### Error Boundary Pattern

Wrap subtrees that may fail with an error boundary or equivalent mechanism:

- Display a user-friendly fallback UI with a recovery action (e.g. "Try again" button)
- Announce errors to screen readers using an accessible live region (`role="alert"` or equivalent)
- Log errors to the monitoring service with contextual metadata
- Never expose stack traces or internal error details to the user

## Accessibility Checklist

- [ ] All images have descriptive alternative text
- [ ] Color is not the only way to convey information
- [ ] Focus order is logical and visible
- [ ] All form inputs have associated labels
- [ ] Error messages are announced to screen readers
- [ ] Modals trap focus and can be closed with Escape
- [ ] Touch targets are at least 44×44px
