#!/bin/bash

# Quick fix for iOS codesign "resource fork" errors
# Run this script before building if you encounter codesign issues

echo "🔧 Quick fix for codesign errors..."

cd "$(dirname "$0")" || exit 1

# Remove build folder
rm -rf build

# Remove extended attributes (this is the main fix for "resource fork" errors)
xattr -cr .

# Remove .DS_Store files
find . -name ".DS_Store" -type f -delete

echo "✅ Done! Try building again with: npx react-native run-ios"
