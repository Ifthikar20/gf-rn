#!/bin/bash

# Fix permissions for node_modules binaries
# Resolves "Permission denied" errors when running npm scripts

echo "🔧 Fixing node_modules permissions..."

cd "$(dirname "$0")" || exit 1

# Add execute permissions to all binaries in node_modules/.bin
if [ -d "node_modules/.bin" ]; then
    chmod +x node_modules/.bin/*
    echo "✅ Execute permissions added to node_modules/.bin/*"
else
    echo "⚠️  node_modules/.bin not found. Run 'npm install' first."
    exit 1
fi

# Verify react-native is now executable
if [ -x "node_modules/.bin/react-native" ]; then
    echo "✅ react-native CLI is now executable"
else
    echo "⚠️  Could not fix react-native permissions"
    exit 1
fi

echo "✅ Permissions fixed! You can now run: npx react-native run-ios"
