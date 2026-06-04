---
applyTo: "src/backend/**,src/api/**,src/server/**,**/*.service.ts,**/*.controller.ts"
---

# Backend Instructions

## API Design

- Follow RESTful conventions for resource endpoints
- Use proper HTTP methods (GET, POST, PUT, PATCH, DELETE)
- Return appropriate status codes (201 for creation, 204 for deletion)
- Version APIs via URL path: `/api/v1/resource`
- Include pagination metadata in list responses

## Database

- Use migrations for all schema changes (never manual DDL)
- Add indexes for frequently queried columns
- Use transactions for multi-step operations
- Implement soft deletes for user-facing data
- Always parameterize queries to prevent SQL injection

## Authentication & Authorization

- Use JWT with short expiry + refresh tokens
- Validate tokens on every request via middleware
- Implement role-based access control (RBAC)
- Rate limit authentication endpoints
- Log all auth failures

## Error Handling

- Use a centralized error handler middleware
- Map internal errors to appropriate HTTP status codes
- Never expose stack traces in production responses
- Include request IDs in error responses for tracing

## Logging & Monitoring

- Log at appropriate levels (debug, info, warn, error)
- Include correlation IDs across service boundaries
- Never log sensitive data (passwords, tokens, PII)
- Use structured logging (JSON format)

## Testing

- Unit test business logic in isolation
- Integration test API endpoints with a test database
- Test error paths, not just happy paths
- Mock external services in tests
