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
xattr -cr .
find . -name ".DS_Store" -type f -delete

# Go back to project root
cd ..

# Build and run on iPhone 14 Pro simulator
echo "📱 Building and launching on iPhone 14 Pro simulator..."
npx react-native run-ios --simulator="iPhone 14 Pro"

echo "✅ Done!"
