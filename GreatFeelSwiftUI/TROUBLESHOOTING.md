# Troubleshooting Guide

Common issues and solutions for GreatFeel SwiftUI.

## Issue: "No bundle URL present" Error in Simulator

### Symptoms

You see this error in the simulator:
```
No bundle URL present.

Make sure you're running a packager server or have included a .jsbundle file in your application bundle.

RCTFatal
__28-[RCTCxxBridge handleError:]_block_invoke
```

### Root Cause

This is the **old React Native app** still installed on the simulator. The error mentions React Native components (RCTFatal, RCTCxxBridge), which don't exist in the new SwiftUI version.

### Solution

Run the cleanup script to remove the old app and install the fresh SwiftUI app:

```bash
cd ~/Desktop/gf-rn/gf-rn/GreatFeelSwiftUI
./clean_and_run.sh
```

This script will:
1. Stop all running simulators
2. Remove old React Native apps
3. Clean all build artifacts
4. Build fresh SwiftUI app
5. Install and launch on simulator

### Manual Solution (Alternative)

If you prefer to do it manually:

1. **Reset the simulator**:
   ```bash
   # Erase all content and settings
   xcrun simctl erase "iPhone 15 Pro"
   ```

2. **Clean Xcode builds**:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*
   ```

3. **Build from Xcode**:
   - Open `GreatFeelSwiftUI.xcodeproj`
   - Select "iPhone 15 Pro" simulator
   - Press ⌘⇧K (Clean Build Folder)
   - Press ⌘R (Build and Run)

---

## Issue: Physical Device Deployment Failed

### Symptoms

```
Could not obtain access to one or more requested file system resources because CoreDevice was unable to create bookmark data.
Domain: com.apple.dt.CoreDeviceError
Code: 1005
```

### Root Cause

1. **Code signing not configured**
2. **iOS version mismatch**: Your iPhone (iOS 18.3.1) is newer than your Xcode SDK (iOS 17.5)

### Solution

**Option 1: Use Simulator (Recommended)**

Simulators don't have signing or version issues:

```bash
./build_simulator.sh
```

**Option 2: Configure Code Signing for Physical Device**

1. Open project in Xcode
2. Select project → GreatFeelSwiftUI target
3. Go to "Signing & Capabilities" tab
4. Check "Automatically manage signing"
5. Select your Team (Apple ID)
6. If needed, change Bundle Identifier to something unique

**Option 3: Update Xcode**

Your iPhone's iOS 18.3.1 requires Xcode 16+. Consider updating:
- Download latest Xcode from App Store
- Or continue using simulator with iOS 17.5

---

## Issue: Build Errors After Pull

### Symptoms

After pulling latest changes, build fails with syntax errors.

### Solution

Clean and rebuild:

```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*

# Rebuild
xcodebuild -project GreatFeelSwiftUI.xcodeproj \
  -scheme GreatFeelSwiftUI \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  clean build
```

---

## Issue: Simulator Not Launching

### Symptoms

Simulator doesn't open or app doesn't install.

### Solution

1. **Verify simulator is available**:
   ```bash
   xcrun simctl list devices available | grep iPhone
   ```

2. **Boot the simulator manually**:
   ```bash
   xcrun simctl boot "iPhone 15 Pro"
   open -a Simulator
   ```

3. **If simulator crashes**, reset it:
   ```bash
   xcrun simctl shutdown all
   xcrun simctl erase all
   ```

---

## Issue: App Crashes on Launch

### Check Console Logs

1. **In Xcode**:
   - Window → Devices and Simulators
   - Select your simulator
   - View Device Logs

2. **Command line**:
   ```bash
   xcrun simctl spawn booted log stream --level debug
   ```

### Common Causes

- **Missing environment objects**: Check that ThemeViewModel and AuthViewModel are properly injected
- **Asset loading issues**: Verify all images/assets exist in Assets.xcassets
- **API errors**: Check network connectivity if app uses remote APIs

---

## Issue: Xcode Can't Find Project Files

### Symptoms

```
error: no such file or directory: '/path/to/SomeFile.swift'
```

### Solution

Regenerate the Xcode project:

```bash
./setup_and_build.sh
```

This runs `generate_xcode_project.py` which scans all Swift files and recreates the .xcodeproj.

---

## Getting Help

If none of these solutions work:

1. **Check build logs**:
   - Look for `build_log.txt`, `simulator_build.txt`, or `clean_build.txt`
   - Search for lines containing `error:`

2. **Verify file structure**:
   ```bash
   find GreatFeelSwiftUI -name "*.swift" | wc -l
   # Should show ~34 files
   ```

3. **Start fresh**:
   ```bash
   # Clean everything
   rm -rf GreatFeelSwiftUI.xcodeproj
   rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*

   # Regenerate and build
   ./setup_and_build.sh
   ```

---

## Quick Reference Commands

| Task | Command |
|------|---------|
| Clean build & run | `./clean_and_run.sh` |
| Build for simulator | `./build_simulator.sh` |
| Open in Xcode | `open GreatFeelSwiftUI.xcodeproj` |
| List simulators | `xcrun simctl list devices` |
| Reset simulator | `xcrun simctl erase "iPhone 15 Pro"` |
| Clean DerivedData | `rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*` |
| Regenerate project | `./setup_and_build.sh` |

---

## Understanding Your Setup

**Current Configuration:**
- **Xcode**: 15.4 (iOS 17.5 SDK)
- **Your iPhone**: iOS 18.3.1
- **Project**: Pure SwiftUI (no React Native)

**Recommendations:**
- ✅ Use **simulators** for daily development
- ✅ Use **iPhone 15 Pro (iOS 17.5)** simulator
- ⚠️ Physical device testing requires Xcode 16+ for iOS 18 support
