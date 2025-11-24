#!/usr/bin/env bash

set -e
set -x

# Check if uv is available
if ! command -v uv &> /dev/null; then
    echo ""
    echo "❌ ERROR: uv is not installed"
    echo ""
    echo "This project requires uv for Python package management."
    echo ""
    echo "Install uv with one of these methods:"
    echo ""
    echo "  macOS/Linux:"
    echo "    curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo ""
    echo "  Homebrew:"
    echo "    brew install uv"
    echo ""
    echo "  pip:"
    echo "    pip install uv"
    echo ""
    echo "After installation, restart your terminal and run this command again."
    echo ""
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(uv run python --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -n "$PYTHON_VERSION" ]; then
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    if [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 12 ]; then
        echo ""
        echo "⚠️  WARNING: Python $PYTHON_VERSION detected"
        echo ""
        echo "This project requires Python 3.10 or 3.11 due to dependency compatibility."
        echo "Python 3.12+ has compatibility issues with some FastAPI dependencies."
        echo ""
        echo "To fix this, install Python 3.11:"
        echo ""
        echo "  macOS (Homebrew):"
        echo "    brew install python@3.11"
        echo ""
        echo "  Then tell uv to use Python 3.11:"
        echo "    uv python pin 3.11"
        echo "    uv sync"
        echo ""
        echo "Attempting to continue anyway..."
        echo ""
    fi
fi

# Run linting with uv
uv run mypy app
uv run ruff check app
uv run ruff format app --check
