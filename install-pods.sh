#!/bin/bash
# Quick script to install iOS pods

echo "🔧 Installing CocoaPods dependencies..."

cd "$(dirname "$0")/ios"

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods not found!"
    echo "Installing CocoaPods..."
    sudo gem install cocoapods
fi

# Install pods
echo "📦 Running pod install..."
pod install

echo "✅ Done! Pods installed successfully."
echo ""
echo "Now restart your app:"
echo "  Kill Metro (Ctrl+C)"
echo "  Run: npx react-native run-ios"
