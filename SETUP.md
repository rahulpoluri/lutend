# Setup Guide

This guide will help you set up your development environment for the Lutend monorepo.

## Prerequisites

### Required Tools

1. **Node.js** >= 18.0.0
2. **PNPM** >= 8.0.0
3. **Python** >= 3.11
4. **uv** (Python package manager)
5. **Docker** and **Docker Compose**

## Installation Steps

### 1. Install Node.js

Using fnm (recommended):

```bash
# Install fnm
curl -fsSL https://fnm.vercel.app/install | bash

# Install Node.js
fnm install
fnm use
```

Or using nvm:

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install Node.js
nvm install
nvm use
```

### 2. Install PNPM

```bash
npm install -g pnpm@8
```

Verify installation:

```bash
pnpm --version  # Should show 8.x.x or higher
```

### 3. Install Python

**macOS:**

```bash
brew install python@3.11
```

**Linux:**

```bash
sudo apt-get update
sudo apt-get install python3.11 python3.11-venv
```

Verify installation:

```bash
python3 --version  # Should show 3.11 or higher
```

### 4. Install uv (Python Package Manager)

**This is required for backend development and testing!**

**Option 1: Using the install script (recommended):**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Option 2: Using Homebrew (macOS):**

```bash
brew install uv
```

**Option 3: Using pip:**

```bash
pip install uv
```

**After installation, restart your terminal** and verify:

```bash
uv --version
```

### 5. Install Docker

**macOS:**

- Download and install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

**Linux:**

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo apt-get install docker-compose-plugin
```

Verify installation:

```bash
docker --version
docker compose version
```

## Project Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd lutend
```

### 2. Install Dependencies

```bash
# Install all workspace dependencies
pnpm install

# Install backend dependencies
cd backend
uv sync
cd ..
```

### 3. Set Up Environment Variables

```bash
# Copy the example env file
cp .env.example .env

# Edit .env with your configuration
# At minimum, change these values:
# - SECRET_KEY
# - FIRST_SUPERUSER_PASSWORD
# - POSTGRES_PASSWORD
```

### 4. Start Development Environment

```bash
# Start all services with Docker Compose
docker compose up -d

# Or start specific services
docker compose up -d db redis mailcatcher
```

### 5. Run Database Migrations

```bash
cd backend
uv run bash scripts/prestart.sh
```

### 6. Verify Setup

```bash
# Check backend is running
curl http://localhost:8000/api/v1/utils/health-check

# Check admin dashboard is running
curl http://localhost:5173

# Run linting
pnpm lint

# Run tests
pnpm test:backend
```

## Common Issues

### uv command not found

After installing uv, you need to restart your terminal or source your shell config:

```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc

# Or just restart your terminal
```

### Port Already in Use

If you get port conflicts:

```bash
# Check what's using the port
lsof -i :8000  # Backend
lsof -i :5432  # PostgreSQL
lsof -i :5173  # Admin

# Kill the process or change the port in .env
```

### Docker Permission Denied (Linux)

```bash
# Add your user to the docker group
sudo usermod -aG docker $USER

# Log out and log back in
```

### PNPM Installation Issues

If pnpm install fails:

```bash
# Clear cache
pnpm store prune

# Try again
pnpm install
```

## Development Workflow

### Daily Development

```bash
# Start services
docker compose up -d

# Run admin in dev mode
pnpm dev:admin

# Run backend in dev mode (in another terminal)
cd backend
uv run fastapi dev app/main.py
```

### Before Committing

```bash
# Run all linting
pnpm lint

# Run all tests
pnpm test:all

# Or run quick tests
pnpm test:quick
```

### Updating Dependencies

```bash
# Update frontend dependencies
pnpm update

# Update backend dependencies
cd backend
uv sync --upgrade
```

## IDE Setup

### VS Code (Recommended)

Install these extensions:

- Python
- Pylance
- Biome
- Docker
- ESLint (if using ESLint)

### Settings

Add to `.vscode/settings.json`:

```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/backend/.venv/bin/python",
  "python.linting.enabled": true,
  "python.linting.mypyEnabled": true,
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff"
  },
  "[typescript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "biomejs.biome"
  }
}
```

## Next Steps

- Read [PNPM-GUIDE.md](./PNPM-GUIDE.md) for workspace management
- Read [TESTING-GUIDE.md](./TESTING-GUIDE.md) for testing instructions
- Read [development.md](./development.md) for development workflows
- Check individual README files in each workspace:
  - [backend/README.md](./backend/README.md)
  - [admin/README.md](./admin/README.md)
  - [mobile/README.md](./mobile/README.md)

## Getting Help

If you encounter issues:

1. Check the documentation in this repository
2. Search existing GitHub issues
3. Ask in the team chat
4. Create a new GitHub issue with details about your problem
