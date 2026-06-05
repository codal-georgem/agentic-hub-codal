# AGENTS.md — Shared Agent Instructions

> This file defines agents available in both Claude Code and GitHub Copilot.
> Full agent definitions, rules, and prompts live in `.ai-agents/`.

## Agent Pipeline

Always start with the **Context Collector Agent**. It gathers JIRA ticket details and technical context once, then passes a Context Package to each specialist agent. Specialist agents do not ask questions — they act on the Context Package.
Follow `.ai-agents/instructions/validation-gate.instructions.md` for explicit JIRA-first intake, mandatory Review + Security checks on every code change, and the required `AI Agent Quality Matrix` plus `Final Result` output on every validation response.

```
Context Collector → Review → Security → Performance → Testing → Architecture → Documentation
```

Or use a pre-built workflow:

- **Login API:** `.ai-agents/workflows/login-api-validation.md`
- **Frontend:** `.ai-agents/workflows/frontend-validation.md`

---

## Context Collector Agent

**Full definition:** `.ai-agents/agents/context-collector-agent.md`

**When to invoke:** Always first — before any other agent.

**Collects:** JIRA ticket ID, Acceptance Criteria, ticket type/priority, change description, trade-offs, which agents to run, and agent-specific context (test framework, trust boundary, latency targets, module interactions, documentation audience).

**Output:** A structured **Context Package** passed to every selected specialist agent.

---

## Review Agent

**Full definition:** `.ai-agents/agents/review-agent.md`  
**Prompt:** `.ai-agents/prompts/review-prompt.md`  
**Rules:** `.ai-agents/rules/coding-rules.md`, `.ai-agents/rules/architecture-rules.md`

**When to invoke:** On every PR, after AI-generated code is produced, before merge.

**Checks:** Naming conventions, duplicate code, error handling, readability, edge cases, scalability

**Output:** `PASS / FAIL` · Severity level · Improvement suggestions

---

## Security Agent

**Full definition:** `.ai-agents/agents/security-agent.md`  
**Prompt:** `.ai-agents/prompts/security-prompt.md`  
**Rules:** `.ai-agents/rules/security-rules.md`

**When to invoke:** On every code change, when new dependencies are added.

**Checks:** SQL injection, XSS, CSRF, authentication flaws, authorization issues, secret exposure  
**Standard:** [OWASP Top 10](https://owasp.org)

**Output:** `PASS / FAIL` · Security score · Vulnerabilities · Fix recommendations

---

## Testing Agent

**Full definition:** `.ai-agents/agents/testing-agent.md`  
**Prompt:** `.ai-agents/prompts/testing-prompt.md`  
**Rules:** `.ai-agents/rules/testing-rules.md`

**When to invoke:** After generating or modifying code, when coverage drops below 80%.

**Generates:** Unit tests, integration tests, edge cases, negative scenarios  
**Minimum coverage:** 80%

---

## Performance Agent

**Full definition:** `.ai-agents/agents/performance-agent.md`

**When to invoke:** On hot paths, new database queries, before production deployment.

**Checks:** N+1 queries, algorithmic complexity, memory leaks, bundle size, blocking I/O

**Output:** Risk level · Issues with estimated impact · Optimized code suggestions

---

## Architecture Agent

**Full definition:** `.ai-agents/agents/architecture-agent.md`  
**Prompt:** `.ai-agents/prompts/architecture-prompt.md`  
**Rules:** `.ai-agents/rules/architecture-rules.md`

**When to invoke:** When new modules are created, on structural/cross-module changes.

**Checks:** Layer boundary violations, circular dependencies, coupling analysis, API contract compliance

**Output:** Compliance score · Violations · Dependency graph · Recommendations

---

## Documentation Agent

**Full definition:** `.ai-agents/agents/documentation-agent.md`

**When to invoke:** After new public APIs, exported functions, or modules are created.

**Checks:** JSDoc coverage, `@param`/`@returns`/`@example` completeness, README currency

**Output:** Coverage % · Missing docs list · Generated JSDoc

---

## Refactor Agent

**When to invoke:** When code smells are detected, during cleanup sprints, or before adding features to messy code.

**Instructions:**

- Preserve existing behavior (no functional changes)
- Run tests before and after refactoring
- Extract repeated logic into shared utilities
- Simplify complex conditionals
- Reduce function arguments (use options objects for 3+ params)
