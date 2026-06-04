# CLAUDE.md — Auto-loaded Instructions for Claude Code

> This file is automatically loaded at the start of every Claude Code session.
> It defines the project context, coding standards, and behavioral rules.

## Project Overview

This is the **Agentic Hub** — a centralized repository of AI rules, agents, and prompt templates designed to work across multiple AI-powered IDEs (GitHub Copilot, Claude Code, Cursor).

## Coding Standards

- Use TypeScript for all new code
- Follow functional programming patterns where possible
- Use descriptive variable names (`getUserById` not `getUser`)
- All async functions must have proper error handling
- Keep functions under 30 lines; extract helpers for complex logic

## File Conventions

- Use kebab-case for file names: `user-service.ts`
- Use PascalCase for classes and types: `UserService`, `ApiResponse`
- Use camelCase for variables and functions: `fetchUserData`
- Test files: `*.test.ts` adjacent to source files

## Git Conventions

- Commit messages: `type(scope): description`
- Types: feat, fix, docs, refactor, test, chore
- Keep commits atomic — one logical change per commit

## Architecture

```
ai-agents/          → Platform-agnostic core rules and prompts
.github/            → GitHub Copilot specific configuration
.claude/            → Claude Code specific configuration
.cursor/            → Cursor specific configuration
.vscode/            → VS Code workspace settings
```

## Important Rules

1. Never commit secrets or API keys
2. Always reference `ai-agents/rules/` for the canonical logic
3. Platform-specific files (`.github/`, `.claude/`, `.cursor/`) should import from `ai-agents/` where possible
4. When adding a new rule, add it to `ai-agents/rules/` first, then create platform adapters
