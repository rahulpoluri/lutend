#!/usr/bin/env bash

# Script to run all GitHub Actions tests locally
# This mimics what runs in CI/CD

set -e  # Exit on error

echo "🧪 Running all GitHub Actions tests locally..."
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track failures
FAILED_TESTS=()

# Function to run a test and track results
run_test() {
    local test_name=$1
    local test_command=$2
    
    echo -e "${YELLOW}▶ Running: $test_name${NC}"
    if eval "$test_command"; then
        echo -e "${GREEN}✓ $test_name passed${NC}"
        echo ""
    else
        echo -e "${RED}✗ $test_name failed${NC}"
        FAILED_TESTS+=("$test_name")
        echo ""
    fi
}

# 1. Lint Frontend
run_test "Lint Frontend" "pnpm lint"

# 2. Lint Backend
run_test "Lint Backend" "(cd backend && uv run bash scripts/lint.sh)"

# 3. Test Backend
echo -e "${YELLOW}▶ Setting up backend tests...${NC}"

# Check if local PostgreSQL is running
if lsof -i :5432 2>/dev/null | grep -q postgres; then
    echo -e "${GREEN}✓ Using local PostgreSQL${NC}"
    # Just start mailcatcher, skip database
    docker compose up -d mailcatcher > /dev/null 2>&1
else
    echo -e "${YELLOW}▶ Starting Docker database and mailcatcher...${NC}"
    docker compose down -v --remove-orphans > /dev/null 2>&1
    docker compose up -d --wait db mailcatcher
    echo -e "${GREEN}✓ Database is ready${NC}"
    sleep 2  # Give database a moment to fully initialize
fi

run_test "Backend Tests" "(cd backend && uv run bash scripts/prestart.sh && uv run bash scripts/tests-start.sh 'Local test run')"

# 4. Test Docker Compose
echo -e "${YELLOW}▶ Testing Docker Compose stack...${NC}"
docker compose down -v --remove-orphans > /dev/null 2>&1
docker compose build > /dev/null 2>&1

run_test "Docker Compose Build" "docker compose up -d --wait backend admin adminer"
run_test "Backend Health Check" "curl -f http://localhost:8000/api/v1/utils/health-check"
run_test "Admin Service Check" "curl -f http://localhost:5173"

# Clean up
echo -e "${YELLOW}▶ Cleaning up...${NC}"
docker compose down -v --remove-orphans > /dev/null 2>&1

# Summary
echo ""
echo "=========================================="
if [ ${#FAILED_TESTS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo "=========================================="
    exit 0
else
    echo -e "${RED}✗ Some tests failed:${NC}"
    for test in "${FAILED_TESTS[@]}"; do
        echo -e "${RED}  - $test${NC}"
    done
    echo "=========================================="
    exit 1
fi
