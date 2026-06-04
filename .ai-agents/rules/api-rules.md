# API Rules

> Standards for API design, validation, and documentation. Enforced by Review and Architecture agents.

## API Design Principles

1. **Consistency** — All endpoints follow the same patterns
2. **Predictability** — Developers can guess the URL without reading docs
3. **Safety** — GET requests never mutate state
4. **Idempotency** — PUT and DELETE are safe to retry
5. **Versioning** — Breaking changes require a new version

## URL Structure

```
/{version}/{resource}/{id?}/{sub-resource?}/{sub-id?}

# Examples
GET    /v1/users
GET    /v1/users/123
GET    /v1/users/123/orders
POST   /v1/users/123/orders
PATCH  /v1/users/123
DELETE /v1/users/123
```

### Naming Rules

- Use plural nouns for resources: `/users` not `/user`
- Use kebab-case for multi-word: `/order-items` not `/orderItems`
- No verbs in URLs: `/users/123/activate` → `PATCH /users/123 { status: "active" }`
- No trailing slashes
- Max 3 levels deep (use query params for filtering)

## Request Validation

### Required Headers

```
Content-Type: application/json
Authorization: Bearer {token}
X-Request-Id: {uuid}        // For tracing
Accept: application/json
```

### Query Parameters

```
# Pagination (cursor-based preferred)
GET /v1/users?cursor=abc123&limit=20

# Filtering
GET /v1/orders?status=pending&createdAfter=2024-01-01

# Sorting (- prefix = descending)
GET /v1/users?sort=-createdAt,name

# Field selection
GET /v1/users?fields=id,name,email
```

### Request Body Validation

Every endpoint must validate its request body against a defined schema before processing. Reject invalid payloads with a `400` response and include field-level error details.

Example schema constraints (language-agnostic):

- `items`: required array, 1–50 items, each with a `productId` (UUID) and `quantity` (integer 1–100)
- `shippingAddress`: required, validated against the address schema
- `notes`: optional string, max 500 characters

## Response Format

### Success Response

```json
{
  "data": {
    "id": "usr_abc123",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

### List Response (with pagination)

```json
{
  "data": [
    { "id": "usr_abc123", "name": "John" },
    { "id": "usr_def456", "name": "Jane" }
  ],
  "meta": {
    "cursor": "eyJpZCI6InVzcl9kZWY0NTYifQ",
    "hasMore": true,
    "total": 142
  }
}
```

### Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address"
      }
    ],
    "requestId": "req_xyz789"
  }
}
```

## HTTP Status Codes

| Code | When to Use                          |
| ---- | ------------------------------------ |
| 200  | Successful read or update            |
| 201  | Resource created                     |
| 204  | Successful delete (no body)          |
| 400  | Validation error, malformed request  |
| 401  | Missing or invalid authentication    |
| 403  | Authenticated but not authorized     |
| 404  | Resource not found                   |
| 409  | Conflict (duplicate, state conflict) |
| 422  | Business logic validation failure    |
| 429  | Rate limit exceeded                  |
| 500  | Unexpected server error              |

## Versioning Strategy

- Use URL path versioning: `/v1/`, `/v2/`
- Minor changes (additive) don't require new version
- Breaking changes always require new version
- Support previous version for minimum 6 months
- Deprecation header: `Sunset: Sat, 01 Jun 2025 00:00:00 GMT`

## Rate Limiting

### Response Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1704067200
Retry-After: 30  // Only on 429 responses
```

### Limits by Tier

| Tier       | Requests/min | Burst |
| ---------- | ------------ | ----- |
| Free       | 20           | 5     |
| Pro        | 100          | 20    |
| Enterprise | 1000         | 100   |

## API Documentation Requirements

- Every endpoint must have OpenAPI/Swagger documentation
- Include request/response examples
- Document all error codes and their meaning
- Provide authentication instructions
- Include rate limiting information
- Changelog for each version
