# GitHub Copilot Instructions

> These rules are always active for all files in this repository.
> Canonical rules and agent definitions live in `.ai-agents/`.

## AI Run Agents

All AI-generated code is validated by a pipeline of specialized agents.
Rules for each domain are defined in `.ai-agents/rules/`. Agents are defined in `.ai-agents/agents/`.
Follow `.ai-agents/instructions/validation-gate.instructions.md` for explicit JIRA-first intake, mandatory Review + Security checks on every code change, and the required `AI Agent Quality Matrix` plus `Final Result` output on every validation response.

| Agent               | File                                       | When to Use                     |
| ------------------- | ------------------------------------------ | ------------------------------- |
| Review Agent        | `.ai-agents/agents/review-agent.md`        | Every code change               |
| Security Agent      | `.ai-agents/agents/security-agent.md`      | Every code change               |
| Testing Agent       | `.ai-agents/agents/testing-agent.md`       | After generating/modifying code |
| Performance Agent   | `.ai-agents/agents/performance-agent.md`   | Hot paths, new queries          |
| Architecture Agent  | `.ai-agents/agents/architecture-agent.md`  | New modules, structural changes |
| Documentation Agent | `.ai-agents/agents/documentation-agent.md` | New public APIs                 |

> **Prompts:** `.ai-agents/prompts/` | **Workflows:** `.ai-agents/workflows/`

## General Coding Rules

> Full rules: `.ai-agents/rules/coding-rules.md`

- Write clean, readable, and maintainable code
- Prefer composition over inheritance
- Use early returns to reduce nesting
- Keep functions focused on a single responsibility
- All public APIs must have TypeScript types
- Maximum function length: 50 lines; maximum file length: 500 lines

## Security

> Full rules: `.ai-agents/rules/security-rules.md`

- Never hardcode secrets or credentials
- Validate all user inputs at system boundaries
- Use parameterized queries for database operations
- Sanitize output to prevent XSS
- Follow the principle of least privilege
- Follow [OWASP standards](https://owasp.org)

## Error Handling

- Use typed error classes, not generic `Error`
- Always handle promise rejections
- Log errors with sufficient context (but never log sensitive data)
- Provide user-friendly error messages at the API boundary

## Performance

> Full rules: `.ai-agents/agents/performance-agent.md`

- Avoid N+1 queries — use batch fetching
- Implement pagination for list endpoints
- Use caching where appropriate (document TTL decisions)
- Prefer streaming for large data transfers

## Testing

> Full rules: `.ai-agents/rules/testing-rules.md`

- Minimum 80% code coverage
- Cover positive, negative, and edge case scenarios
- Mock all external dependencies
- Use the project's testing framework; cover unit, integration, and E2E layers

## Documentation

> Full rules: `.ai-agents/agents/documentation-agent.md`

- Add JSDoc for all exported functions
- Include `@example` tags for complex APIs
- Keep README files up to date when changing behavior

## API Design

> Full rules: `.ai-agents/rules/api-rules.md`

- Use proper HTTP status codes
- Version all breaking changes (`/v1/`, `/v2/`)
- Return consistent response envelopes (`{ data }` / `{ error }`)
