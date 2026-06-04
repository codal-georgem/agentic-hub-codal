# Testing Rules

> Testing standards enforced by the Testing Agent. All code must meet these criteria.

## Core Rules

- All APIs require unit tests
- Cover positive (happy path) and negative (failure) scenarios
- Add edge case validation for every function
- Mock all external services and dependencies
- Minimum **80% code coverage** for all modules
- Regression tests required for every bug fix
- Tests must be independent — no shared mutable state between tests
- No flaky tests — fix or delete immediately

## Coverage Requirements

| Layer                | Minimum             | Target        |
| -------------------- | ------------------- | ------------- |
| Unit Tests           | 80%                 | 90%           |
| Integration Tests    | 60%                 | 75%           |
| Critical Paths (E2E) | 100% of happy paths | + error paths |

## Testing Philosophy

- **Test behavior, not implementation** — Refactoring should not break tests
- **Tests are documentation** — A new developer should understand the system by reading tests
- **Fast feedback** — Unit tests run in < 5 seconds; full suite in < 60 seconds
- **Deterministic** — No flaky tests; fix or delete them immediately

## Test Structure

### Naming Convention

Use a clear, hierarchical naming structure:

```
[Module / Component]
  [Function / Method]
    should [expected behavior] when [condition]
    should throw [ErrorType] when [condition]
```

Examples:

- `UserService > createUser > should create a user with valid input`
- `UserService > createUser > should throw ValidationError when email is invalid`

### AAA Pattern (Arrange, Act, Assert)

Structure every test in three distinct phases:

1. **Arrange** — Set up inputs, mocks, and preconditions
2. **Act** — Execute the function or behavior under test
3. **Assert** — Verify the output or side effect matches expectations

Keep each phase clearly separated. Avoid mixing setup logic with assertions.

## What to Test

### Always Test

- Happy path (valid input → expected output)
- Boundary values (0, 1, max, min)
- Error cases (invalid input, missing data, network failures)
- Edge cases (empty arrays, null/undefined, special characters)
- Authorization (can vs. cannot access)
- State transitions (pending → active → cancelled)

### Never Test

- Framework internals (routing, rendering lifecycle, ORM internals)
- Third-party library behavior
- Private methods directly (test through public API)
- Trivial getters/setters with no logic
- Implementation details (internal state, private variables)

## Mocking Rules

- ✅ Mock external dependencies (external APIs, databases, file system, message queues)
- ✅ Mock at boundaries — replace the outermost adapter, not internal logic
- ❌ Don't mock the system under test
- ❌ Don't mock internal domain logic or value objects
- ❌ Don't mock pure utility functions that have no side effects

### Mock Hierarchy

| Dependency Type  | Approach                               |
| ---------------- | -------------------------------------- |
| External API     | Mock at the HTTP/transport layer       |
| Database         | Use a test database or in-memory DB    |
| File system      | Use a mock or temporary directory      |
| Time/Date        | Use fake/controlled timers             |
| Random/UUID      | Seed the generator or use fixed values |
| Internal service | Prefer real implementation             |

## Test Quality Checklist

- [ ] Each test has a single assertion focus (one logical concept)
- [ ] Test names describe the scenario clearly
- [ ] No test depends on another test's state
- [ ] Tests can run in any order
- [ ] No hardcoded timeouts (use fake timers)
- [ ] Assertions are specific (`toEqual` over `toBeTruthy`)
- [ ] Error messages are tested (not just that error was thrown)
- [ ] Async tests properly await or return promises

## Anti-Patterns to Avoid

| Anti-Pattern            | Problem                   | Fix                     |
| ----------------------- | ------------------------- | ----------------------- |
| Test per method         | Missing behavior coverage | Test per behavior       |
| Giant setup             | Hard to understand        | Factory functions       |
| Shared mutable state    | Tests interfere           | Fresh setup per test    |
| Testing private methods | Brittle tests             | Test through public API |
| Snapshot overuse        | Meaningless diffs         | Targeted assertions     |
| Commented-out tests     | Hidden failures           | Delete or fix           |

## Integration Test Standards

- Reset test data before each test to ensure isolation
- Test the full request/response cycle through real endpoints
- Verify both the response payload and any persisted side effects
- Cover the happy path, validation failures, conflict scenarios, and auth failures
- Use a dedicated test database or in-memory store — never the production database

      // Verify side effects
      const saved = await db.findOne("users", { email: "test@example.com" });
      expect(saved).not.toBeNull();

  });

  it("should return 409 when email exists", async () => {
  await db.insert("users", { email: "test@example.com", name: "Existing" });

      await request(app)
        .post("/api/users")
        .send({ email: "test@example.com", name: "Duplicate" })
        .expect(409);

  });
  });

```

```
