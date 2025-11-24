#!/usr/bin/env bash

# Quick test script - runs fast checks only
# Use this for rapid feedback during development

set -e

echo "🚀 Running quick tests..."
echo ""

# 1. Lint all code
echo "▶ Linting..."
pnpm lint
cd backend && uv run bash scripts/lint.sh
cd ..

# 2. Type check
echo ""
echo "▶ Type checking..."
pnpm run type-check

# 3. Quick backend tests (no coverage)
echo ""
echo "▶ Running backend tests..."
docker compose up -d db mailcatcher > /dev/null 2>&1
sleep 2
cd backend
uv run bash scripts/prestart.sh > /dev/null 2>&1
uv run pytest -x  # Stop on first failure
cd ..

echo ""
echo "✓ Quick tests passed!"
