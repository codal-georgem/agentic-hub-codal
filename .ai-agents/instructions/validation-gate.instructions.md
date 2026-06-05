---
description: "Use when making any code change — bug fix, feature, refactor, test update, or file modification. Enforces JIRA classification, context collection, test creation, security review, and mandatory final output with AI Agent Quality Matrix."
applyTo: "**"
---

## Mandatory Workflow For Every Code Change

This workflow is mandatory for every code-change request. Do not skip any step.

A code-change request includes:
- bug fixes
- new features
- refactors
- test updates
- file modifications
- implementation tasks

If the user is only asking a question and not requesting code changes, this workflow does not apply.

### Step 1: Classify the Request

Before making any code change, you MUST classify the request.

Ask:
"Is this related to a JIRA ticket or is it a normal change?"

If it is a JIRA ticket, you MUST gather:
- ticket ID
- ticket title and description
- acceptance criteria
- affected files or components
- reproduction steps if it is a bug

If it is a normal change, proceed using the user's request.

You MUST NOT start coding until this classification is complete.

### Step 2: Context Collection

Before writing or modifying code, you MUST:
- read the relevant source files
- read the relevant tests
- understand existing patterns and data flow
- map requirements to affected files
- identify all source and test files that need changes

You MUST NOT make code changes before completing this context review.

### Step 3: Implement Code Changes

You MUST implement the required changes following existing project conventions.

Prefer:
- root-cause fixes
- minimal, focused changes
- consistency with existing architecture

You MUST NOT make unrelated changes.

### Step 4: Update or Create Tests

After code changes, you MUST update or create relevant tests.

Requirements:
- cover positive scenarios
- cover negative scenarios
- cover edge cases where relevant

If the change is linked to JIRA acceptance criteria, you MUST map each acceptance criterion to at least one test.

If the repository has a test runner, you MUST run the narrowest relevant tests.
If tests cannot be run, you MUST explicitly state why.

### Step 5: Security and Code Review

After implementation and tests, you MUST perform:
- a security review
- a correctness and code-quality review

Read and follow `.ai-agents/rules/security-rules.md` for security rules.
Read and follow `.ai-agents/rules/testing-rules.md` for test standards.

You MUST fix any issues found before finalizing.

### Step 6: Mandatory Final Output

For every code-change request, you MUST end with all of the following sections in this exact order.

## Summary
- what changed

## Tests
- tests added or updated
- tests run
- if not run, state why

## Security Review
- checks performed
- any remaining risks

## AI Agent Quality Matrix
| Dimension      | Score | Notes                              |
| -------------- | ----- | ---------------------------------- |
| Code Quality   | X/10  | Readability, conventions, patterns |
| Security       | X/10  | Auth, secrets, input validation    |
| Performance    | X/10  | Efficiency, caching, bundle impact |
| Test Coverage  | X/10  | Positive/negative cases, edge cases|
| Scalability    | X/10  | Maintainability, extensibility     |

## Final Result
- PASS, FAIL, or BLOCKED
- one-line reason

You MUST NOT omit any of these sections.
If a section has no content, write "None".
If blocked, you MUST still print all sections and mark the final result as BLOCKED.
