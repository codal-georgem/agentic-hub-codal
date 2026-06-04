# UI Standards

> Platform-agnostic UI rules. Referenced by `.github/instructions/frontend.instructions.md`,
> `.cursor/rules/ui-rules.mdc`, and Claude Code agents.

## Component Principles

1. **Single Responsibility** — Each component does one thing well
2. **Composability** — Build complex UIs from small, reusable pieces
3. **Accessibility First** — WCAG AA compliance is mandatory, not optional
4. **Performance Aware** — Lazy load, memoize, virtualize where needed

## Design Tokens

Use centralized design tokens for consistency:

```typescript
export const tokens = {
  colors: {
    primary: "#2563eb",
    secondary: "#64748b",
    success: "#16a34a",
    warning: "#d97706",
    error: "#dc2626",
    background: "#ffffff",
    surface: "#f8fafc",
    text: "#0f172a",
    textMuted: "#64748b",
  },
  spacing: {
    xs: "0.25rem", // 4px
    sm: "0.5rem", // 8px
    md: "1rem", // 16px
    lg: "1.5rem", // 24px
    xl: "2rem", // 32px
    "2xl": "3rem", // 48px
  },
  borderRadius: {
    sm: "0.25rem",
    md: "0.5rem",
    lg: "1rem",
    full: "9999px",
  },
  typography: {
    fontFamily: "'Inter', system-ui, sans-serif",
    sizes: {
      xs: "0.75rem",
      sm: "0.875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
    },
  },
} as const;
```

## Component Patterns

### Container/Presenter Pattern

```typescript
// Container (handles logic)
function UserListContainer() {
  const { data, isLoading } = useUsers();
  if (isLoading) return <Skeleton />;
  return <UserList users={data} />;
}

// Presenter (handles rendering)
function UserList({ users }: { users: User[] }) {
  return (
    <ul role="list">
      {users.map(user => <UserCard key={user.id} user={user} />)}
    </ul>
  );
}
```

### Error Boundary Pattern

```typescript
function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert" aria-live="assertive">
      <h2>Something went wrong</h2>
      <p>{error.message}</p>
      <button onClick={resetErrorBoundary}>Try again</button>
    </div>
  );
}
```

## Accessibility Checklist

- [ ] All images have descriptive `alt` text
- [ ] Color is not the only way to convey information
- [ ] Focus order is logical and visible
- [ ] All form inputs have associated labels
- [ ] Error messages are announced to screen readers
- [ ] Modals trap focus and can be closed with Escape
- [ ] Touch targets are at least 44x44px
