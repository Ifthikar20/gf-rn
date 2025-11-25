# Quick Build Commands

## Run iOS App (iPhone 14 Pro)

Single command to clean, build, and launch:

```bash
./run-ios.sh
```

Or as a one-liner from anywhere in the project:

```bash
cd ~/Desktop/gf-rn/gf-rn && ./run-ios.sh
```

### What This Does:
1. ✅ Cleans build artifacts
2. ✅ Removes extended attributes (fixes codesign errors)
3. ✅ Removes .DS_Store files
4. ✅ Builds the app
5. ✅ Launches iPhone 14 Pro simulator automatically

### Different Simulator?

To use a different simulator:

```bash
# iPhone 15 Pro
npx react-native run-ios --simulator="iPhone 15 Pro"

# iPhone SE
npx react-native run-ios --simulator="iPhone SE (3rd generation)"

# List all available simulators
xcrun simctl list devices available
```

### Manual Build (if script fails)

```bash
cd ios
rm -rf build && xattr -cr . && find . -name ".DS_Store" -type f -delete
cd ..
npx react-native run-ios --simulator="iPhone 14 Pro"
```

## Troubleshooting

### If you get "Permission denied" error:
```bash
# Error: sh: node_modules/.bin/react-native: Permission denied

# Quick fix:
./fix-permissions.sh

# Or manually:
chmod +x node_modules/.bin/*
```

This happens when npm/yarn installation doesn't set execute permissions correctly.

### If you get codesign errors:
```bash
cd ios
./quick-fix-codesign.sh
cd ..
npx react-native run-ios --simulator="iPhone 14 Pro"
```

### For persistent issues:
```bash
cd ios
./clean-build.sh
cd ..
npx react-native run-ios --simulator="iPhone 14 Pro"
```

See `ios/IOS_BUILD_FIXES.md` for detailed troubleshooting.
