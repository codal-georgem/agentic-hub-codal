# Architecture Rules

> Architectural constraints enforced by the Architecture Agent. Violations block merge.

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────┐
│                  Presentation                    │  Controllers, Routes, Views
├─────────────────────────────────────────────────┤
│                  Application                     │  Services, Use Cases, DTOs
├─────────────────────────────────────────────────┤
│                    Domain                        │  Entities, Value Objects, Interfaces
├─────────────────────────────────────────────────┤
│                Infrastructure                    │  Repositories, External APIs, DB
└─────────────────────────────────────────────────┘
```

## Dependency Rules

### Allowed Dependencies (Inward Only)

| Layer          | Can Depend On                  | Cannot Depend On                  |
| -------------- | ------------------------------ | --------------------------------- |
| Presentation   | Application, Domain            | Infrastructure directly           |
| Application    | Domain                         | Presentation, Infrastructure impl |
| Domain         | Nothing                        | Any outer layer                   |
| Infrastructure | Domain (implements interfaces) | Presentation, Application         |

### Import Path Enforcement

| Dependency Direction                              | Status       |
| ------------------------------------------------- | ------------ |
| Presentation → Application                        | ✅ Allowed   |
| Application → Domain                              | ✅ Allowed   |
| Infrastructure → Domain (implementing interfaces) | ✅ Allowed   |
| Presentation → Infrastructure (layer skip)        | ❌ Forbidden |
| Domain → Infrastructure (outward dependency)      | ❌ Forbidden |
| Any layer → Presentation (upward dependency)      | ❌ Forbidden |

## Module Structure

### Standard Module Layout

```
src/modules/{module-name}/
├── {module}-controller     → HTTP / presentation handlers
├── {module}-service         → Business logic
├── {module}-repository      → Data access implementation
├── {module}-entity          → Domain entity / model
├── {module}-dto             → Request/Response shapes
├── {module}-types           → Module-specific types
├── {module}-module          → Dependency registration
├── {module}-constants       → Module constants
└── tests/
    ├── {module}-service-test
    ├── {module}-controller-test
    └── {module}-e2e-test
```

### Module Boundaries

- Each module encapsulates a bounded context
- Cross-module communication uses public interfaces only
- Shared code goes in `src/shared/` (utilities, guards, decorators)
- No direct database access from outside the owning module

## API Design Rules

### RESTful Conventions

| Action  | Method | Path           | Status |
| ------- | ------ | -------------- | ------ |
| List    | GET    | /resources     | 200    |
| Get     | GET    | /resources/:id | 200    |
| Create  | POST   | /resources     | 201    |
| Update  | PUT    | /resources/:id | 200    |
| Partial | PATCH  | /resources/:id | 200    |
| Delete  | DELETE | /resources/:id | 204    |

### Request/Response Patterns

All API responses must use a consistent envelope. See `.ai-agents/rules/api-rules.md` for the full format.

Success:

```json
{ "data": { ... } }
```

Error:

```json
{ "error": { "code": "...", "message": "...", "details": [...] } }
```

## Dependency Injection

- ✅ Depend on **abstractions** (interfaces, protocols, abstract classes), not concrete implementations
- ✅ Inject dependencies through constructors or a DI container
- ❌ Do not instantiate infrastructure dependencies (databases, HTTP clients, queues) directly inside domain or application classes
- ❌ Do not import specific vendor SDKs into the domain layer

## Event-Driven Communication

For cross-module interactions, prefer events over direct calls:

- ✅ Publish domain events after completing core business logic (e.g., `order.created`, `user.registered`)
- ✅ Let other modules subscribe to events independently — no direct coupling
- ❌ Do not call another module's service directly from within your module's service layer
- ❌ Do not chain multiple service calls across bounded contexts in a single transaction
  }
  }

```

## Scaling Considerations

- Stateless services (no in-memory state between requests)
- Database connections via pool (not per-request)
- Cache with explicit TTL and invalidation strategy
- Async processing for operations > 500ms
- Circuit breakers for external service calls
```
