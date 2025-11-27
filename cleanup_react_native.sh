#!/bin/bash

# Complete React Native Cleanup Script
# This removes ALL React Native files and keeps only SwiftUI

echo "🧹 Cleaning Up React Native Project"
echo "====================================="
echo ""
echo "⚠️  WARNING: This will DELETE all React Native files!"
echo ""
echo "Files/folders to be removed:"
echo "  • src/ (React Native source code)"
echo "  • ios/ (React Native iOS project)"
echo "  • android/ (if exists)"
echo "  • node_modules/"
echo "  • assets/ (React Native assets)"
echo "  • All .js, .json config files"
echo "  • All React Native build scripts"
echo "  • React Native documentation"
echo ""
echo "Files to be KEPT:"
echo "  ✓ GreatFeelSwiftUI/ (your SwiftUI project)"
echo "  ✓ MIGRATION_SUMMARY.md"
echo "  ✓ .git/ (git history)"
echo "  ✓ README.md (will be updated)"
echo ""

read -p "Are you sure you want to continue? (type 'yes' to confirm): " -r
echo

if [[ ! $REPLY == "yes" ]]; then
    echo "❌ Cleanup cancelled"
    exit 1
fi

echo ""
echo "🗑️  Removing React Native files..."
echo ""

# Remove React Native source code
if [ -d "src" ]; then
    echo "  Removing src/ (React Native source)..."
    rm -rf src
fi

# Remove React Native iOS project
if [ -d "ios" ]; then
    echo "  Removing ios/ (React Native iOS)..."
    rm -rf ios
fi

# Remove Android project if exists
if [ -d "android" ]; then
    echo "  Removing android/..."
    rm -rf android
fi

# Remove node_modules
if [ -d "node_modules" ]; then
    echo "  Removing node_modules/..."
    rm -rf node_modules
fi

# Remove React Native assets
if [ -d "assets" ]; then
    echo "  Removing assets/..."
    rm -rf assets
fi

# Remove config files
echo "  Removing config files..."
rm -f package.json package-lock.json
rm -f babel.config.js metro.config.js
rm -f tsconfig.json
rm -f app.json
rm -f index.js

# Remove React Native build/setup scripts
echo "  Removing React Native scripts..."
rm -f run-ios.sh
rm -f build-and-run.sh
rm -f clean-rebuild-ios.sh
rm -f fix-code-signing.sh
rm -f fix-expo-deps.sh
rm -f fix-macos-issues.sh
rm -f fix-permissions.sh
rm -f install-pods.sh
rm -f setup-ios.sh

# Remove React Native documentation
echo "  Removing old documentation..."
rm -f FIX_SCHEME_ERROR.md
rm -f IOS_SETUP.md
rm -f README-BUILD.md

# Remove yarn/npm lock files if they exist
rm -f yarn.lock
rm -f .npmrc
rm -f .yarnrc

# Remove watchman config if exists
rm -f .watchmanconfig

# Remove metro cache if exists
rm -rf .metro

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📁 Remaining files:"
ls -la
echo ""
echo "✨ Your repository now contains ONLY the SwiftUI project!"
echo ""
echo "Next steps:"
echo "1. cd GreatFeelSwiftUI"
echo "2. Follow the instructions in FIX_BUILD_ERROR.md to set up Xcode"
echo "3. Build and run your SwiftUI app!"
