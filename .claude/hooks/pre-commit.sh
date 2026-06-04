#!/bin/bash
# Pre-commit hook: Run linting and type checking before allowing commits

echo "🔍 Running pre-commit checks..."

# Run TypeScript type checking
if command -v tsc &> /dev/null; then
  echo "  → Type checking..."
  tsc --noEmit
  if [ $? -ne 0 ]; then
    echo "❌ Type errors found. Fix before committing."
    exit 1
  fi
fi

# Run linter
if command -v eslint &> /dev/null; then
  echo "  → Linting..."
  eslint --quiet .
  if [ $? -ne 0 ]; then
    echo "❌ Lint errors found. Fix before committing."
    exit 1
  fi
fi

echo "✅ All checks passed."
