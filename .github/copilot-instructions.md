# GitHub Copilot Instructions

> These rules are always active for all files in this repository.

## General Coding Rules

- Write clean, readable, and maintainable code
- Prefer composition over inheritance
- Use early returns to reduce nesting
- Keep functions focused on a single responsibility
- All public APIs must have TypeScript types

## Security

- Never hardcode secrets or credentials
- Validate all user inputs at system boundaries
- Use parameterized queries for database operations
- Sanitize output to prevent XSS
- Follow the principle of least privilege

## Error Handling

- Use typed error classes, not generic `Error`
- Always handle promise rejections
- Log errors with sufficient context (but never log sensitive data)
- Provide user-friendly error messages at the API boundary

## Performance

- Avoid N+1 queries — use batch fetching
- Implement pagination for list endpoints
- Use caching where appropriate (document TTL decisions)
- Prefer streaming for large data transfers

## Documentation

- Add JSDoc for all exported functions
- Include `@example` tags for complex APIs
- Keep README files up to date when changing behavior
