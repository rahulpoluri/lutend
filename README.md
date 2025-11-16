# Lutend Platform

Lutend is a matchmaking platform designed to solve common problems in online dating such as doom swiping, ghosting, superficiality, and fake profiles.

## Monorepo Structure

This is a monorepo containing all Lutend applications and infrastructure:

- **backend/** - Python FastAPI backend API
- **web/** - React web application (browser-based access)
- **mobile/** - React Native mobile app (iOS & Android)
- **admin/** - React admin dashboard (staff operations)
- **infrastructure/** - Terraform infrastructure as code
- **shared/** - Shared code across applications
  - **types/** - TypeScript types generated from backend OpenAPI
  - **api-client/** - Type-safe API client
  - **components/** - Shared UI components
  - **design-tokens/** - Design system tokens from Figma
  - **utils/** - Shared utility functions

## Technology Stack and Features

### Backend

- ⚡ [**FastAPI**](https://fastapi.tiangolo.com) for the Python backend API
- 🧰 [SQLModel](https://sqlmodel.tiangolo.com) for Python SQL database interactions (ORM)
- 🔍 [Pydantic](https://docs.pydantic.dev) for data validation and settings management
- 💾 [PostgreSQL](https://www.postgresql.org) as the SQL database
- 🔴 [Redis](https://redis.io) for caching and real-time features
- 📦 S3-compatible object storage for media files

### Frontend Applications

- 🚀 [React](https://react.dev) for web and admin dashboards
- 📱 [React Native](https://reactnative.dev) for mobile apps (iOS & Android)
- 💃 TypeScript, hooks, Vite, and modern frontend stack
- 🎨 [Chakra UI](https://chakra-ui.com) for UI components
- 🤖 Automatically generated type-safe API client
- 🧪 [Playwright](https://playwright.dev) for E2E testing
- 🦇 Dark mode support

### Infrastructure

- 🏗️ [Terraform](https://www.terraform.io) for infrastructure as code
- 🐋 [Docker Compose](https://www.docker.com) for development and production
- ☁️ Cloud-agnostic design (AWS/GCP/Azure support)
- 📊 Monitoring and logging infrastructure

### Security & DevOps

- 🔒 Secure password hashing by default
- 🔑 JWT (JSON Web Token) authentication
- 📫 Email and SMS-based authentication
- ✅ Tests with [Pytest](https://pytest.org) and Jest
- 📞 [Traefik](https://traefik.io) as reverse proxy / load balancer
- 🏭 CI/CD based on GitHub Actions

### Dashboard Login

[![API docs](img/login.png)](https://github.com/fastapi/full-stack-fastapi-template)

### Dashboard - Admin

[![API docs](img/dashboard.png)](https://github.com/fastapi/full-stack-fastapi-template)

### Dashboard - Create User

[![API docs](img/dashboard-create.png)](https://github.com/fastapi/full-stack-fastapi-template)

### Dashboard - Items

[![API docs](img/dashboard-items.png)](https://github.com/fastapi/full-stack-fastapi-template)

### Dashboard - User Settings

[![API docs](img/dashboard-user-settings.png)](https://github.com/fastapi/full-stack-fastapi-template)

### Dashboard - Dark Mode

[![API docs](img/dashboard-dark.png)](https://github.com/fastapi/full-stack-fastapi-template)

### Interactive API Documentation

[![API docs](img/docs.png)](https://github.com/fastapi/full-stack-fastapi-template)

## How To Use It

You can **just fork or clone** this repository and use it as is.

✨ It just works. ✨

### How to Use a Private Repository

If you want to have a private repository, GitHub won't allow you to simply fork it as it doesn't allow changing the visibility of forks.

But you can do the following:

- Create a new GitHub repo, for example `my-full-stack`.
- Clone this repository manually, set the name with the name of the project you want to use, for example `my-full-stack`:

```bash
git clone git@github.com:fastapi/full-stack-fastapi-template.git my-full-stack
```

- Enter into the new directory:

```bash
cd my-full-stack
```

- Set the new origin to your new repository, copy it from the GitHub interface, for example:

```bash
git remote set-url origin git@github.com:octocat/my-full-stack.git
```

- Add this repo as another "remote" to allow you to get updates later:

```bash
git remote add upstream git@github.com:fastapi/full-stack-fastapi-template.git
```

- Push the code to your new repository:

```bash
git push -u origin master
```

### Update From the Original Template

After cloning the repository, and after doing changes, you might want to get the latest changes from this original template.

- Make sure you added the original repository as a remote, you can check it with:

```bash
git remote -v

origin    git@github.com:octocat/my-full-stack.git (fetch)
origin    git@github.com:octocat/my-full-stack.git (push)
upstream    git@github.com:fastapi/full-stack-fastapi-template.git (fetch)
upstream    git@github.com:fastapi/full-stack-fastapi-template.git (push)
```

- Pull the latest changes without merging:

```bash
git pull --no-commit upstream master
```

This will download the latest changes from this template without committing them, that way you can check everything is right before committing.

- If there are conflicts, solve them in your editor.

- Once you are done, commit the changes:

```bash
git merge --continue
```

### Configure

You can then update configs in the `.env` files to customize your configurations.

Before deploying it, make sure you change at least the values for:

- `SECRET_KEY`
- `FIRST_SUPERUSER_PASSWORD`
- `POSTGRES_PASSWORD`

You can (and should) pass these as environment variables from secrets.

Read the [deployment.md](./deployment.md) docs for more details.

### Generate Secret Keys

Some environment variables in the `.env` file have a default value of `changethis`.

You have to change them with a secret key, to generate secret keys you can run the following command:

```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

Copy the content and use that as password / secret key. And run that again to generate another secure key.

## How To Use It - Alternative With Copier

This repository also supports generating a new project using [Copier](https://copier.readthedocs.io).

It will copy all the files, ask you configuration questions, and update the `.env` files with your answers.

### Install Copier

You can install Copier with:

```bash
pip install copier
```

Or better, if you have [`pipx`](https://pipx.pypa.io/), you can run it with:

```bash
pipx install copier
```

**Note**: If you have `pipx`, installing copier is optional, you could run it directly.

### Generate a Project With Copier

Decide a name for your new project's directory, you will use it below. For example, `my-awesome-project`.

Go to the directory that will be the parent of your project, and run the command with your project's name:

```bash
copier copy https://github.com/fastapi/full-stack-fastapi-template my-awesome-project --trust
```

If you have `pipx` and you didn't install `copier`, you can run it directly:

```bash
pipx run copier copy https://github.com/fastapi/full-stack-fastapi-template my-awesome-project --trust
```

**Note** the `--trust` option is necessary to be able to execute a [post-creation script](https://github.com/fastapi/full-stack-fastapi-template/blob/master/.copier/update_dotenv.py) that updates your `.env` files.

### Input Variables

Copier will ask you for some data, you might want to have at hand before generating the project.

But don't worry, you can just update any of that in the `.env` files afterwards.

The input variables, with their default values (some auto generated) are:

- `project_name`: (default: `"FastAPI Project"`) The name of the project, shown to API users (in .env).
- `stack_name`: (default: `"fastapi-project"`) The name of the stack used for Docker Compose labels and project name (no spaces, no periods) (in .env).
- `secret_key`: (default: `"changethis"`) The secret key for the project, used for security, stored in .env, you can generate one with the method above.
- `first_superuser`: (default: `"admin@example.com"`) The email of the first superuser (in .env).
- `first_superuser_password`: (default: `"changethis"`) The password of the first superuser (in .env).
- `smtp_host`: (default: "") The SMTP server host to send emails, you can set it later in .env.
- `smtp_user`: (default: "") The SMTP server user to send emails, you can set it later in .env.
- `smtp_password`: (default: "") The SMTP server password to send emails, you can set it later in .env.
- `emails_from_email`: (default: `"info@example.com"`) The email account to send emails from, you can set it later in .env.
- `postgres_password`: (default: `"changethis"`) The password for the PostgreSQL database, stored in .env, you can generate one with the method above.
- `sentry_dsn`: (default: "") The DSN for Sentry, if you are using it, you can set it later in .env.

## Getting Started

### Prerequisites

- **Node.js** >= 18.0.0 (use [nvm](https://github.com/nvm-sh/nvm) or [fnm](https://github.com/Schniz/fnm) for version management)
- **PNPM** >= 8.0.0 (required for monorepo workspace management)
- **Python** >= 3.11 with [uv](https://docs.astral.sh/uv/) for package management
- **Docker** and **Docker Compose** for local development
- **Terraform** >= 1.5.0 (for infrastructure deployment)

### Why PNPM?

This monorepo uses PNPM instead of npm or yarn for several key advantages:

- **Disk Space Efficiency**: PNPM uses a content-addressable store, saving significant disk space
- **Fast Installation**: Packages are linked from a global store instead of copied
- **Strict Dependencies**: Prevents phantom dependencies and ensures reproducible builds
- **Workspace Support**: First-class monorepo support with workspace protocol
- **Better Performance**: Faster than npm and yarn in most scenarios

For detailed PNPM usage and troubleshooting, see [PNPM-GUIDE.md](./PNPM-GUIDE.md).

### Installation

#### 1. Install PNPM

Choose one of the following methods:

**Using npm (recommended):**

```bash
npm install -g pnpm@8
```

**Using Homebrew (macOS):**

```bash
brew install pnpm
```

**Using standalone script:**

```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

**Verify installation:**

```bash
pnpm --version  # Should show 8.x.x or higher
```

#### 2. Install Node.js (if needed)

This project includes a `.nvmrc` file specifying the Node.js version. Use nvm or fnm:

```bash
# Using fnm (recommended)
fnm install
fnm use

# Using nvm
nvm install
nvm use
```

#### 3. Install Dependencies

From the root directory, install all workspace dependencies:

```bash
pnpm install
```

This single command installs dependencies for all applications (web, mobile, admin) and shared packages.

#### 4. Set Up Environment Variables

```bash
cp .env.example .env
# Edit .env with your configuration
```

Each application may have its own `.env` file. Check individual README files for details.

#### 5. Start Development Environment

Start all services with Docker Compose:

```bash
pnpm docker:up
```

Or use the Docker Compose command directly:

```bash
docker compose up -d
```

### Development

#### Run all applications in development mode:

```bash
pnpm dev
```

This runs all frontend applications in parallel using PNPM's `--parallel` flag.

#### Run specific applications:

```bash
pnpm dev:web      # Web app only (React + Vite)
pnpm dev:mobile   # Mobile app only (React Native)
pnpm dev:admin    # Admin dashboard only (React + Vite)
pnpm dev:backend  # Backend API only (FastAPI)
```

#### Working with workspaces:

```bash
# Run a command in a specific workspace
pnpm --filter web <command>
pnpm --filter mobile <command>
pnpm --filter admin <command>
pnpm --filter @lutend/types <command>

# Add a dependency to a specific workspace
pnpm --filter web add react-query
pnpm --filter mobile add @react-navigation/native

# Add a shared package as a dependency
pnpm --filter web add @lutend/types@workspace:*
pnpm --filter admin add @lutend/api-client@workspace:*
```

#### Run tests:

```bash
pnpm test              # All tests across all workspaces
pnpm test:web          # Web tests only
pnpm test:mobile       # Mobile tests only
pnpm test:admin        # Admin tests only
pnpm test:backend      # Backend tests only (pytest)
```

#### Lint and format:

```bash
pnpm lint              # Lint all code
pnpm lint:web          # Lint web app only
pnpm format            # Format all code
pnpm format:backend    # Format backend only
```

#### Build applications:

```bash
pnpm build             # Build all applications
pnpm build:web         # Build web app only
pnpm build:mobile      # Build mobile app only
pnpm build:admin       # Build admin dashboard only
pnpm build:backend     # Build backend Docker image
```

#### Generate types and API client:

```bash
pnpm generate:types       # Generate TypeScript types from OpenAPI
pnpm generate:api-client  # Generate API client from OpenAPI
```

These commands regenerate shared packages from the backend OpenAPI specification.

#### Clean and reset:

```bash
pnpm clean             # Remove all node_modules and build artifacts
pnpm install           # Reinstall all dependencies
```

#### Docker Compose commands:

```bash
pnpm docker:up         # Start all services
pnpm docker:down       # Stop all services
pnpm docker:logs       # View logs from all services
```

## Application Documentation

- **Backend**: [backend/README.md](./backend/README.md)
- **Web App**: [web/README.md](./web/README.md)
- **Mobile App**: [mobile/README.md](./mobile/README.md)
- **Admin Dashboard**: [admin/README.md](./admin/README.md)
- **Infrastructure**: [infrastructure/README.md](./infrastructure/README.md)

## Deployment

Deployment docs: [deployment.md](./deployment.md)

## Development Guide

General development docs: [development.md](./development.md)

This includes using Docker Compose, custom local domains, `.env` configurations, etc.

## Release Notes

Check the file [release-notes.md](./release-notes.md).

## License

The Full Stack FastAPI Template is licensed under the terms of the MIT license.
