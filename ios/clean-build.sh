#!/bin/bash

# Clean iOS build script
# This script removes extended attributes and build artifacts that can cause codesign issues

echo "🧹 Cleaning iOS build artifacts..."

# Navigate to iOS directory
cd "$(dirname "$0")" || exit 1

# Remove build folder
echo "Removing build folder..."
rm -rf build

# Remove Xcode derived data for this project
echo "Removing derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/greatfeel-*

# Remove extended attributes (fixes codesign resource fork errors)
echo "Removing extended attributes..."
xattr -cr .

# Remove .DS_Store files
echo "Removing .DS_Store files..."
find . -name ".DS_Store" -type f -delete

# Clean CocoaPods cache
echo "Cleaning Pods..."
rm -rf Pods
pod cache clean --all 2>/dev/null || true

# Reinstall pods
echo "Installing pods..."
pod install

# Fix node_modules permissions
echo "Fixing node_modules permissions..."
cd ..
if [ -d "node_modules/.bin" ]; then
    chmod +x node_modules/.bin/* 2>/dev/null || true
    echo "✅ Permissions fixed"
fi

echo "✅ Clean complete! You can now try building again."
echo "Run: npx react-native run-ios"
