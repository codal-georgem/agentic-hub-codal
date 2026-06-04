# /gen-tests — Generate tests for a file or function

Usage: /gen-tests [file_path] [--coverage=full|critical]

Generate comprehensive test suites for the specified file.
Follow the testing conventions in `ai-agents/rules/testing-logic.md`.

Options:

- `--coverage=full` — Test all code paths (default)
- `--coverage=critical` — Test only critical/happy paths
