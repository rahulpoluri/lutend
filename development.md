# Lutend Platform - Development Guide

This guide covers local development workflows for the Lutend monorepo, including Docker Compose setup, PNPM workspace management, and development best practices.

## Prerequisites

Before starting development, ensure you have:

- **Node.js** >= 18.0.0 (managed with nvm or fnm)
- **PNPM** >= 8.0.0 (see [PNPM-GUIDE.md](./PNPM-GUIDE.md) for installation)
- **Python** >= 3.11 with [uv](https://docs.astral.sh/uv/)
- **Docker** and **Docker Compose**
- **Git** for version control

## Monorepo Structure

This project uses a monorepo structure with PNPM workspaces:

```
lutend/
├── backend/           # Python FastAPI backend
├── web/              # React web application
├── mobile/           # React Native mobile app
├── admin/            # React admin dashboard
├── infrastructure/   # Terraform IaC
├── shared/           # Shared packages
│   ├── types/        # TypeScript types
│   ├── api-client/   # API client SDK
│   ├── components/   # Shared UI components
│   ├── design-tokens/# Design system tokens
│   └── utils/        # Shared utilities
└── pnpm-workspace.yaml
```

## PNPM Workspace Commands

### Installing Dependencies

```bash
# Install all dependencies for all workspaces
pnpm install

# Install a dependency in a specific workspace
pnpm --filter web add axios
pnpm --filter mobile add react-native-gesture-handler

# Install a dev dependency
pnpm --filter web add -D @types/node

# Add a shared package as a dependency
pnpm --filter web add @lutend/types@workspace:*
```

### Running Commands

```bash
# Run a script in all workspaces
pnpm -r dev              # Run dev script in all workspaces
pnpm --parallel dev      # Run dev script in parallel

# Run a script in a specific workspace
pnpm --filter web dev
pnpm --filter admin build
pnpm --filter @lutend/types generate

# Run a script in multiple workspaces
pnpm --filter web --filter admin dev
```

### Managing Dependencies

```bash
# Update dependencies
pnpm update              # Update all dependencies
pnpm --filter web update # Update web dependencies only

# Remove a dependency
pnpm --filter web remove axios

# List dependencies
pnpm list                # List all dependencies
pnpm --filter web list   # List web dependencies only
```

## Docker Compose

- Start the local stack with Docker Compose:

```bash
docker compose watch
```

- Now you can open your browser and interact with these URLs:

Frontend, built with Docker, with routes handled based on the path: http://localhost:5173

Backend, JSON based web API based on OpenAPI: http://localhost:8000

Automatic interactive documentation with Swagger UI (from the OpenAPI backend): http://localhost:8000/docs

Adminer, database web administration: http://localhost:8080

Traefik UI, to see how the routes are being handled by the proxy: http://localhost:8090

**Note**: The first time you start your stack, it might take a minute for it to be ready. While the backend waits for the database to be ready and configures everything. You can check the logs to monitor it.

To check the logs, run (in another terminal):

```bash
docker compose logs
```

To check the logs of a specific service, add the name of the service, e.g.:

```bash
docker compose logs backend
```

## Local Development

The Docker Compose files are configured so that each of the services is available in a different port in `localhost`.

For the backend and web app, they use the same port that would be used by their local development server, so the backend is at `http://localhost:8000` and the web app at `http://localhost:5173`.

This way, you can turn off a Docker Compose service and start its local development service, and everything will keep working because it all uses the same ports.

### Running Frontend Applications Locally

You can stop the Docker Compose frontend service and run it locally with PNPM:

```bash
# Stop the web service in Docker
docker compose stop frontend

# Run the web app locally with PNPM
pnpm dev:web
```

Or for other applications:

```bash
# Run mobile app
pnpm dev:mobile

# Run admin dashboard
pnpm dev:admin
```

### Running Backend Locally

You can stop the backend Docker Compose service and run it locally:

```bash
# Stop the backend service
docker compose stop backend

# Run the backend locally
cd backend
source .venv/bin/activate
fastapi dev app/main.py
```

Or use the PNPM script from the root:

```bash
pnpm dev:backend
```

### Hybrid Development

You can mix and match - run some services in Docker and others locally:

```bash
# Run backend, database, and Redis in Docker
docker compose up -d backend db redis

# Run frontend locally with PNPM
pnpm dev:web
```

This is useful when you're only working on the frontend and don't need to modify backend code.

### Working with Shared Packages

When developing shared packages (types, api-client, components, etc.), you may need to rebuild them:

```bash
# Rebuild a shared package
pnpm --filter @lutend/types build

# Watch mode for shared packages during development
pnpm --filter @lutend/types dev
```

Changes to shared packages are automatically reflected in applications that depend on them thanks to PNPM's workspace protocol.

## Docker Compose in `localhost.tiangolo.com`

When you start the Docker Compose stack, it uses `localhost` by default, with different ports for each service (backend, frontend, adminer, etc).

When you deploy it to production (or staging), it will deploy each service in a different subdomain, like `api.example.com` for the backend and `dashboard.example.com` for the frontend.

In the guide about [deployment](deployment.md) you can read about Traefik, the configured proxy. That's the component in charge of transmitting traffic to each service based on the subdomain.

If you want to test that it's all working locally, you can edit the local `.env` file, and change:

```dotenv
DOMAIN=localhost.tiangolo.com
```

That will be used by the Docker Compose files to configure the base domain for the services.

Traefik will use this to transmit traffic at `api.localhost.tiangolo.com` to the backend, and traffic at `dashboard.localhost.tiangolo.com` to the frontend.

The domain `localhost.tiangolo.com` is a special domain that is configured (with all its subdomains) to point to `127.0.0.1`. This way you can use that for your local development.

After you update it, run again:

```bash
docker compose watch
```

When deploying, for example in production, the main Traefik is configured outside of the Docker Compose files. For local development, there's an included Traefik in `docker-compose.override.yml`, just to let you test that the domains work as expected, for example with `api.localhost.tiangolo.com` and `dashboard.localhost.tiangolo.com`.

## Docker Compose files and env vars

There is a main `docker-compose.yml` file with all the configurations that apply to the whole stack, it is used automatically by `docker compose`.

And there's also a `docker-compose.override.yml` with overrides for development, for example to mount the source code as a volume. It is used automatically by `docker compose` to apply overrides on top of `docker-compose.yml`.

These Docker Compose files use the `.env` file containing configurations to be injected as environment variables in the containers.

They also use some additional configurations taken from environment variables set in the scripts before calling the `docker compose` command.

After changing variables, make sure you restart the stack:

```bash
docker compose watch
```

## The .env file

The `.env` file is the one that contains all your configurations, generated keys and passwords, etc.

Depending on your workflow, you could want to exclude it from Git, for example if your project is public. In that case, you would have to make sure to set up a way for your CI tools to obtain it while building or deploying your project.

One way to do it could be to add each environment variable to your CI/CD system, and updating the `docker-compose.yml` file to read that specific env var instead of reading the `.env` file.

## Pre-commits and code linting

we are using a tool called [pre-commit](https://pre-commit.com/) for code linting and formatting.

When you install it, it runs right before making a commit in git. This way it ensures that the code is consistent and formatted even before it is committed.

You can find a file `.pre-commit-config.yaml` with configurations at the root of the project.

#### Install pre-commit to run automatically

`pre-commit` is already part of the dependencies of the project, but you could also install it globally if you prefer to, following [the official pre-commit docs](https://pre-commit.com/).

After having the `pre-commit` tool installed and available, you need to "install" it in the local repository, so that it runs automatically before each commit.

Using `uv`, you could do it with:

```bash
❯ uv run pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

Now whenever you try to commit, e.g. with:

```bash
git commit
```

...pre-commit will run and check and format the code you are about to commit, and will ask you to add that code (stage it) with git again before committing.

Then you can `git add` the modified/fixed files again and now you can commit.

#### Running pre-commit hooks manually

you can also run `pre-commit` manually on all the files, you can do it using `uv` with:

```bash
❯ uv run pre-commit run --all-files
check for added large files..............................................Passed
check toml...............................................................Passed
check yaml...............................................................Passed
ruff.....................................................................Passed
ruff-format..............................................................Passed
eslint...................................................................Passed
prettier.................................................................Passed
```

## URLs

The production or staging URLs would use these same paths, but with your own domain.

### Development URLs

Development URLs, for local development.

Frontend: http://localhost:5173

Backend: http://localhost:8000

Automatic Interactive Docs (Swagger UI): http://localhost:8000/docs

Automatic Alternative Docs (ReDoc): http://localhost:8000/redoc

Adminer: http://localhost:8080

Traefik UI: http://localhost:8090

MailCatcher: http://localhost:1080

### Development URLs with `localhost.tiangolo.com` Configured

Development URLs, for local development.

Frontend: http://dashboard.localhost.tiangolo.com

Backend: http://api.localhost.tiangolo.com

Automatic Interactive Docs (Swagger UI): http://api.localhost.tiangolo.com/docs

Automatic Alternative Docs (ReDoc): http://api.localhost.tiangolo.com/redoc

Adminer: http://localhost.tiangolo.com:8080

Traefik UI: http://localhost.tiangolo.com:8090

MailCatcher: http://localhost.tiangolo.com:1080
