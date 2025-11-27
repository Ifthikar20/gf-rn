# Run on iOS Simulator

This guide shows you how to run GreatFeel on the iOS Simulator (no physical device needed).

## Quick Start

### Option 1: Command Line (Easiest)

Run the automated script:

```bash
cd ~/Desktop/gf-rn/gf-rn/GreatFeelSwiftUI
./build_simulator.sh
```

This will:
- Clean previous builds
- Build for simulator
- Launch the simulator
- Install and run your app

### Option 2: Using Xcode

1. **Open the project**:
   ```bash
   cd ~/Desktop/gf-rn/gf-rn/GreatFeelSwiftUI
   open GreatFeelSwiftUI.xcodeproj
   ```

2. **Select a simulator**:
   - At the top of Xcode, click the device selector (next to the Play button)
   - Choose "iPhone 15 Pro" or "iPhone 14 Pro"

3. **Build and Run**:
   - Press `⌘R` (or click the Play ▶️ button)
   - The simulator will launch automatically

## Available Simulators

To see all available simulators on your Mac:

```bash
xcrun simctl list devices available | grep iPhone
```

Common simulators in Xcode 15.4:
- iPhone 15 Pro (iOS 17.5)
- iPhone 15 (iOS 17.5)
- iPhone 14 Pro (iOS 17.5)
- iPhone SE (3rd generation) (iOS 17.5)

## Troubleshooting

### Error: "Could not obtain access to file system resources"

This happens when Xcode tries to deploy to your physical iPhone. Solutions:

1. **Disconnect your iPhone** from the Mac
2. **OR** explicitly select a simulator in Xcode's device selector
3. **OR** use the `build_simulator.sh` script which forces simulator builds

### Error: "Simulator not available"

```bash
# List available simulators
xcrun simctl list devices

# If none are available, you may need to install iOS 17.5 runtime:
# Xcode → Settings → Platforms → Download iOS 17.5 Simulator
```

### Clean Build Issues

If you encounter build cache issues:

```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*

# Clean build folder in Xcode
# Press ⌘⇧K (Product → Clean Build Folder)
```

## iOS Version Compatibility

Your setup:
- **Xcode 15.4** with **iOS 17.5 SDK**
- Simulators will run **iOS 17.5**

This is perfect for development! Simulators don't have the iOS version mismatch issues that physical devices can have.

## Why Use Simulator?

✅ **Advantages**:
- No code signing required
- Faster deployment
- No device connection issues
- Can test different screen sizes easily
- Debug tools work better

⚠️ **Limitations**:
- Can't test device-specific features (camera, accelerometer, etc.)
- Performance may differ from real devices
- Some APIs behave differently

## Next Steps

Once your app works on simulator, you can:
1. Test on physical device for final validation
2. Configure code signing for App Store distribution
3. Test device-specific features

---

**Quick Commands**:
- Build for simulator: `./build_simulator.sh`
- Open in Xcode: `open GreatFeelSwiftUI.xcodeproj`
- Clean builds: `rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*`
