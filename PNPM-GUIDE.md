# PNPM Guide for Lutend Monorepo

This guide provides comprehensive information about using PNPM in the Lutend monorepo, including installation, common commands, workspace management, and troubleshooting.

## Table of Contents

- [What is PNPM?](#what-is-pnpm)
- [Why PNPM for This Monorepo?](#why-pnpm-for-this-monorepo)
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Workspace Management](#workspace-management)
- [Dependency Management](#dependency-management)
- [Common Workflows](#common-workflows)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Migration from npm/yarn](#migration-from-npmyarn)

## What is PNPM?

PNPM (Performant NPM) is a fast, disk space-efficient package manager for JavaScript. It uses a content-addressable store to save disk space and boost installation speed.

### Key Features

- **Disk Space Efficiency**: Packages are stored once in a global store and linked to projects
- **Fast Installation**: Significantly faster than npm and yarn
- **Strict Dependencies**: Prevents access to undeclared dependencies (no phantom dependencies)
- **Monorepo Support**: First-class workspace support with the workspace protocol
- **Compatible**: Drop-in replacement for npm with similar CLI commands

## Why PNPM for This Monorepo?

The Lutend monorepo uses PNPM for several reasons:

1. **Workspace Protocol**: Seamless linking between packages (web, mobile, admin, shared packages)
2. **Disk Space**: Saves significant space when multiple projects share dependencies
3. **Speed**: Faster installations and updates compared to npm/yarn
4. **Strict Mode**: Prevents accidental dependency usage, ensuring clean dependency trees
5. **Reproducibility**: Lockfile ensures consistent installations across environments

## Installation

### Prerequisites

- Node.js >= 18.0.0 (use [nvm](https://github.com/nvm-sh/nvm) or [fnm](https://github.com/Schniz/fnm))

### Installation Methods

#### Using npm (Recommended)

```bash
npm install -g pnpm@8
```

#### Using Homebrew (macOS)

```bash
brew install pnpm
```

#### Using Standalone Script

```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

#### Using Corepack (Node.js 16.13+)

```bash
corepack enable
corepack prepare pnpm@8 --activate
```

### Verify Installation

```bash
pnpm --version
# Should output: 8.x.x or higher
```

### Update PNPM

```bash
pnpm add -g pnpm
```

## Basic Commands

PNPM commands are similar to npm, making it easy to switch:

| npm Command            | PNPM Command          | Description                    |
| ---------------------- | --------------------- | ------------------------------ |
| `npm install`          | `pnpm install`        | Install all dependencies       |
| `npm install <pkg>`    | `pnpm add <pkg>`      | Add a dependency               |
| `npm install -D <pkg>` | `pnpm add -D <pkg>`   | Add a dev dependency           |
| `npm uninstall <pkg>`  | `pnpm remove <pkg>`   | Remove a dependency            |
| `npm update`           | `pnpm update`         | Update dependencies            |
| `npm run <script>`     | `pnpm <script>`       | Run a script (no "run" needed) |
| `npm list`             | `pnpm list`           | List installed packages        |
| `npx <command>`        | `pnpm exec <command>` | Execute a package binary       |

### Common PNPM Commands

```bash
# Install dependencies
pnpm install              # Install all dependencies
pnpm i                    # Shorthand

# Add dependencies
pnpm add react            # Add to dependencies
pnpm add -D typescript    # Add to devDependencies
pnpm add -O lodash        # Add to optionalDependencies
pnpm add -g pnpm          # Install globally

# Remove dependencies
pnpm remove react         # Remove a package
pnpm rm react             # Shorthand

# Update dependencies
pnpm update               # Update all dependencies
pnpm up                   # Shorthand
pnpm update react         # Update specific package
pnpm update --latest      # Update to latest versions (ignoring semver)

# Run scripts
pnpm dev                  # Run "dev" script
pnpm test                 # Run "test" script
pnpm build                # Run "build" script

# Execute binaries
pnpm exec playwright test # Execute a package binary
pnpm dlx create-react-app # Download and execute (like npx)

# List packages
pnpm list                 # List installed packages
pnpm list --depth 0       # List top-level packages only
pnpm list react           # Check if package is installed

# Other useful commands
pnpm why react            # Show why a package is installed
pnpm outdated             # Check for outdated packages
pnpm audit                # Check for security vulnerabilities
```

## Workspace Management

The Lutend monorepo uses PNPM workspaces defined in `pnpm-workspace.yaml`:

```yaml
packages:
  - "web"
  - "mobile"
  - "admin"
  - "shared/*"
```

### Workspace Commands

#### Filter by Workspace

Use the `--filter` (or `-F`) flag to target specific workspaces:

```bash
# Run command in a specific workspace
pnpm --filter web dev
pnpm --filter mobile start
pnpm --filter admin build

# Run command in multiple workspaces
pnpm --filter web --filter admin dev

# Run command in all workspaces matching a pattern
pnpm --filter "@lutend/*" build
```

#### Recursive Commands

Run commands across all workspaces:

```bash
# Run in all workspaces (sequentially)
pnpm -r dev

# Run in all workspaces (parallel)
pnpm --parallel dev

# Run in all workspaces with specific script
pnpm -r test
pnpm -r build
```

#### Workspace-Specific Installation

```bash
# Add dependency to specific workspace
pnpm --filter web add axios
pnpm --filter mobile add react-native-gesture-handler

# Add dev dependency
pnpm --filter web add -D @types/react

# Add shared package as dependency
pnpm --filter web add @lutend/types@workspace:*
pnpm --filter admin add @lutend/api-client@workspace:*
```

### Workspace Protocol

The `workspace:*` protocol links local packages:

```json
{
  "dependencies": {
    "@lutend/types": "workspace:*",
    "@lutend/api-client": "workspace:*"
  }
}
```

Benefits:

- Always uses the local version during development
- Automatically resolves to the correct version when publishing
- Changes to shared packages are immediately available

## Dependency Management

### Adding Dependencies

```bash
# Add to root (for tooling shared across all workspaces)
pnpm add -D -w typescript

# Add to specific workspace
pnpm --filter web add react-query
pnpm --filter mobile add @react-navigation/native

# Add shared package
pnpm --filter web add @lutend/types@workspace:*
```

### Updating Dependencies

```bash
# Update all dependencies
pnpm update

# Update specific package
pnpm update react

# Update to latest (ignoring semver)
pnpm update --latest

# Update in specific workspace
pnpm --filter web update react

# Interactive update
pnpm update --interactive
```

### Removing Dependencies

```bash
# Remove from specific workspace
pnpm --filter web remove axios

# Remove from all workspaces
pnpm -r remove lodash
```

### Checking Dependencies

```bash
# List all dependencies
pnpm list

# List dependencies in specific workspace
pnpm --filter web list

# Check why a package is installed
pnpm why react

# Check for outdated packages
pnpm outdated

# Check for security vulnerabilities
pnpm audit
```

## Common Workflows

### Starting Development

```bash
# Install all dependencies
pnpm install

# Start all applications
pnpm dev

# Start specific application
pnpm dev:web
pnpm dev:mobile
pnpm dev:admin
```

### Building Applications

```bash
# Build all applications
pnpm build

# Build specific application
pnpm build:web
pnpm build:mobile
pnpm build:admin
```

### Running Tests

```bash
# Run all tests
pnpm test

# Run tests for specific application
pnpm test:web
pnpm test:mobile
pnpm test:backend
```

### Linting and Formatting

```bash
# Lint all code
pnpm lint

# Lint specific application
pnpm lint:web

# Format all code
pnpm format

# Format specific application
pnpm format:web
```

### Working with Shared Packages

```bash
# Generate types from backend OpenAPI
pnpm generate:types

# Generate API client
pnpm generate:api-client

# Build shared package
pnpm --filter @lutend/types build

# Watch mode for shared package
pnpm --filter @lutend/components dev
```

### Adding a New Workspace

1. Create the workspace directory:

   ```bash
   mkdir new-app
   cd new-app
   pnpm init
   ```

2. Add to `pnpm-workspace.yaml`:

   ```yaml
   packages:
     - "new-app"
   ```

3. Install dependencies:

   ```bash
   pnpm install
   ```

4. Add shared packages:
   ```bash
   pnpm --filter new-app add @lutend/types@workspace:*
   ```

## Best Practices

### 1. Use Workspace Protocol for Local Packages

Always use `workspace:*` for local package dependencies:

```json
{
  "dependencies": {
    "@lutend/types": "workspace:*"
  }
}
```

### 2. Install from Root

Always run `pnpm install` from the root directory to ensure all workspaces are in sync.

### 3. Use Filters for Workspace-Specific Commands

```bash
# Good
pnpm --filter web add axios

# Avoid (unless you want to add to all workspaces)
cd web && pnpm add axios
```

### 4. Commit the Lockfile

Always commit `pnpm-lock.yaml` to ensure reproducible installations:

```bash
git add pnpm-lock.yaml
git commit -m "Update dependencies"
```

### 5. Use Scripts in Root package.json

Define common scripts in the root `package.json` for convenience:

```json
{
  "scripts": {
    "dev": "pnpm --parallel dev",
    "dev:web": "pnpm --filter web dev",
    "build": "pnpm -r build",
    "test": "pnpm -r test"
  }
}
```

### 6. Keep Dependencies Up to Date

Regularly check for and update outdated dependencies:

```bash
pnpm outdated
pnpm update --interactive
```

### 7. Use Strict Mode

PNPM's strict mode prevents phantom dependencies. Don't disable it unless absolutely necessary.

### 8. Clean Install for CI/CD

Use `pnpm install --frozen-lockfile` in CI/CD to ensure exact versions:

```bash
pnpm install --frozen-lockfile
```

## Troubleshooting

### Issue: "Cannot find module" Error

**Cause**: Package not properly installed or linked.

**Solution**:

```bash
# Remove node_modules and reinstall
rm -rf node_modules
pnpm install

# Or clean and reinstall
pnpm store prune
pnpm install
```

### Issue: Workspace Package Not Found

**Cause**: Workspace not properly configured or package name mismatch.

**Solution**:

1. Check `pnpm-workspace.yaml` includes the workspace directory
2. Verify package name in `package.json` matches the import
3. Reinstall dependencies:
   ```bash
   pnpm install
   ```

### Issue: Phantom Dependency Error

**Cause**: Trying to import a package that's not declared in `package.json`.

**Solution**:
Add the missing dependency:

```bash
pnpm --filter <workspace> add <package>
```

### Issue: Peer Dependency Warnings

**Cause**: Peer dependency version mismatch.

**Solution**:

```bash
# Install peer dependencies
pnpm install

# Or use --force to override
pnpm install --force
```

### Issue: Slow Installation

**Cause**: Network issues or corrupted store.

**Solution**:

```bash
# Clear store and reinstall
pnpm store prune
pnpm install

# Use a different registry
pnpm install --registry https://registry.npmjs.org/
```

### Issue: Lockfile Conflicts

**Cause**: Multiple people updating dependencies simultaneously.

**Solution**:

```bash
# Resolve conflicts in pnpm-lock.yaml
git checkout --theirs pnpm-lock.yaml  # or --ours
pnpm install
```

### Issue: "ENOSPC: System limit for number of file watchers reached"

**Cause**: Too many files being watched (common on Linux).

**Solution**:

```bash
# Increase the limit
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Issue: Permission Errors

**Cause**: Incorrect file permissions.

**Solution**:

```bash
# Fix permissions
sudo chown -R $(whoami) ~/.pnpm-store
sudo chown -R $(whoami) node_modules
```

### Issue: Outdated PNPM Version

**Cause**: Using an old version of PNPM.

**Solution**:

```bash
# Update PNPM
pnpm add -g pnpm

# Or using npm
npm install -g pnpm@latest
```

### Issue: Cache Issues

**Cause**: Corrupted cache.

**Solution**:

```bash
# Clear cache
pnpm store prune

# Or remove store completely
rm -rf ~/.pnpm-store
pnpm install
```

### Issue: Workspace Script Not Found

**Cause**: Script doesn't exist in workspace's `package.json`.

**Solution**:

1. Check if script exists in the workspace's `package.json`
2. Add the script if missing
3. Or use a different script name

### Issue: Build Failures After Dependency Update

**Cause**: Breaking changes in updated dependencies.

**Solution**:

```bash
# Revert to previous lockfile
git checkout HEAD~1 pnpm-lock.yaml
pnpm install

# Or update one package at a time
pnpm update <package>
```

## Migration from npm/yarn

### From npm

1. Remove `package-lock.json` and `node_modules`:

   ```bash
   rm -rf package-lock.json node_modules
   ```

2. Install PNPM:

   ```bash
   npm install -g pnpm
   ```

3. Import dependencies:

   ```bash
   pnpm import  # Converts package-lock.json to pnpm-lock.yaml
   ```

4. Install dependencies:
   ```bash
   pnpm install
   ```

### From Yarn

1. Remove `yarn.lock` and `node_modules`:

   ```bash
   rm -rf yarn.lock node_modules
   ```

2. Install PNPM:

   ```bash
   npm install -g pnpm
   ```

3. Install dependencies:
   ```bash
   pnpm install
   ```

### Update Scripts

Replace npm/yarn commands in scripts:

```json
{
  "scripts": {
    "dev": "pnpm dev",
    "build": "pnpm build",
    "test": "pnpm test"
  }
}
```

### Update CI/CD

Update CI/CD workflows to use PNPM:

```yaml
# GitHub Actions example
- name: Install PNPM
  uses: pnpm/action-setup@v2
  with:
    version: 8

- name: Install dependencies
  run: pnpm install --frozen-lockfile
```

## Additional Resources

- [PNPM Official Documentation](https://pnpm.io/)
- [PNPM Workspaces](https://pnpm.io/workspaces)
- [PNPM CLI Reference](https://pnpm.io/cli/add)
- [PNPM vs npm vs Yarn](https://pnpm.io/benchmarks)

## Getting Help

If you encounter issues not covered in this guide:

1. Check the [PNPM documentation](https://pnpm.io/)
2. Search [PNPM GitHub issues](https://github.com/pnpm/pnpm/issues)
3. Ask in the team's Slack channel
4. Create an issue in the project repository

---

**Last Updated**: November 2024
