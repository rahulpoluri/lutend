# Lutend Mobile App

React Native mobile application for iOS and Android.

## Prerequisites

- **Node.js** >= 18.0.0 (use nvm or fnm for version management)
- **PNPM** >= 8.0.0 (required for monorepo workspace management)
- **Xcode** (for iOS development, macOS only)
- **Android Studio** (for Android development)
- **CocoaPods** (for iOS dependencies, macOS only)

This project is part of the Lutend monorepo. See the [root README](../README.md) and [PNPM-GUIDE](../PNPM-GUIDE.md) for more information.

## Setup

### Option 1: Using PNPM from Root (Recommended)

```bash
# From the root directory
pnpm install              # Install all dependencies
pnpm dev:mobile           # Start Metro bundler
```

### Option 2: Working Directly in the Mobile Directory

1. **Install dependencies:**

   From the root directory (this installs dependencies for all workspaces):

   ```bash
   cd ..  # Go to root if you're in mobile/
   pnpm install
   ```

2. **Install iOS dependencies (macOS only):**

   ```bash
   cd mobile/ios && pod install && cd ../..
   ```

3. **Start Metro bundler:**

   ```bash
   cd mobile
   pnpm start
   ```

   Or from the root:

   ```bash
   pnpm dev:mobile
   ```

4. **Run on iOS:**

   ```bash
   cd mobile
   pnpm ios
   ```

5. **Run on Android:**

   ```bash
   cd mobile
   pnpm android
   ```

## Development

This app uses:

- **React Native** for cross-platform mobile development
- **TypeScript** for type safety
- **React Navigation** for navigation
- **Redux Toolkit** or **Zustand** for state management
- **React Query** for server state management

### Shared Packages

The mobile app uses shared packages from the monorepo:

- `@lutend/types` - TypeScript types generated from backend OpenAPI
- `@lutend/api-client` - Type-safe API client
- `@lutend/design-tokens` - Design system tokens
- `@lutend/utils` - Shared utility functions

These are automatically linked via PNPM workspaces. Changes to shared packages are immediately available.

### Adding Shared Packages

To add a shared package to the mobile app:

```bash
# From root directory
pnpm --filter mobile add @lutend/types@workspace:*

# Or from mobile/ directory
pnpm add @lutend/types@workspace:*
```

## Available Scripts

```bash
pnpm start            # Start Metro bundler
pnpm ios              # Run on iOS simulator
pnpm android          # Run on Android emulator
pnpm test             # Run tests
pnpm lint             # Lint code
pnpm type-check       # Run TypeScript type checking
```

## Testing

Run tests:

```bash
# From root directory
pnpm test:mobile

# Or from mobile/ directory
pnpm test
```

## Building

### iOS

```bash
cd ios
xcodebuild -workspace Lutend.xcworkspace -scheme Lutend -configuration Release
```

Or use Xcode to build and archive.

### Android

```bash
cd android
./gradlew assembleRelease
```

The APK will be available at `android/app/build/outputs/apk/release/`.

## Troubleshooting

### Metro Bundler Issues

```bash
# Clear Metro cache
pnpm start --reset-cache

# Or
rm -rf $TMPDIR/metro-*
```

### iOS Build Issues

```bash
# Clean iOS build
cd ios
xcodebuild clean
rm -rf ~/Library/Developer/Xcode/DerivedData
pod install
```

### Android Build Issues

```bash
# Clean Android build
cd android
./gradlew clean
```

### Dependency Issues

```bash
# Reinstall dependencies
cd ..  # Go to root
rm -rf node_modules mobile/node_modules
pnpm install
cd mobile/ios && pod install
```

For more troubleshooting tips, see [PNPM-GUIDE.md](../PNPM-GUIDE.md).
