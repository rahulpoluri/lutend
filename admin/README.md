# Lutend Web App

The web application is built with [Vite](https://vitejs.dev/), [React](https://reactjs.org/), [TypeScript](https://www.typescriptlang.org/), [TanStack Query](https://tanstack.com/query), [TanStack Router](https://tanstack.com/router) and [Chakra UI](https://chakra-ui.com/).

## Prerequisites

- **Node.js** >= 18.0.0 (use nvm or fnm for version management)
- **PNPM** >= 8.0.0 (required for monorepo workspace management)

This project is part of a monorepo and uses PNPM workspaces. See the [root README](../README.md) and [PNPM-GUIDE](../PNPM-GUIDE.md) for more information.

## Development Setup

### Option 1: Using PNPM from Root (Recommended)

The recommended way to work with the web app is using PNPM commands from the monorepo root:

```bash
# From the root directory
pnpm dev:web          # Start development server
pnpm build:web        # Build for production
pnpm test:web         # Run tests
pnpm lint:web         # Lint code
```

### Option 2: Working Directly in the Web Directory

If you prefer to work directly in the `web/` directory:

1. **Ensure Node.js version is correct:**

   The project includes a `.nvmrc` file specifying the Node.js version.

   ```bash
   # If using fnm (recommended)
   fnm install
   fnm use

   # If using nvm
   nvm install
   nvm use
   ```

2. **Install dependencies:**

   From the root directory (this installs dependencies for all workspaces):

   ```bash
   cd ..  # Go to root if you're in web/
   pnpm install
   ```

3. **Start the development server:**

   ```bash
   cd web
   pnpm dev
   ```

   Or from the root:

   ```bash
   pnpm dev:web
   ```

4. **Open your browser at http://localhost:5173/**

The development server runs with hot module replacement (HMR), so changes are reflected immediately without full page reloads.

## Available Scripts

When working in the `web/` directory, you can use these PNPM scripts:

```bash
pnpm dev              # Start development server
pnpm build            # Build for production
pnpm preview          # Preview production build locally
pnpm test             # Run tests
pnpm lint             # Lint code
pnpm format           # Format code with Prettier
pnpm type-check       # Run TypeScript type checking
```

## Working with Shared Packages

The web app uses shared packages from the monorepo:

- `@lutend/types` - TypeScript types generated from backend OpenAPI
- `@lutend/api-client` - Type-safe API client
- `@lutend/components` - Shared UI components
- `@lutend/design-tokens` - Design system tokens
- `@lutend/utils` - Shared utility functions

These are automatically linked via PNPM workspaces. When you make changes to shared packages, they're immediately available in the web app.

### Adding Shared Packages as Dependencies

To add a shared package to the web app:

```bash
# From root directory
pnpm --filter web add @lutend/types@workspace:*

# Or from web/ directory
pnpm add @lutend/types@workspace:*
```

The `workspace:*` protocol ensures you're using the local workspace version.

### Removing the frontend

If you are developing an API-only app and want to remove the frontend, you can do it easily:

- Remove the `./frontend` directory.

- In the `docker-compose.yml` file, remove the whole service / section `frontend`.

- In the `docker-compose.override.yml` file, remove the whole service / section `frontend` and `playwright`.

Done, you have a frontend-less (api-only) app. 🤓

---

If you want, you can also remove the `FRONTEND` environment variables from:

- `.env`
- `./scripts/*.sh`

But it would be only to clean them up, leaving them won't really have any effect either way.

## Generate API Client

The web app uses a generated API client from the backend's OpenAPI specification. This client is maintained in the shared `@lutend/api-client` package.

### Automatically (Recommended)

From the root directory, run:

```bash
pnpm generate:api-client
```

This regenerates the API client in `shared/api-client/` from the backend's OpenAPI spec.

### Manually

1. Start the Docker Compose stack:

   ```bash
   docker compose up -d backend
   ```

2. Download the OpenAPI JSON file:

   ```bash
   curl http://localhost:8000/api/v1/openapi.json -o openapi.json
   ```

3. Generate the client:

   ```bash
   pnpm --filter @lutend/api-client generate
   ```

4. Commit the changes to the shared package.

**Note:** Whenever the backend API changes (modifying endpoints, request/response schemas), you should regenerate the API client to keep the frontend in sync.

## Using a Remote API

If you want to use a remote API, you can set the environment variable `VITE_API_URL` to the URL of the remote API. For example, you can set it in the `frontend/.env` file:

```env
VITE_API_URL=https://api.my-domain.example.com
```

Then, when you run the frontend, it will use that URL as the base URL for the API.

## Code Structure

The frontend code is structured as follows:

- `frontend/src` - The main frontend code.
- `frontend/src/assets` - Static assets.
- `frontend/src/client` - The generated OpenAPI client.
- `frontend/src/components` - The different components of the frontend.
- `frontend/src/hooks` - Custom hooks.
- `frontend/src/routes` - The different routes of the frontend which include the pages.
- `theme.tsx` - The Chakra UI custom theme.

## End-to-End Testing with Playwright

The web app includes end-to-end tests using Playwright. To run the tests, you need to have the Docker Compose stack running.

### Running Tests

1. Start the backend stack:

   ```bash
   docker compose up -d --wait backend
   ```

2. Run the tests:

   ```bash
   # From root directory
   pnpm test:web

   # Or from web/ directory
   pnpm test

   # Or using Playwright directly
   pnpm exec playwright test
   ```

3. Run tests in UI mode (interactive):

   ```bash
   pnpm exec playwright test --ui
   ```

4. Clean up after tests:

   ```bash
   docker compose down -v
   ```

### Writing Tests

Tests are located in the `tests/` directory. To add new tests, create or modify test files following the existing patterns.

For more information on writing and running Playwright tests, refer to the official [Playwright documentation](https://playwright.dev/docs/intro).
