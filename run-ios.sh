#!/bin/bash

# One-command iOS build script with automatic simulator launch
# Fixes codesign errors and launches iPhone 14 Pro simulator

set -e  # Exit on error

echo "🚀 Starting iOS build process..."

# Navigate to iOS directory
cd "$(dirname "$0")/ios" || exit 1

# Clean extended attributes and build artifacts (fixes codesign errors)
echo "🧹 Cleaning build artifacts and extended attributes..."
rm -rf build
# Remove extended attributes (skip Pods directory to avoid permission warnings)
find . -type f -not -path "./Pods/*" -exec xattr -c {} \; 2>/dev/null || true
find . -name ".DS_Store" -type f -delete

# Go back to project root
cd ..

# Fix node_modules permissions if needed
echo "🔧 Ensuring node_modules permissions are correct..."
if [ -d "node_modules/.bin" ]; then
    chmod +x node_modules/.bin/* 2>/dev/null || true
fi

# Kill any existing Metro bundler
echo "🧹 Stopping any running Metro bundler..."
killall -9 node 2>/dev/null || true
sleep 1

# Start Metro bundler with cache reset in background
echo "🚀 Starting Metro bundler with cache reset..."
npx react-native start --reset-cache &
METRO_PID=$!

# Wait for Metro to start
echo "⏳ Waiting for Metro to initialize..."
sleep 10

# Build and run on iPhone 14 Pro simulator
echo "📱 Building and launching on iPhone 14 Pro simulator..."
npx react-native run-ios --simulator="iPhone 14 Pro"

echo "✅ Done!"
