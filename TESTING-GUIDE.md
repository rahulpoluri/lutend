# Testing Guide - Running GitHub Actions Tests Locally

This guide shows you how to run all the GitHub Actions tests locally before pushing to ensure everything passes.

## Prerequisites

- Docker and Docker Compose installed
- Python 3.10+ with [uv](https://docs.astral.sh/uv/) installed
- Node.js 18+ and PNPM 8+ installed
- All dependencies installed (`pnpm install`)

## Quick Test All

Run all tests at once:

```bash
# Run all tests in sequence
./scripts/test-all-local.sh
```

Or manually run each test suite:

```bash
# 1. Lint everything
pnpm lint
pnpm lint:backend

# 2. Test backend
cd backend && uv run bash scripts/tests-start.sh "Local test"

# 3. Test Docker Compose
docker compose build
docker compose up -d --wait backend admin adminer
curl http://localhost:8000/api/v1/utils/health-check
curl http://localhost:5173
docker compose down -v --remove-orphans

# 4. Run Playwright tests (optional, takes longer)
docker compose run --rm playwright npx playwright test
```

## Individual Test Suites

### 1. Lint Backend

**What it tests:** Python code quality using ruff

```bash
cd backend
uv run bash scripts/lint.sh
```

**Equivalent to:** `.github/workflows/lint-backend.yml`

### 2. Test Backend

**What it tests:** Backend unit and integration tests with pytest

```bash
# Start required services
docker compose up -d db mailcatcher

# Run migrations
cd backend
uv run bash scripts/prestart.sh

# Run tests with coverage
uv run bash scripts/tests-start.sh "Local test run"

# Stop services
docker compose down -v --remove-orphans
```

**Equivalent to:** `.github/workflows/test-backend.yml`

**View coverage report:**

```bash
open backend/htmlcov/index.html  # macOS
xdg-open backend/htmlcov/index.html  # Linux
```

### 3. Test Docker Compose

**What it tests:** Docker Compose stack builds and services start correctly

```bash
# Build all services
docker compose build

# Clean up any existing containers
docker compose down -v --remove-orphans

# Start services and wait for them to be ready
docker compose up -d --wait backend admin adminer

# Test backend health
curl http://localhost:8000/api/v1/utils/health-check

# Test admin is serving
curl http://localhost:5173

# Clean up
docker compose down -v --remove-orphans
```

**Equivalent to:** `.github/workflows/test-docker-compose.yml`

### 4. Playwright E2E Tests

**What it tests:** End-to-end user flows in the admin dashboard

**First time setup - Install browsers:**

```bash
cd admin
npx playwright install
```

**Run tests via Docker (recommended for CI-like environment):**

```bash
# Build and start all services
docker compose build
docker compose up -d

# Run Playwright tests
docker compose run --rm playwright npx playwright test

# View test results
open admin/playwright-report/index.html  # macOS
```

**Run tests locally (faster for development):**

```bash
# Start backend services
docker compose up -d backend db

# Run tests locally
cd admin
npx playwright test

# Run in UI mode for debugging
npx playwright test --ui
```

**Equivalent to:** `.github/workflows/playwright.yml`

**Run specific test:**

```bash
docker compose run --rm playwright npx playwright test tests/login.spec.ts
```

### 5. Generate Client

**What it tests:** API client generation from OpenAPI spec

```bash
# From root directory
bash scripts/generate-client.sh

# Or manually
cd backend
uv run python -c "import app.main; import json; print(json.dumps(app.main.app.openapi()))" > ../openapi.json
cd ../admin
npm run generate-client
```

**Equivalent to:** `.github/workflows/generate-client.yml`

### 6. Lint Frontend/Admin

**What it tests:** Frontend code quality using Biome

```bash
pnpm lint:admin
# or
cd admin
npm run lint
```

## Using Act (Run GitHub Actions Locally)

You can use [act](https://github.com/nektos/act) to run the actual GitHub Actions workflows locally:

### Install Act

```bash
# macOS
brew install act

# Linux
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Windows (with Chocolatey)
choco install act-cli
```

### Run Workflows with Act

```bash
# List all workflows
act -l

# Run all workflows
act

# Run specific workflow
act -j test-backend
act -j lint-backend
act -j test-docker-compose

# Run on specific event
act pull_request
act push
```

**Note:** Act runs workflows in Docker containers, so it may take longer and use more resources.

## Pre-Push Checklist

Before pushing code, run these commands to ensure CI will pass:

```bash
# 1. Lint all code
pnpm lint
pnpm lint:backend

# 2. Run backend tests
cd backend
docker compose up -d db mailcatcher
uv run bash scripts/prestart.sh
uv run bash scripts/tests-start.sh "Pre-push test"
cd ..

# 3. Test Docker Compose builds
docker compose build
docker compose up -d --wait backend admin
curl http://localhost:8000/api/v1/utils/health-check
docker compose down -v --remove-orphans

# 4. (Optional) Run Playwright tests
docker compose run --rm playwright npx playwright test
```

## Continuous Testing During Development

### Watch Mode for Backend Tests

```bash
cd backend
docker compose up -d db mailcatcher
uv run pytest --watch
```

### Watch Mode for Frontend

```bash
pnpm dev:admin
# Biome linting runs automatically in your IDE
```

## Troubleshooting

### Tests Fail Locally But Pass in CI

1. **Clean Docker state:**

   ```bash
   docker compose down -v --remove-orphans
   docker system prune -af
   ```

2. **Reinstall dependencies:**

   ```bash
   pnpm install
   cd backend && uv sync
   ```

3. **Check environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with correct values
   ```

### Backend Tests Fail

1. **Database issues:**

   ```bash
   docker compose down -v  # -v removes volumes
   docker compose up -d db
   cd backend && uv run bash scripts/prestart.sh
   ```

2. **Port conflicts:**
   ```bash
   # Check if ports are in use
   lsof -i :8000  # Backend
   lsof -i :5432  # PostgreSQL
   lsof -i :5173  # Admin
   ```

### Playwright Tests Fail

1. **Update browsers:**

   ```bash
   cd admin
   npx playwright install
   ```

2. **Run in headed mode to see what's happening:**

   ```bash
   docker compose run --rm playwright npx playwright test --headed
   ```

3. **Generate new screenshots:**
   ```bash
   docker compose run --rm playwright npx playwright test --update-snapshots
   ```

## Performance Tips

### Speed Up Docker Builds

```bash
# Use BuildKit for faster builds
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
```

### Parallel Testing

```bash
# Run backend tests in parallel
cd backend
uv run pytest -n auto

# Run Playwright tests in parallel
docker compose run --rm playwright npx playwright test --workers=4
```

### Skip Slow Tests

```bash
# Skip Playwright tests during rapid development
docker compose up -d backend admin
# Work on backend/admin without running E2E tests
```

## CI/CD Pipeline Overview

The full CI/CD pipeline runs these checks:

1. **Lint Backend** - Code quality checks
2. **Test Backend** - Unit and integration tests
3. **Lint Frontend** - Admin dashboard code quality
4. **Test Docker Compose** - Stack integration test
5. **Playwright Tests** - E2E user flows
6. **Generate Client** - API client generation

All must pass before merging to master.
