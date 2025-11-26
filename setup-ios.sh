#!/bin/bash
# iOS Setup Script - Run this on macOS
# This script sets up the iOS project with all necessary dependencies

set -e

echo "🚀 Setting up iOS environment..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS"
    exit 1
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check for CocoaPods
if ! command -v pod &> /dev/null; then
    echo "💎 Installing CocoaPods..."
    sudo gem install cocoapods
fi

# Install npm dependencies
echo "📦 Installing npm dependencies..."
npm install

# Install iOS pods
echo "🍎 Installing iOS pods..."
cd ios
pod install
cd ..

echo "✅ Setup complete!"
echo ""
echo "To run the app:"
echo "  npm run ios"
echo ""
echo "Or manually:"
echo "  1. Open ios/greatfeel.xcworkspace in Xcode"
echo "  2. Select your simulator/device"
echo "  3. Press Run (⌘R)"
