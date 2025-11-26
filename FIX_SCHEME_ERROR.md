# Fix: Xcode Scheme Not Found Error

## The Problem
```
xcodebuild: error: The workspace named "greatfeel" does not contain a scheme named "greatfeel".
```

This error occurs when the Xcode workspace doesn't properly contain the scheme or when CocoaPods dependencies aren't properly installed.

## Solution

### Step 1: Clean and Reinstall CocoaPods
Run these commands from the **project root** directory:

```bash
# Navigate to iOS directory
cd ios

# Remove existing Pods and workspace
rm -rf Pods
rm -rf greatfeel.xcworkspace
rm -f Podfile.lock

# Clean build artifacts
rm -rf build
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Reinstall pods
pod deintegrate
pod install

# Go back to project root
cd ..
```

### Step 2: Verify the Scheme Exists
After running pod install, verify the scheme:

```bash
cd ios
xcodebuild -workspace greatfeel.xcworkspace -list
```

You should see "greatfeel" listed under **Schemes**.

### Step 3: Run the App
From the **project root**:

```bash
npx react-native run-ios
```

Or to run on a specific device/simulator:

```bash
# For simulator
npx react-native run-ios --simulator="iPhone 15 Pro"

# For physical device
npx react-native run-ios --device="Your Device Name"
```

## Alternative: Use Xcode Directly

If the above doesn't work:

1. Open `ios/greatfeel.xcworkspace` (NOT .xcodeproj) in Xcode
2. In Xcode, go to **Product → Scheme → Manage Schemes**
3. Make sure "greatfeel" scheme exists and is **Shared** (checkbox enabled)
4. If it doesn't exist, click **+** to create it:
   - Choose **greatfeel** as the target
   - Enable "Shared" checkbox
5. Close Xcode and try running again

## Common Issues

### Issue: "No podspec found"
If you see CocoaPods errors:
```bash
cd ios
pod repo update
pod install
cd ..
```

### Issue: "Command PhaseScriptExecution failed"
Clear caches:
```bash
# Clear Metro bundler cache
npx react-native start --reset-cache

# In a new terminal
npx react-native run-ios
```

### Issue: Still not working?
Full clean rebuild:
```bash
cd ios
./clean-build.sh  # If this script exists
# OR manually:
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf build
rm -rf Pods
pod install
cd ..
npx react-native run-ios
```

## Prevention

Always use the **workspace** file when opening in Xcode:
- ✅ Open `ios/greatfeel.xcworkspace`
- ❌ Don't open `ios/greatfeel.xcodeproj`

The workspace includes all CocoaPods dependencies, while the project file alone doesn't.
