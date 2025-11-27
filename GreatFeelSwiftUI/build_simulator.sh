#!/bin/bash

# Build and Run on iOS Simulator
# This script builds for simulator only, avoiding physical device issues

set -e

echo "📱 Building for iOS Simulator"
echo "=============================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Navigate to script directory
cd "$(dirname "$0")"

# Check Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: Xcode not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Xcode: $(xcodebuild -version | head -n 1)"
echo ""

# Step 1: List available simulators
echo -e "${BLUE}Available Simulators:${NC}"
echo "-----------------------------------"
xcrun simctl list devices available | grep "iPhone" | grep -v "unavailable" | head -10
echo ""

# Step 2: Choose simulator (compatible with Xcode 15.4 / iOS 17.5)
SIMULATOR="iPhone 15 Pro"
echo -e "${BLUE}Selected Simulator:${NC} $SIMULATOR"
echo ""

# Step 3: Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*
xcodebuild -project GreatFeelSwiftUI.xcodeproj -scheme GreatFeelSwiftUI clean > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Clean complete"
echo ""

# Step 4: Build for simulator
echo "🔨 Building for simulator..."
echo "   This may take a minute..."
echo ""

BUILD_LOG="simulator_build.txt"

if xcodebuild -project GreatFeelSwiftUI.xcodeproj \
    -scheme GreatFeelSwiftUI \
    -destination "platform=iOS Simulator,name=$SIMULATOR" \
    -sdk iphonesimulator \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    build > "$BUILD_LOG" 2>&1; then

    echo -e "${GREEN}✅ Build succeeded!${NC}"
    echo ""

    # Step 5: Install and run on simulator
    echo "🚀 Launching simulator..."

    # Boot the simulator
    xcrun simctl boot "$SIMULATOR" 2>/dev/null || true
    open -a Simulator

    # Install the app
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*/Build/Products/Debug-iphonesimulator -name "GreatFeelSwiftUI.app" -print -quit)

    if [ -n "$APP_PATH" ]; then
        DEVICE_ID=$(xcrun simctl list devices | grep "$SIMULATOR" | grep Booted | head -1 | grep -o -E '\([A-F0-9-]+\)' | tr -d '()')

        if [ -n "$DEVICE_ID" ]; then
            xcrun simctl install "$DEVICE_ID" "$APP_PATH"
            BUNDLE_ID="com.greatfeel.GreatFeelSwiftUI"
            xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID"

            echo -e "${GREEN}✅ App launched on simulator!${NC}"
            echo ""
            echo "🎉 Your app is running on $SIMULATOR"
        else
            echo -e "${YELLOW}⚠️  Simulator not booted. Please run manually from Xcode.${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  App bundle not found. Opening Xcode...${NC}"
        open GreatFeelSwiftUI.xcodeproj
    fi

else
    echo -e "${RED}❌ Build failed${NC}"
    echo ""
    echo "Errors:"
    grep "error:" "$BUILD_LOG" | head -10
    echo ""
    echo "Full log: $BUILD_LOG"
    echo ""
    echo "💡 Try opening in Xcode:"
    echo "   open GreatFeelSwiftUI.xcodeproj"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "✨ Done!"
echo ""
echo "To rebuild: ./build_simulator.sh"
echo "To open Xcode: open GreatFeelSwiftUI.xcodeproj"
echo "═══════════════════════════════════════════════"
