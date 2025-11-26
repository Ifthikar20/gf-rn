# iOS Setup Instructions

## Problem

You encountered these errors:
- `-llibevent` in build setting 'OTHER_LDFLAGS'
- `expo-av not available`
- `Cannot find native module 'ExponentAV'`
- App registration failure

## Root Cause

These errors occur because **iOS native dependencies (CocoaPods) haven't been installed**. CocoaPods can only be installed and run on **macOS** (not Linux or Windows).

## Solution

### On macOS:

1. **Run the automated setup script:**
   ```bash
   chmod +x setup-ios.sh
   ./setup-ios.sh
   ```

2. **Or manually:**
   ```bash
   # Install npm dependencies
   npm install

   # Install CocoaPods (if not already installed)
   sudo gem install cocoapods

   # Install iOS pods
   cd ios
   pod install
   cd ..
   ```

3. **Clean and rebuild:**
   ```bash
   # Clean build folders
   cd ios
   rm -rf build
   pod deintegrate  # Only if you had previous pod installations
   pod install
   cd ..

   # Run the app
   npm run ios
   ```

### Alternative: Use React Native CLI

If the npm script doesn't work:
```bash
npx react-native run-ios
```

### Opening in Xcode

1. Navigate to `ios/` folder
2. Open `greatfeel.xcworkspace` (NOT greatfeel.xcodeproj)
3. Select your target device/simulator
4. Press Run (⌘R)

## Background Audio Feature

The app uses `expo-av` for background audio (rain sounds). This requires native iOS modules. Once you run `pod install` on macOS:

1. Uncomment the `useBackgroundAudio()` line in `src/App.tsx`
2. Rebuild the app

## Troubleshooting

### Error: "command not found: pod"
```bash
sudo gem install cocoapods
```

### Error: "Unable to find a specification for..."
```bash
cd ios
pod repo update
pod install
```

### Error: Build failures after pod install
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

### Clear Metro bundler cache
```bash
npm start -- --reset-cache
```

## Environment Requirements

- **macOS** (required for iOS development)
- **Xcode** (latest stable version)
- **Node.js** >= 18
- **CocoaPods** (for native dependencies)
- **iOS Simulator** or physical iPhone for testing
