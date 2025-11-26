#!/bin/bash

# ============================================
# Great Feel iOS Build and Run Script
# ============================================

set -e  # Exit on error

echo "🚀 Starting build process..."

# Navigate to project directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$PROJECT_DIR"

echo "📂 Project directory: $PROJECT_DIR"

# Stop Metro bundler
echo "🛑 Stopping any running Metro bundler..."
killall -9 node 2>/dev/null || true
sleep 2

# Clean everything
echo "🧹 Cleaning build artifacts..."
rm -rf node_modules
rm -rf ios/Pods
rm -rf ios/build
rm -rf ~/Library/Developer/Xcode/DerivedData/greatfeel-*
rm -rf /tmp/metro-*
rm -rf /tmp/haste-map-*

echo "✅ Cleanup complete"

# Install dependencies
echo "📦 Installing npm dependencies..."
npm install

echo "✅ npm dependencies installed"

# Install iOS pods
echo "📦 Installing iOS pods (this may take a few minutes)..."
cd ios
pod install
cd ..

echo "✅ iOS pods installed"

# Start Metro bundler in background
echo "🔄 Starting Metro bundler with clean cache..."
npx react-native start --reset-cache > /tmp/metro.log 2>&1 &
METRO_PID=$!

echo "⏳ Waiting for Metro to start (15 seconds)..."
sleep 15

# Check if Metro is running
if ! ps -p $METRO_PID > /dev/null; then
    echo "❌ Metro bundler failed to start. Check /tmp/metro.log for details"
    cat /tmp/metro.log
    exit 1
fi

echo "✅ Metro bundler is running (PID: $METRO_PID)"

# Build and run on simulator
echo "🔨 Building and running app on iPhone 15 Pro simulator..."
echo "   This will take several minutes on first build..."

npx react-native run-ios --simulator="iPhone 15 Pro"

echo ""
echo "✅ Build complete!"
echo ""
echo "📱 App should now be running on the simulator"
echo "📋 Metro bundler is running in background (PID: $METRO_PID)"
echo "   Log file: /tmp/metro.log"
echo ""
echo "To stop Metro bundler, run:"
echo "   kill $METRO_PID"
echo ""
echo "To view Metro logs, run:"
echo "   tail -f /tmp/metro.log"
echo ""
