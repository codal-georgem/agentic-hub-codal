# Enterprise Coding Rules

> Canonical coding standards enforced by the Review Agent and all code-generation workflows.

## General Rules

- Use meaningful, descriptive variable and function names
- Avoid duplicate code — extract shared logic into utilities
- Keep functions small and focused on a single responsibility
- Use `async/await` properly — always handle rejections
- Add error handling at every boundary
- Avoid hardcoded values — use constants or environment variables
- Follow SOLID principles
- Prefer explicit over implicit
- Make invalid states unrepresentable through types

## API Rules

- Use proper HTTP status codes (200, 201, 400, 401, 403, 404, 409, 500)
- Validate all inputs at the API boundary using a schema
- Use centralized error handling middleware
- Return consistent response envelopes (`{ data }` / `{ error }`)
- Paginate all list endpoints

## Clean Code

- Maximum function length: **50 lines**
- Maximum file length: **500 lines**
- Maximum cyclomatic complexity: **10**
- Maximum function parameters: **3** (use options object beyond that)
- Maximum nesting depth: **3 levels** (use early returns)

## Naming Conventions

Follow the naming conventions of the language in use. The following principles apply across all languages:

| Element                | Principle                                          | Example                          |
| ---------------------- | -------------------------------------------------- | -------------------------------- |
| Files                  | Lowercase, hyphenated                              | `user-service`, `auth-utils`     |
| Classes / Types        | Descriptive noun, PascalCase equivalent            | `UserService`, `ApiResponse`     |
| Functions / Methods    | Verb + noun, language-idiomatic casing             | `getUser`, `validate_email`      |
| Constants              | Clearly distinct from mutable variables            | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |
| Interfaces / Contracts | Named for what they describe; no type-prefix noise | `UserRepository`, `EmailSender`  |

## Function Rules

- Use early returns to reduce nesting and improve readability
- Each function has a single, clear responsibility
- Validate inputs at the start before any processing
- Keep the happy path at the outermost level of indentation

## Error Handling

- Use domain-specific error types rather than generic base errors
- Always handle async/promise/callback errors explicitly
- Re-throw as domain errors at service boundaries with sufficient context
- Never swallow errors silently

## Dependency and Module Rules

- Order imports: external libraries → internal shared modules → local relative files
- No circular dependencies between modules
- Modules should expose a clear, minimal public interface
- Avoid wildcard imports where selective loading matters

## Code Complexity Limits

| Metric                | Limit     | Action if Exceeded       |
| --------------------- | --------- | ------------------------ |
| Function length       | 30 lines  | Extract helper functions |
| Cyclomatic complexity | 10        | Simplify conditionals    |
| Function parameters   | 3         | Use options object       |
| File length           | 300 lines | Split into modules       |
| Nesting depth         | 3 levels  | Use early returns        |

## Async Patterns

- Execute independent async operations in parallel, not sequentially
- Execute dependent async operations sequentially, awaiting each result
- Never fire-and-forget async operations without error handling
- Always propagate or handle async errors at every call site

## Comments Policy

- Code should be self-documenting; comments explain _why_, not _what_
- Inline documentation for all public functions (see documentation-agent)
- TODO comments must include a tracking issue: `// TODO(#123): description`
- Remove commented-out code — use git history instead
