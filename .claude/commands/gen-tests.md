# /gen-tests — Generate tests for a file or module

**Usage:** `/gen-tests [file_path] [--coverage=full|critical]`

For a full multi-agent pipeline, use `/validate` instead.

---

## What Happens

### Step 1 — Context Collection

Invoke the **Context Collector Agent** (`.ai-agents/agents/context-collector-agent.md`) with scope limited to the Testing Agent.

Ask the user for:

1. **JIRA ticket ID** (e.g. `PROJ-123`) — extract Acceptance Criteria to map to test scenarios
2. **What the function/module does** — responsibility and expected behaviour
3. **Testing framework** the project uses
4. **External dependencies to mock** — database, APIs, file system, queues
5. **Existing test coverage** — what paths are already covered

Produce the **Context Package** before proceeding.

### Step 2 — Testing Agent

Pass the Context Package to the **Testing Agent** (`.ai-agents/agents/testing-agent.md`).

The agent will:

- Map each Acceptance Criteria item to one or more test scenarios
- Draft the full test plan internally and verify AC coverage before writing output
- Generate unit, integration, and/or E2E tests as specified
- Output an AC coverage table alongside the generated tests

Follow testing conventions in `.ai-agents/rules/testing-rules.md`.

---

## Options

- `--coverage=full` — Test all code paths (default)
- `--coverage=critical` — Test only critical/happy paths
