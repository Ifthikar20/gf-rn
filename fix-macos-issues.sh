#!/bin/bash
# Run this script on your macOS machine to fix all issues

set -e

echo "🔧 Fixing all issues on macOS..."
echo ""

# 1. Reset Watchman (fixes stale cache)
echo "📦 Resetting Watchman cache..."
if command -v watchman &> /dev/null; then
    watchman watch-del-all
    watchman shutdown-server
    echo "✅ Watchman reset complete"
else
    echo "⚠️  Watchman not installed - installing via Homebrew..."
    brew install watchman
fi
echo ""

# 2. Kill Metro and clear all caches
echo "🧹 Clearing all Metro caches..."
killall -9 node 2>/dev/null || true
rm -rf /tmp/metro-* 2>/dev/null || true
rm -rf /tmp/haste-map-* 2>/dev/null || true
rm -rf $TMPDIR/react-* 2>/dev/null || true
echo "✅ Metro caches cleared"
echo ""

# 3. Clean iOS build
echo "🧹 Cleaning iOS build artifacts..."
cd ios
rm -rf build
rm -rf Pods
rm -rf Podfile.lock
cd ..
echo "✅ iOS build cleaned"
echo ""

# 4. Install pods
echo "💎 Installing CocoaPods dependencies..."
cd ios
pod install
cd ..
echo "✅ Pods installed successfully"
echo ""

# 5. Clear npm cache and reinstall
echo "📦 Reinstalling npm dependencies..."
rm -rf node_modules
npm install
echo "✅ npm dependencies installed"
echo ""

echo "✅ All fixes applied!"
echo ""
echo "Now run:"
echo "  npm run start:fresh"
echo ""
echo "In another terminal:"
echo "  npx react-native run-ios"
echo ""
