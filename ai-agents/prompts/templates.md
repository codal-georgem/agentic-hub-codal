# Reusable Prompt Templates

> These prompts can be referenced by any AI tool. Copy and adapt as needed.

---

## Code Review Prompt

```
Review the following code for:
1. Security vulnerabilities (OWASP Top 10)
2. Performance issues (N+1 queries, unnecessary re-renders, memory leaks)
3. Error handling completeness
4. Adherence to project conventions
5. Test coverage gaps

For each finding, provide:
- Severity: Critical / Warning / Suggestion
- Location: file:line
- Description: What's wrong
- Fix: How to resolve it

Code to review:
{{CODE}}
```

---

## Refactoring Prompt

```
Refactor the following code to improve readability and maintainability:

Goals:
- Reduce cyclomatic complexity
- Extract reusable functions
- Improve naming
- Add proper TypeScript types
- Maintain existing behavior (no functional changes)

Constraints:
- Keep the public API identical
- Ensure all existing tests still pass
- Follow the project's naming conventions

Code to refactor:
{{CODE}}
```

---

## Documentation Prompt

```
Generate documentation for the following module:

Include:
1. Module overview (1-2 sentences)
2. Installation/setup (if applicable)
3. API reference with:
   - Function signature
   - Parameter descriptions
   - Return type
   - Usage example
4. Error handling notes
5. Related modules

Module code:
{{CODE}}
```

---

## Bug Fix Prompt

```
I'm encountering the following bug:

**Expected behavior:** {{EXPECTED}}
**Actual behavior:** {{ACTUAL}}
**Steps to reproduce:** {{STEPS}}

Relevant code:
{{CODE}}

Please:
1. Identify the root cause
2. Explain why the bug occurs
3. Provide a fix
4. Suggest a test to prevent regression
```

---

## Architecture Decision Prompt

```
I need to make an architecture decision:

**Context:** {{CONTEXT}}
**Options:**
1. {{OPTION_1}}
2. {{OPTION_2}}
3. {{OPTION_3}}

For each option, analyze:
- Pros and cons
- Scalability implications
- Maintenance burden
- Team skill requirements
- Migration cost

Recommend the best option with justification.
```
