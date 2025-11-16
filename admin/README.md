# Lutend Admin Dashboard

React web application for Lutend staff to manage users, content, and platform operations.

## Prerequisites

- **Node.js** >= 18.0.0 (use nvm or fnm for version management)
- **PNPM** >= 8.0.0 (required for monorepo workspace management)

This project is part of the Lutend monorepo. See the [root README](../README.md) and [PNPM-GUIDE](../PNPM-GUIDE.md) for more information.

## Setup

### Option 1: Using PNPM from Root (Recommended)

```bash
# From the root directory
pnpm dev:admin        # Start development server
pnpm build:admin      # Build for production
pnpm test:admin       # Run tests
```

### Option 2: Working Directly in the Admin Directory

1. **Install dependencies:**

   From the root directory (this installs dependencies for all workspaces):

   ```bash
   cd ..  # Go to root if you're in admin/
   pnpm install
   ```

2. **Start development server:**

   ```bash
   cd admin
   pnpm dev
   ```

   Or from the root:

   ```bash
   pnpm dev:admin
   ```

3. **Open browser to http://localhost:5173**

## Development

This app uses:

- **React** for UI
- **Vite** for fast development and building
- **TypeScript** for type safety
- **React Router** for navigation
- **Chakra UI** for UI components
- **TanStack Query** for server state management

### Shared Packages

The admin dashboard uses shared packages from the monorepo:

- `@lutend/types` - TypeScript types generated from backend OpenAPI
- `@lutend/api-client` - Type-safe API client
- `@lutend/components` - Shared UI components
- `@lutend/design-tokens` - Design system tokens
- `@lutend/utils` - Shared utility functions

These are automatically linked via PNPM workspaces. Changes to shared packages are immediately available.

### Adding Shared Packages

To add a shared package to the admin dashboard:

```bash
# From root directory
pnpm --filter admin add @lutend/types@workspace:*

# Or from admin/ directory
pnpm add @lutend/types@workspace:*
```

## Available Scripts

```bash
pnpm dev              # Start development server
pnpm build            # Build for production
pnpm preview          # Preview production build
pnpm test             # Run tests
pnpm lint             # Lint code
pnpm format           # Format code
pnpm type-check       # Run TypeScript type checking
```

## Testing

Run tests:

```bash
# From root directory
pnpm test:admin

# Or from admin/ directory
pnpm test
```

## Building

Build for production:

```bash
# From root directory
pnpm build:admin

# Or from admin/ directory
pnpm build
```

Preview production build:

```bash
pnpm preview
```

The build output will be in the `dist/` directory.

## Features

- **User Verification Management** - Review and approve/reject user verifications
- **User Moderation** - Ban, warn, and manage user accounts
- **Content Management System** - Create and manage articles and videos
- **Platform Analytics** - View metrics, charts, and insights
- **Support Ticket Management** - Handle user support requests
- **Payment and Credit Management** - Manage transactions and refunds
- **Report Management** - Review user reports with meeting logs

## Authentication

The admin dashboard uses separate authentication from the main app. Admin users must have the appropriate role assigned in the backend.

## Environment Variables

Create a `.env` file in the `admin/` directory:

```env
VITE_API_URL=http://localhost:8000
```

For production, set the appropriate API URL.

## Troubleshooting

### Port Already in Use

If port 5173 is already in use:

```bash
# Kill the process using the port
lsof -ti:5173 | xargs kill -9

# Or use a different port
pnpm dev --port 5174
```

### Build Errors

```bash
# Clear cache and rebuild
rm -rf node_modules dist
cd ..  # Go to root
pnpm install
cd admin
pnpm build
```

For more troubleshooting tips, see [PNPM-GUIDE.md](../PNPM-GUIDE.md).
