# CLAUDE.md — Auto-loaded Instructions for Claude Code

> This file is automatically loaded at the start of every Claude Code session.
> It defines the project context, coding standards, and behavioral rules.

## Project Overview

This is the **Agentic Hub** — a centralized repository of AI rules, agents, and prompt templates designed to work across multiple AI-powered IDEs (GitHub Copilot, Claude Code, Cursor).

## Coding Standards

- Use the language appropriate to the platform; prefer typed languages where available
- Follow functional programming patterns where possible
- Use descriptive variable names (`getUserById` not `getUser`)
- All async functions must have proper error handling
- Keep functions under 30 lines; extract helpers for complex logic

## File Conventions

- Use kebab-case for file names: `user-service`
- Use PascalCase for classes and types: `UserService`, `ApiResponse`
- Use camelCase for variables and functions: `fetchUserData`
- Test files: consistent test naming convention, adjacent to source files

## Git Conventions

- Commit messages: `type(scope): description`
- Types: feat, fix, docs, refactor, test, chore
- Keep commits atomic — one logical change per commit

## Architecture

```
.ai-agents/         → AI Run Agents: agents, rules, prompts, workflows
  agents/           → Context Collector, Review, Security, Testing, Performance, Architecture, Documentation
  rules/            → Coding, Security, Testing, Architecture, API rules
  prompts/          → Reusable prompt templates per agent
  workflows/        → End-to-end validation pipelines
ai-agents/          → Platform-agnostic core rules and prompts (legacy)
.github/            → GitHub Copilot specific configuration
.claude/            → Claude Code specific configuration
.cursor/            → Cursor specific configuration
.vscode/            → VS Code workspace settings
```

## AI Run Agents

All code changes are validated by a pipeline of specialized agents defined in `.ai-agents/agents/`.
Always start with the **Context Collector Agent**, then invoke the specialist agents in order.

| Agent                 | File                                           | Responsibility                       |
| --------------------- | ---------------------------------------------- | ------------------------------------ |
| **Context Collector** | `.ai-agents/agents/context-collector-agent.md` | Gather JIRA + technical context once |
| Review Agent          | `.ai-agents/agents/review-agent.md`            | Code quality, logic, conventions     |
| Security Agent        | `.ai-agents/agents/security-agent.md`          | OWASP Top 10, secrets, auth          |
| Testing Agent         | `.ai-agents/agents/testing-agent.md`           | Test generation, 80% coverage        |
| Performance Agent     | `.ai-agents/agents/performance-agent.md`       | N+1 queries, latency, bundle size    |
| Architecture Agent    | `.ai-agents/agents/architecture-agent.md`      | Layer boundaries, coupling           |
| Documentation Agent   | `.ai-agents/agents/documentation-agent.md`     | Inline docs, API docs coverage       |

### Slash Commands

Use these commands directly in Claude Code chat:

| Command      | What it does                                                                 |
| ------------ | ---------------------------------------------------------------------------- |
| `/validate`  | **Full pipeline** — runs Context Collector then all selected agents in order |
| `/review`    | Code review only — Context Collector → Review Agent                          |
| `/gen-tests` | Test generation only — Context Collector → Testing Agent                     |

All commands start with the **Context Collector Agent** to gather JIRA context before acting.  
Full command definitions: `.claude/commands/`

### Workflows

- **Login API:** `.ai-agents/workflows/login-api-validation.md`
- **Frontend:** `.ai-agents/workflows/frontend-validation.md`

## Important Rules

1. Never commit secrets or API keys
2. Always reference `.ai-agents/rules/` for canonical coding, security, testing, and API standards
3. When adding a new rule, add it to `.ai-agents/rules/` first, then update platform adapters
4. Platform-specific files (`.github/`, `.claude/`, `.cursor/`) should reference `.ai-agents/` where possible
5. All AI-generated code must pass the Review Agent and Security Agent before merge
