# /validate — Run the full AI agent validation pipeline

**Usage:** `/validate [file_path_or_description]`

This command runs the complete agent pipeline for any code change, feature, or fix. It starts by collecting all context once, then runs every selected specialist agent in order.

---

## What Happens

### Step 1 — Context Collection (always first)

Invoke the **Context Collector Agent** (`.ai-agents/agents/context-collector-agent.md`).

Ask the user for:

1. The **JIRA ticket ID** (e.g. `PROJ-123`) — extract Summary, Acceptance Criteria, Ticket Type, Priority
2. A brief **change description** — what the code does and what problem it solves
3. Which **agents to run** — present the checklist:
   - [ ] Review Agent
   - [ ] Security Agent
   - [ ] Testing Agent
   - [ ] Performance Agent
   - [ ] Architecture Agent
   - [ ] Documentation Agent
4. Any **specific focus areas** — e.g. auth logic, DB queries, error handling
5. **Agent-specific context** — only for selected agents (test framework, trust boundary, latency targets, etc.)

Produce the **Context Package** before proceeding to Step 2.

---

### Step 2 — Run Selected Agents in Order

Pass the Context Package to each selected agent. Run in this order:

```
Review → Security → Performance → Testing → Architecture → Documentation
```

Each agent uses the Context Package directly. No additional questions are asked.

| Agent         | Definition                                 |
| ------------- | ------------------------------------------ |
| Review        | `.ai-agents/agents/review-agent.md`        |
| Security      | `.ai-agents/agents/security-agent.md`      |
| Performance   | `.ai-agents/agents/performance-agent.md`   |
| Testing       | `.ai-agents/agents/testing-agent.md`       |
| Architecture  | `.ai-agents/agents/architecture-agent.md`  |
| Documentation | `.ai-agents/agents/documentation-agent.md` |

---

### Step 3 — Final Summary

After all selected agents complete, produce a consolidated summary:

```markdown
## Validation Summary

**JIRA Ticket:** [PROJ-123] — [Summary]
**Agents Run:** Review, Security, Testing

| Agent    | Verdict | Blocking Issues |
| -------- | ------- | --------------- |
| Review   | ✅ PASS | 0               |
| Security | ❌ FAIL | 1 Critical      |
| Testing  | ✅ PASS | 0               |

### Overall Result: ❌ FAIL — 1 blocking issue must be resolved before merge.

### Action Items

1. [Critical] [Security] — [description of issue and fix]
```

---

## Quick Usage Examples

```
/validate
/validate src/modules/auth/login-service
/validate PROJ-456
```

If a file path is provided, pre-fill it as the change scope.
If a JIRA ticket ID is provided, use it to skip Step 1 question 1.
