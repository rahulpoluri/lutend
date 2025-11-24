# Troubleshooting Guide

Common issues and solutions when developing with the Lutend monorepo.

## Database Issues

### Error: "role 'postgres' does not exist"

**Symptom:**

```
ERROR: (psycopg.OperationalError) connection failed:
FATAL: role "postgres" does not exist
```

**Cause:**
You have a local PostgreSQL instance running on port 5432, which conflicts with the Docker PostgreSQL container.

**Solution:**

**Option 1: Stop local PostgreSQL (Recommended)**

```bash
# macOS (Homebrew)
brew services stop postgresql
# or
brew services stop postgresql@14

# Linux (systemd)
sudo systemctl stop postgresql

# Verify it's stopped
lsof -i :5432  # Should show nothing
```

Then run your tests again:

```bash
pnpm test:all
```

**Option 2: Use a different port for Docker**

Edit `docker-compose.yml`:

```yaml
db:
  ports:
    - "5433:5432" # Map to different host port
```

And update `.env`:

```
POSTGRES_PORT=5433
```

**Option 3: Configure local PostgreSQL**

If you want to use your local PostgreSQL:

```bash
# Create the postgres user
createuser -s postgres

# Set a password
psql -c "ALTER USER postgres PASSWORD 'changethis';"

# Create the database
createdb -O postgres app
```

Then update `.env`:

```
POSTGRES_SERVER=localhost
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=changethis
POSTGRES_DB=app
```

### Database won't start in Docker

**Check if port is in use:**

```bash
lsof -i :5432
```

**Check Docker logs:**

```bash
docker compose logs db
```

**Clean up and restart:**

```bash
docker compose down -v --remove-orphans
docker compose up -d db
```

## Python/uv Issues

### Error: "uv: command not found"

**Solution:**

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or with Homebrew
brew install uv

# Restart your terminal
source ~/.zshrc  # or ~/.bashrc
```

### Error: "httptools" build fails

**Cause:**
You're using Python 3.12+ which isn't compatible with httptools yet.

**Solution:**

```bash
cd backend
uv python pin 3.11
uv sync
```

### Error: "Failed to spawn: mypy" or "coverage"

**Cause:**
Commands are being run without `uv run`.

**Solution:**
All Python commands in scripts should use `uv run`:

```bash
# Wrong
python app/main.py
mypy app
pytest tests/

# Correct
uv run python app/main.py
uv run mypy app
uv run pytest tests/
```

## PNPM Issues

### Error: "No projects matched the filters"

**Cause:**
Package name doesn't match or workspace isn't recognized.

**Solution:**

```bash
# Check workspace packages
pnpm list --depth 0

# Reinstall dependencies
pnpm install

# Check pnpm-workspace.yaml
cat pnpm-workspace.yaml
```

### Error: "ELIFECYCLE Command failed"

**Check which workspace failed:**

```bash
pnpm -r run <command>  # Shows which workspace fails
```

**Run for specific workspace:**

```bash
pnpm --filter admin <command>
```

## Docker Issues

### Containers won't stop

```bash
# Force stop and remove
docker compose down -v --remove-orphans

# Nuclear option - stop all Docker containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```

### Port conflicts

**Check what's using a port:**

```bash
lsof -i :8000   # Backend
lsof -i :5432   # PostgreSQL
lsof -i :5173   # Admin
lsof -i :6379   # Redis
```

**Kill process on port:**

```bash
# Find PID
lsof -i :5432

# Kill it
kill -9 <PID>
```

### Disk space issues

```bash
# Clean up Docker
docker system prune -af --volumes

# Check disk usage
docker system df
```

## Testing Issues

### Playwright tests fail

**Update browsers:**

```bash
cd admin
npx playwright install
```

**Run in headed mode to debug:**

```bash
cd admin
npx playwright test --headed
```

**Check if services are running:**

```bash
docker compose ps
curl http://localhost:8000/api/v1/utils/health-check
curl http://localhost:5173
```

### Backend tests fail

**Check database is running:**

```bash
docker compose ps db
docker compose logs db
```

**Run tests with more output:**

```bash
cd backend
uv run pytest tests/ -v
```

**Check test database connection:**

```bash
cd backend
uv run python -c "from app.core.db import engine; print(engine.url)"
```

## Linting Issues

### Biome schema version warning

```bash
cd admin
npx biome migrate --write
```

### Ruff or mypy errors

**Update dependencies:**

```bash
cd backend
uv sync
```

**Run manually to see full output:**

```bash
cd backend
uv run mypy app
uv run ruff check app
```

## Git/GitHub Actions Issues

### Workflow waiting forever

**Cause:**
Workflow requires self-hosted runner that doesn't exist.

**Solution:**
Disable the workflow by setting `if: false` in the job.

### Secrets not set

**Check required secrets in GitHub:**

- Go to Settings → Secrets and variables → Actions
- Add missing secrets

### Workflow fails but works locally

**Check Python version:**

- Local: Check `backend/.python-version`
- CI: Check `.github/workflows/*.yml` for `python-version`
- Should both be 3.11

**Check environment variables:**

- Local: `.env` file
- CI: GitHub Secrets

## Performance Issues

### Slow pnpm install

```bash
# Clear cache
pnpm store prune

# Use faster mirror (optional)
pnpm config set registry https://registry.npmmirror.com
```

### Slow Docker builds

```bash
# Enable BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Add to ~/.zshrc or ~/.bashrc to make permanent
```

### Slow tests

**Run specific tests:**

```bash
cd backend
uv run pytest tests/test_specific.py
```

**Run in parallel:**

```bash
cd backend
uv run pytest tests/ -n auto
```

## IDE Issues

### VS Code Python extension not working

**Select correct interpreter:**

1. Cmd/Ctrl + Shift + P
2. "Python: Select Interpreter"
3. Choose `backend/.venv/bin/python`

### TypeScript errors in IDE

```bash
# Rebuild TypeScript
pnpm run type-check

# Restart TS server in VS Code
Cmd/Ctrl + Shift + P → "TypeScript: Restart TS Server"
```

## Getting More Help

If you're still stuck:

1. **Check logs:**

   ```bash
   docker compose logs <service>
   ```

2. **Check GitHub Actions logs:**
   - Go to Actions tab in GitHub
   - Click on failed workflow
   - Expand failed step

3. **Search existing issues:**
   - Check GitHub Issues for similar problems

4. **Create a new issue:**
   - Include error messages
   - Include relevant logs
   - Include steps to reproduce
   - Include your environment (OS, Python version, Node version)

## Quick Diagnostic Commands

Run these to gather information about your environment:

```bash
# System info
uname -a
sw_vers  # macOS only

# Tool versions
node --version
pnpm --version
python3 --version
uv --version
docker --version
docker compose version

# Check what's running
docker compose ps
lsof -i :5432
lsof -i :8000
lsof -i :5173

# Check workspace
pnpm list --depth 0
ls -la backend/.venv

# Check environment
cat .env | grep -v PASSWORD | grep -v SECRET
```
