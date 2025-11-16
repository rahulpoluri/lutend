# Lutend Monorepo Guide

This document provides an overview of the Lutend monorepo structure and how to work with it.

## Structure Overview

```
lutend/
├── backend/              # Python FastAPI backend
├── web/                  # React web application
├── mobile/               # React Native mobile app
├── admin/                # React admin dashboard
├── infrastructure/       # Terraform IaC
├── shared/               # Shared packages
│   ├── types/           # TypeScript types from OpenAPI
│   ├── api-client/      # Generated API client
│   ├── components/      # Shared UI components
│   ├── design-tokens/   # Design system tokens
│   └── utils/           # Shared utilities
├── package.json          # Root package.json with workspace scripts
└── pnpm-workspace.yaml   # PNPM workspace configuration
```

## Workspace Management

This monorepo uses PNPM workspaces to manage dependencies across multiple packages.

### Installing Dependencies

```bash
# Install all dependencies for all workspaces
pnpm install

# Install a dependency in a specific workspace
pnpm --filter web add react-query
pnpm --filter @lutend/utils add lodash

# Install a dev dependency
pnpm --filter web add -D @types/node
```

### Running Scripts

```bash
# Run a script in all workspaces
pnpm run --recursive build

# Run a script in a specific workspace
pnpm --filter web dev
pnpm --filter @lutend/types build

# Run scripts in parallel
pnpm run --parallel dev
```

### Workspace Dependencies

Shared packages can be referenced using the `workspace:*` protocol:

```json
{
  "dependencies": {
    "@lutend/types": "workspace:*",
    "@lutend/api-client": "workspace:*"
  }
}
```

## Shared Packages

### @lutend/types

TypeScript types generated from the backend OpenAPI specification.

**Usage:**

```typescript
import type { User, Match, Meeting } from "@lutend/types";
```

**Regenerate types:**

```bash
pnpm generate:types
```

### @lutend/api-client

Type-safe API client generated from the backend OpenAPI specification.

**Usage:**

```typescript
import { apiClient } from "@lutend/api-client";

const user = await apiClient.users.getMe();
```

**Regenerate client:**

```bash
pnpm generate:api-client
```

### @lutend/design-tokens

Design system tokens extracted from Figma.

**Usage:**

```typescript
import { colors, spacing, typography } from "@lutend/design-tokens";

const styles = {
  color: colors.primary[500],
  padding: spacing[4],
  fontSize: typography.fontSize.lg,
};
```

### @lutend/components

Shared UI components for web and mobile.

**Usage:**

```typescript
import { Button } from "@lutend/components";

<Button variant="primary" size="md">
  Click me
</Button>;
```

### @lutend/utils

Shared utility functions.

**Usage:**

```typescript
import { formatPhoneNumber, isValidEmail } from "@lutend/utils";

const formatted = formatPhoneNumber("+1234567890");
const valid = isValidEmail("user@example.com");
```

## Development Workflow

### 1. Start Development Environment

```bash
# Start Docker services (PostgreSQL, Redis, etc.)
pnpm docker:up

# Start all applications in development mode
pnpm dev
```

### 2. Work on Specific Application

```bash
# Web app
pnpm dev:web

# Mobile app
pnpm dev:mobile

# Admin dashboard
pnpm dev:admin

# Backend API
pnpm dev:backend
```

### 3. Make Changes to Shared Packages

When you modify a shared package:

1. Make your changes in `shared/package-name/src/`
2. Build the package: `pnpm --filter @lutend/package-name build`
3. The consuming applications will automatically use the updated package

### 4. Run Tests

```bash
# All tests
pnpm test

# Specific workspace
pnpm test:web
pnpm test:backend
```

### 5. Lint and Format

```bash
# Lint all code
pnpm lint

# Format all code
pnpm format

# Type check
pnpm type-check
```

## Adding a New Shared Package

1. Create directory: `shared/new-package/`
2. Create `package.json`:
   ```json
   {
     "name": "@lutend/new-package",
     "version": "1.0.0",
     "main": "dist/index.js",
     "types": "dist/index.d.ts"
   }
   ```
3. Create `tsconfig.json`
4. Create `src/index.ts`
5. Add to consuming packages:
   ```json
   {
     "dependencies": {
       "@lutend/new-package": "workspace:*"
     }
   }
   ```

## Backend Integration

### Generating Types and API Client

After making changes to the backend API:

1. Ensure backend is running and OpenAPI spec is available
2. Generate types: `pnpm generate:types`
3. Generate API client: `pnpm generate:api-client`
4. Rebuild shared packages: `pnpm --filter @lutend/types build && pnpm --filter @lutend/api-client build`

## Infrastructure

The `infrastructure/` directory contains Terraform configurations for deploying the platform.

See [infrastructure/README.md](./infrastructure/README.md) for details.

## CI/CD

GitHub Actions workflows are configured for:

- Backend CI/CD: `.github/workflows/backend-ci.yml`
- Web CI/CD: `.github/workflows/web-ci.yml`
- Mobile CI/CD: `.github/workflows/mobile-ci.yml`
- Admin CI/CD: `.github/workflows/admin-ci.yml`
- Infrastructure validation: `.github/workflows/infrastructure.yml`

## Troubleshooting

### Dependency Issues

```bash
# Clear all node_modules and reinstall
pnpm clean
pnpm install
```

### Build Issues

```bash
# Rebuild all shared packages
pnpm --filter "./shared/*" build
```

### Type Errors

```bash
# Regenerate types from backend
pnpm generate:types
pnpm --filter @lutend/types build
```

## Best Practices

1. **Always use workspace dependencies** for internal packages
2. **Keep shared packages focused** - each should have a single responsibility
3. **Build shared packages** before using them in applications
4. **Run tests** before committing changes
5. **Use consistent naming** - all shared packages use `@lutend/` prefix
6. **Document changes** in package READMEs
7. **Version together** - all packages share the same version number

## Resources

- [PNPM Workspaces Documentation](https://pnpm.io/workspaces)
- [Monorepo Best Practices](https://monorepo.tools/)
- [TypeScript Project References](https://www.typescriptlang.org/docs/handbook/project-references.html)
