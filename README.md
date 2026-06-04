# Agentic Hub

A centralized repository of **AI Rules** and **Agents** designed to work across multiple AI-powered IDEs — GitHub Copilot, Claude Code, and Cursor.

## Overview

This project demonstrates how to structure, write, and use AI rules and agents to enforce coding standards, automate workflows, and maintain consistency across teams. The architecture follows a **"central brain"** pattern: canonical rules live in `ai-agents/`, with platform-specific adapters in `.github/`, `.claude/`, and `.cursor/`.

---

## Repository Structure

```
├── 📄 CLAUDE.md                          ← [CLAUDE CODE] Auto-loaded every session
├── 📄 AGENTS.md                          ← [BOTH] Shared agent instructions
│
├── 📂 .claude/                           ← [CLAUDE CODE] Config directory
│     ├── settings.json                   ← Shared settings (commit this)
│     ├── agents/                         ← Custom subagents
│     ├── commands/                       ← Custom slash commands
│     ├── hooks/                          ← Tool event scripts
│     └── skills/                         ← Project-scoped on-demand skills
│
├── 📂 .github/                           ← [COPILOT] GitHub config
│     ├── 📄 copilot-instructions.md      ← Always-on repo-wide rules
│     ├── 📂 instructions/                ← Path-scoped rules (applyTo globs)
│     │     ├── frontend.instructions.md
│     │     └── backend.instructions.md
│     └── 📂 agents/                      ← On-demand Copilot agents
│           └── test-agent.agent.md
│
├── 📂 .cursor/                           ← [CURSOR] Rules directory
│     └── 📂 rules/                       ← .mdc files (NOT .cursorrules)
│           ├── global.mdc
│           └── ui-rules.mdc
│
├── 📂 .vscode/                           ← [VS CODE] Workspace settings
│     ├── settings.json
│     └── extensions.json
│
└── 📂 ai-agents/                         ← THE CENTRAL BRAIN (platform-agnostic)
      ├── 📂 rules/                        ← Core logic in Markdown
      │     ├── ui-standards.md
      │     └── testing-logic.md
      ├── 📂 prompts/                      ← Reusable prompt templates
      └── 📂 examples/                     ← Gold-standard code snippets
```

---

## How It Works

### The Central Brain (`ai-agents/`)

The `ai-agents/` directory contains platform-agnostic rules and prompts. This is the **single source of truth** — platform-specific configs reference or adapt from here.

| Directory             | Purpose                                           |
| --------------------- | ------------------------------------------------- |
| `ai-agents/rules/`    | Core coding standards (UI, testing, architecture) |
| `ai-agents/prompts/`  | Reusable prompt templates for common tasks        |
| `ai-agents/examples/` | Gold-standard code snippets AI should emulate     |

### Platform Adapters

Each IDE has its own config format. The adapters translate central rules into platform-specific syntax:

| Platform       | Config Location         | Format                          |
| -------------- | ----------------------- | ------------------------------- |
| GitHub Copilot | `.github/`              | `.instructions.md`, `.agent.md` |
| Claude Code    | `.claude/`, `CLAUDE.md` | Markdown, JSON                  |
| Cursor         | `.cursor/rules/`        | `.mdc` files                    |

---

## Demo & Usage

### 1. Rules (Always-On Instructions)

Rules are loaded automatically and guide AI behavior for every interaction.

#### GitHub Copilot — Workspace Rule

File: `.github/copilot-instructions.md`

```markdown
# GitHub Copilot Instructions

## General Coding Rules

- Write clean, readable, and maintainable code
- Use early returns to reduce nesting
- All public APIs must have TypeScript types

## Security

- Never hardcode secrets or credentials
- Use parameterized queries for database operations
```

#### GitHub Copilot — Scoped Rule

File: `.github/instructions/frontend.instructions.md`

```markdown
---
applyTo: "src/frontend/**,**/*.tsx,**/*.jsx"
---

# Frontend Instructions

- Use functional components with hooks
- Ensure accessible contrast ratios (WCAG AA)
- Lazy load routes and heavy components
```

#### Claude Code — Auto-Loaded Rule

File: `CLAUDE.md` (loaded automatically every session)

```markdown
# CLAUDE.md

- Use TypeScript for all new code
- Keep functions under 30 lines
- Commit messages: type(scope): description
```

#### Cursor — MDC Rule

File: `.cursor/rules/global.mdc`

```markdown
---
description: Global rules for all files
globs: "**/*"
alwaysApply: true
---

# Global Rules

- Use self-documenting code with clear naming
- No `any` types — use `unknown` and narrow
- Prefer named exports over default exports
```

---

### 2. Agents (On-Demand AI Personas)

Agents are invoked explicitly and have specific roles, tools, and behavioral instructions.

#### GitHub Copilot Agent

File: `.github/agents/test-agent.agent.md`

```markdown
---
name: "Test Agent"
description: "Generates and maintains test suites"
tools:
  - read_file
  - create_file
  - run_in_terminal
---

# Test Agent

You are a testing specialist. Analyze source files and generate
comprehensive tests covering happy paths, edge cases, and errors.
```

**Usage in VS Code Chat:**

```
@test-agent Generate tests for src/services/user-service.ts
```

#### Claude Code Agent

File: `.claude/agents/code-reviewer.md`

```markdown
# Code Review Subagent

You are a code review specialist. When invoked:

1. Read the specified files or diff
2. Analyze for security, performance, and style issues
3. Provide structured feedback with severity levels
```

**Usage in Claude Code:**

```
/review src/api/auth-controller.ts
```

#### Shared Agents (Cross-Platform)

File: `AGENTS.md` — defines agents recognized by both Claude Code and Copilot:

```markdown
## Code Reviewer

**Role:** Senior code reviewer
**Output:** Critical / Warning / Suggestion

## Test Generator

**Role:** Generates comprehensive test suites

## Docs Writer

**Role:** Technical documentation specialist
```

---

### 3. Slash Commands (Claude Code)

Custom commands defined in `.claude/commands/`:

```bash
# Run a code review
/review src/services/

# Generate tests
/gen-tests src/utils/validator.ts --coverage=full
```

---

### 4. Prompt Templates (`ai-agents/prompts/`)

Reusable templates for common tasks:

```markdown
## Code Review Prompt

Review the following code for:

1. Security vulnerabilities (OWASP Top 10)
2. Performance issues
3. Error handling completeness
   ...

## Bug Fix Prompt

**Expected:** {{EXPECTED}}
**Actual:** {{ACTUAL}}
Please identify root cause and provide a fix.
```

---

## Getting Started

### Quick Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/codal-georgem/agentic-hub-codal.git
   ```

2. **Open in VS Code** with GitHub Copilot extension installed.

3. **Rules activate automatically** — Copilot will follow `.github/copilot-instructions.md` for all code generation.

4. **Invoke agents** by typing `@test-agent` in VS Code Chat.

### Adapting for Your Project

1. Copy the directories you need (`.github/`, `.claude/`, `.cursor/`, `ai-agents/`) into your project.
2. Edit `ai-agents/rules/` to match your team's standards.
3. Update platform adapters to reference your rules.
4. Add project-specific agents for your workflows.

### Adding a New Rule

1. Write the canonical rule in `ai-agents/rules/your-rule.md`
2. Create platform adapters:
   - `.github/instructions/your-rule.instructions.md` (with `applyTo` frontmatter)
   - `.cursor/rules/your-rule.mdc` (with `globs` frontmatter)
   - Reference in `CLAUDE.md` context section

---

## Platform Comparison

| Feature           | GitHub Copilot            | Claude Code        | Cursor                     |
| ----------------- | ------------------------- | ------------------ | -------------------------- |
| Auto-loaded rules | `copilot-instructions.md` | `CLAUDE.md`        | `global.mdc` (alwaysApply) |
| Scoped rules      | `applyTo` globs           | N/A                | `globs` in frontmatter     |
| Agents            | `.agent.md` files         | `agents/` folder   | N/A                        |
| Slash commands    | N/A                       | `commands/` folder | N/A                        |
| Hooks             | N/A                       | `hooks/` folder    | N/A                        |
| Skills            | N/A                       | `skills/` folder   | N/A                        |

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your rules or agents (follow the central brain pattern)
4. Submit a pull request

---

## License

MIT
