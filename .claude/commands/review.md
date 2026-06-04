# /review — Run a focused code review

**Usage:** `/review [file_path_or_description]`

For a full multi-agent pipeline, use `/validate` instead.

---

## What Happens

### Step 1 — Context Collection

Invoke the **Context Collector Agent** (`.ai-agents/agents/context-collector-agent.md`) with scope limited to the Review Agent.

Ask the user for:

1. **JIRA ticket ID** (e.g. `PROJ-123`) — extract Summary, Acceptance Criteria, Ticket Type, Priority
2. **Change description** — what the code does and what problem it solves
3. **Known trade-offs or constraints** that should not be flagged as issues
4. **Specific focus areas** — e.g. error handling, concurrency, security

Produce the **Context Package** before proceeding.

### Step 2 — Review Agent

Pass the Context Package to the **Review Agent** (`.ai-agents/agents/review-agent.md`).

The agent will:

- Validate each Acceptance Criteria item (`✅ Met / ⚠️ Partially Met / ❌ Not Met`)
- Check for Critical, Warning, and Suggestion findings
- Flag any scope creep outside the JIRA ticket
- Apply rules from `.ai-agents/rules/coding-rules.md` and `.ai-agents/rules/architecture-rules.md`

Output the full review report with **Verdict: PASS ✅ or FAIL ❌**.
