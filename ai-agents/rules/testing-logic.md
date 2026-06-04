# Testing Logic

> Platform-agnostic testing rules. Referenced by all platform-specific configs.

## Testing Philosophy

- **Test behavior, not implementation** — Tests should validate what code does, not how it does it
- **Tests are documentation** — A new developer should understand the system by reading tests
- **Fast feedback** — Unit tests should run in < 5 seconds total
- **Deterministic** — No flaky tests allowed; fix or delete them

## Test Pyramid

```
        /  E2E  \          ← Few (critical user journeys)
       /----------\
      / Integration \      ← Some (API endpoints, DB queries)
     /----------------\
    /    Unit Tests     \  ← Many (business logic, utilities)
   /--------------------\
```

## Naming Convention

```typescript
describe("ModuleName", () => {
  describe("functionName", () => {
    it("should [expected behavior] when [condition]", () => {
      // Arrange → Act → Assert
    });
  });
});
```

## Test Structure (AAA Pattern)

```typescript
it("should calculate total with tax", () => {
  // Arrange
  const items = [{ price: 10 }, { price: 20 }];
  const taxRate = 0.1;

  // Act
  const total = calculateTotal(items, taxRate);

  // Assert
  expect(total).toBe(33); // (10 + 20) * 1.1
});
```

## What to Test

### Always Test

- Business logic and calculations
- Data transformations
- Validation rules
- Error handling paths
- Edge cases (empty arrays, null, boundary values)

### Integration Test

- API endpoint request/response contracts
- Database queries (use test database)
- Authentication/authorization flows
- Third-party service interactions (with mocks)

### E2E Test

- Critical user journeys (signup, checkout, etc.)
- Cross-page navigation flows
- Payment processing

## Mocking Rules

1. Only mock what you don't own (external APIs, databases)
2. Never mock the module under test
3. Reset mocks between tests (`beforeEach(() => vi.clearAllMocks())`)
4. Prefer dependency injection over module mocking
5. Use factories for complex test data:

```typescript
function createUser(overrides: Partial<User> = {}): User {
  return {
    id: "user-1",
    name: "Test User",
    email: "test@example.com",
    role: "member",
    createdAt: new Date("2024-01-01"),
    ...overrides,
  };
}
```

## Coverage Targets

| Category       | Target |
| -------------- | ------ |
| Business logic | >90%   |
| API endpoints  | >80%   |
| UI components  | >70%   |
| Utilities      | >95%   |
