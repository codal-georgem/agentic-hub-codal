# Security Rules

> Security standards enforced by the Security Agent. Zero tolerance for critical vulnerabilities.
> Follow [OWASP standards](https://owasp.org).

## Authentication

- Use JWT or OAuth2 for all authentication flows
- Never store plain-text passwords
- Hash passwords with `bcrypt` at cost factor ≥ 12
- Expire access tokens (15 min) and refresh tokens (7 days)
- Invalidate refresh tokens on logout and re-login
- Lock accounts after 10 consecutive failed attempts

## Database

- Always use parameterized queries or ORM query builders
- Never concatenate user input into SQL strings
- Apply least-privilege database roles per service
- Validate and sanitize all inputs before reaching the data layer

## Secrets

- Use environment variables for all secrets in development
- Use a secrets manager (Vault, AWS Secrets Manager) in production
- Never hardcode API keys, tokens, or passwords in source code
- Never commit `.env` files to version control

## APIs

- Validate all request payloads with a schema (Zod, Joi, etc.)
- Add rate limiting on all public and auth endpoints
- Sanitize all user input before rendering or storing
- Set security headers: `HSTS`, `CSP`, `X-Content-Type-Options`, `X-Frame-Options`
- Use HTTPS only — no plain HTTP in production

## Input Validation

### All Inputs Must Be Validated at System Boundaries

Use a schema validation library or framework-native validation to enforce input contracts at every system boundary. Reject and return an error for any input that does not conform to the expected schema.

### Validation Rules

| Input Type | Validation Required                                |
| ---------- | -------------------------------------------------- |
| Strings    | Max length, allowed characters, trim whitespace    |
| Numbers    | Range checks, integer vs float                     |
| Arrays     | Max length, item validation                        |
| Objects    | Schema validation, no extra properties             |
| Files      | Size limit, MIME type, extension whitelist         |
| URLs       | Protocol whitelist (https only), no internal IPs   |
| IDs        | Format validation (UUID, numeric), existence check |

## Authentication & Authorization

Always verify ownership and permission before allowing access to any resource. Authorization checks must happen in the service layer, not only in the presentation/controller layer.

### Authorization Checklist

- [ ] Every endpoint has explicit auth requirement (public or authenticated)
- [ ] Resource access checks ownership or role
- [ ] Admin endpoints have role-based guards
- [ ] API keys are scoped to minimum permissions
- [ ] Session tokens have expiration and rotation
- [ ] Password reset tokens are single-use

## Data Protection

### Secrets Management

- ❌ NEVER hardcode secrets, API keys, or credentials in source code
- ✅ Use environment variables for all secrets in development
- ✅ Use a secrets manager (e.g., Vault, cloud provider secrets services) in production
- Validate that required secrets are present at application startup; fail fast if missing

### Sensitive Data Handling

| Data Type          | Storage                        | Logging           | API Response        |
| ------------------ | ------------------------------ | ----------------- | ------------------- |
| Passwords          | bcrypt hash only               | Never             | Never               |
| API Keys           | Encrypted at rest              | Last 4 chars only | Masked              |
| PII (email, phone) | Encrypted                      | Anonymized        | Based on permission |
| Tokens             | Signed (JWT) or encrypted      | Never             | Httponly cookie     |
| Credit cards       | Never store (use tokenization) | Never             | Last 4 only         |

## Injection Prevention

### SQL Injection

- ❌ Never concatenate user input into SQL strings
- ✅ Always use parameterized queries or prepared statements
- ✅ Use ORM query builders that handle parameterization automatically

### XSS Prevention

- ❌ Never render unsanitized user input as raw HTML
- ✅ Use the rendering framework's safe output mechanism (most frameworks auto-escape by default)
- ✅ Sanitize HTML content with an allowlist-based library when rich text is required

### Command Injection

- ❌ Never pass user input directly to shell commands or process executors
- ✅ Use parameterized APIs for OS-level operations
- ✅ Validate and allowlist any input used in system calls

## HTTP Security Headers

Set the following headers on all HTTP responses:

| Header                      | Recommended Value                              |
| --------------------------- | ---------------------------------------------- |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains`          |
| `Content-Security-Policy`   | `default-src 'self'` (tighten per application) |
| `X-Content-Type-Options`    | `nosniff`                                      |
| `X-Frame-Options`           | `DENY`                                         |
| `X-XSS-Protection`          | `0` (rely on CSP instead)                      |
| `Referrer-Policy`           | `strict-origin-when-cross-origin`              |

## Rate Limiting

- Login endpoints: 5 attempts per minute per IP
- API endpoints: 100 requests per minute per user
- File uploads: 10 per hour per user
- Password reset: 3 per hour per email

## Dependency Security

- Run a dependency vulnerability scan on every CI build
- No dependencies with known critical CVEs
- Pin exact versions in production (avoid floating version ranges)
- Review new dependencies before adding (size, maintainers, last updated, license)
