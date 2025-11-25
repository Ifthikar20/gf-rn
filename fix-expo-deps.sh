#!/bin/bash

# Fix missing expo dependencies and rebuild
# This script installs missing expo packages and clears caches

set -e  # Exit on error

echo "🔧 Fixing missing expo dependencies..."

cd "$(dirname "$0")" || exit 1

# Install missing dependencies
echo "📦 Installing expo packages..."
npm install

# Clear Metro bundler cache
echo "🧹 Clearing Metro cache..."
rm -rf node_modules/.cache
npx react-native start --reset-cache &
METRO_PID=$!
sleep 3
kill $METRO_PID 2>/dev/null || true

# Clean iOS build
echo "🧹 Cleaning iOS build..."
cd ios
rm -rf build
xattr -cr .
cd ..

# Fix permissions
echo "🔧 Fixing permissions..."
chmod +x node_modules/.bin/* 2>/dev/null || true

echo "✅ Dependencies installed and caches cleared!"
echo ""
echo "Now run: ./run-ios.sh"
