# Architecture Prompt

> Prompt template used by the Architecture Agent to validate structural decisions.

## System Prompt

```
You are a software architect with expertise in:
- Clean Architecture and Domain-Driven Design
- Microservices and modular monolith patterns
- API design and versioning strategies
- Database design and query optimization
- Event-driven architectures

You enforce architectural boundaries and ensure code changes don't introduce
structural debt. You think in terms of coupling, cohesion, and changeability.
```

## Architecture Review Prompt

````
Review the following code change for architectural compliance.

## Context
- **Module:** {{MODULE_NAME}}
- **Change Type:** {{NEW_MODULE | MODIFICATION | CROSS_MODULE}}
- **Affected Layers:** {{LAYERS}}

## Architecture Rules
Reference: .ai-agents/rules/architecture-rules.md

## Validate

### Layer Compliance
- Does code respect layer boundaries (Presentation → Application → Domain → Infrastructure)?
- Are dependencies pointing inward only?
- Is business logic in the correct layer?

### Module Boundaries
- Does the change respect module encapsulation?
- Are cross-module interactions through defined interfaces?
- Any circular dependencies introduced?

### Dependency Direction
- Are abstractions defined in inner layers?
- Do outer layers implement inner layer interfaces?
- No concrete infrastructure imports in domain?

### API Design
- Does the endpoint follow RESTful conventions?
- Is the response format consistent with existing APIs?
- Are breaking changes properly versioned?

### Coupling Analysis
- Afferent coupling (Ca): How many modules depend on this?
- Efferent coupling (Ce): How many modules does this depend on?
- Instability (I = Ce / (Ca + Ce)): Is this appropriately stable?

## Code to Review
```{{LANGUAGE}}
{{CODE}}
````

## File Structure

```
{{FILE_TREE}}
```

## Expected Output

### Compliance Score: {{X}}/10

### Violations Found

For each violation:

1. **Rule:** Which architectural rule is broken
2. **Location:** file:line
3. **Impact:** Why this matters (coupling, testability, changeability)
4. **Fix:** How to restructure

### Dependency Graph

Show the dependency flow of the changed code:

```
ModuleA → ModuleB → SharedModule
    ↓
ModuleC (❌ circular)
```

### Recommendations

- Structural changes needed
- Suggested module boundaries
- Refactoring opportunities

```

## New Module Design Prompt

```

Design the architecture for a new module.

## Requirements

{{REQUIREMENTS}}

## Constraints

- Must integrate with existing modules: {{EXISTING_MODULES}}
- Must follow project architecture rules
- Must support future extensions: {{FUTURE_NEEDS}}

## Output

1. Module structure (files and responsibilities)
2. Public interface (what other modules can access)
3. Internal architecture (services, repos, entities)
4. Integration points (events, API calls, shared types)
5. Database schema changes needed
6. Migration strategy (if modifying existing data)

```

## Dependency Analysis Prompt

```

Analyze the dependency graph of this codebase for structural risks.

## Focus On

1. Circular dependencies between modules
2. God modules (too many dependents)
3. Unstable modules with many dependents
4. Layer violations
5. Tight coupling between unrelated features

## File List

{{FILE_LIST_WITH_IMPORTS}}

## Output

- Dependency graph visualization
- Risk score per module
- Recommended refactoring steps (ordered by impact)

```

```
