#!/bin/bash
# Complete clean rebuild for iOS
# Clears all caches and rebuilds from scratch

set -e

echo "🧹 Starting complete clean rebuild process..."
echo ""

# Kill all Node and Metro processes
echo "Killing Metro and Node processes..."
killall -9 node 2>/dev/null || true
killall -9 Metro 2>/dev/null || true
killall -9 React 2>/dev/null || true
sleep 2

# Clear Watchman
echo "Clearing Watchman cache..."
if command -v watchman &> /dev/null; then
    watchman watch-del-all 2>/dev/null || true
    watchman shutdown-server 2>/dev/null || true
fi

# Clear Metro cache
echo "Clearing Metro cache..."
rm -rf /tmp/metro-* 2>/dev/null || true
rm -rf /tmp/haste-map-* 2>/dev/null || true
rm -rf $TMPDIR/react-* 2>/dev/null || true
rm -rf $TMPDIR/metro-* 2>/dev/null || true

# Clear Xcode derived data
echo "Clearing Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/greatfeel-* 2>/dev/null || true

# Clean iOS build
echo "Cleaning iOS build..."
cd ios
rm -rf build 2>/dev/null || true
xcodebuild clean -workspace greatfeel.xcworkspace -scheme greatfeel 2>/dev/null || true
cd ..

echo ""
echo "✅ All caches cleared!"
echo ""
echo "🚀 Starting Metro bundler with fresh cache..."
npx react-native start --reset-cache &

echo "⏳ Waiting 15 seconds for Metro to start..."
sleep 15

echo ""
echo "📱 Building and launching on simulator..."
npx react-native run-ios --simulator="iPhone 15 Pro"

echo ""
echo "✅ Done!"
