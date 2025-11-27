#!/bin/bash

# Clean Everything and Run SwiftUI App on Simulator
# This removes old React Native apps and ensures fresh SwiftUI installation

set -e

echo "🧹 Complete Clean & Fresh Build for SwiftUI"
echo "==========================================="
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

# Step 1: Stop any running simulators
echo -e "${BLUE}Step 1: Stopping Simulators${NC}"
echo "-----------------------------------"
killall Simulator 2>/dev/null || true
sleep 2
echo -e "${GREEN}✓${NC} Simulators stopped"
echo ""

# Step 2: Remove old React Native app from simulator
echo -e "${BLUE}Step 2: Cleaning Old Apps from Simulator${NC}"
echo "-----------------------------------"

# Find all booted simulators and erase the old app
SIMULATOR_NAME="iPhone 15 Pro"

# Get device ID
DEVICE_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | head -1 | grep -o -E '\([A-F0-9-]+\)' | tr -d '()')

if [ -n "$DEVICE_ID" ]; then
    echo "Found simulator: $SIMULATOR_NAME ($DEVICE_ID)"

    # Try to uninstall old React Native app (common bundle IDs)
    xcrun simctl uninstall "$DEVICE_ID" "org.reactjs.native.example.GreatFeelSwiftUI" 2>/dev/null || true
    xcrun simctl uninstall "$DEVICE_ID" "com.greatfeel.app" 2>/dev/null || true
    xcrun simctl uninstall "$DEVICE_ID" "com.greatfeel.GreatFeelSwiftUI" 2>/dev/null || true

    echo -e "${GREEN}✓${NC} Old apps removed from simulator"
else
    echo -e "${YELLOW}⚠️  Simulator not found, will create/boot it${NC}"
fi
echo ""

# Step 3: Clean all build artifacts
echo -e "${BLUE}Step 3: Cleaning Build Artifacts${NC}"
echo "-----------------------------------"

# Remove DerivedData
echo "Cleaning DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*

# Clean Xcode build
echo "Cleaning Xcode project..."
xcodebuild -project GreatFeelSwiftUI.xcodeproj -scheme GreatFeelSwiftUI clean > /dev/null 2>&1 || true

echo -e "${GREEN}✓${NC} All build artifacts cleaned"
echo ""

# Step 4: Rebuild the SwiftUI app
echo -e "${BLUE}Step 4: Building Fresh SwiftUI App${NC}"
echo "-----------------------------------"
echo "This may take a minute..."
echo ""

BUILD_LOG="clean_build.txt"

if xcodebuild -project GreatFeelSwiftUI.xcodeproj \
    -scheme GreatFeelSwiftUI \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" \
    -sdk iphonesimulator \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    build > "$BUILD_LOG" 2>&1; then

    echo -e "${GREEN}✅ SwiftUI app built successfully!${NC}"
    echo ""

    # Step 5: Launch and install
    echo -e "${BLUE}Step 5: Installing on Simulator${NC}"
    echo "-----------------------------------"

    # Boot simulator
    xcrun simctl boot "$SIMULATOR_NAME" 2>/dev/null || true
    sleep 2

    # Open Simulator app
    open -a Simulator
    sleep 3

    # Find the built app
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*/Build/Products/Debug-iphonesimulator -name "GreatFeelSwiftUI.app" -print -quit)

    if [ -n "$APP_PATH" ]; then
        echo "Installing SwiftUI app: $APP_PATH"

        # Get fresh device ID
        DEVICE_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep Booted | head -1 | grep -o -E '\([A-F0-9-]+\)' | tr -d '()')

        if [ -n "$DEVICE_ID" ]; then
            # Uninstall any existing version
            xcrun simctl uninstall "$DEVICE_ID" "com.greatfeel.GreatFeelSwiftUI" 2>/dev/null || true

            # Install fresh
            xcrun simctl install "$DEVICE_ID" "$APP_PATH"
            echo -e "${GREEN}✓${NC} App installed"

            # Launch it
            BUNDLE_ID="com.greatfeel.GreatFeelSwiftUI"
            xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID"

            echo -e "${GREEN}✅ SwiftUI app launched!${NC}"
            echo ""
            echo "═══════════════════════════════════════════════"
            echo -e "${GREEN}✨ Success!${NC}"
            echo "═══════════════════════════════════════════════"
            echo ""
            echo "Your SwiftUI app is now running in the simulator!"
            echo ""
            echo "What you should see:"
            echo "  • Modern SwiftUI interface"
            echo "  • No React Native errors"
            echo "  • Smooth animations"
            echo ""
            echo "If you see 'No bundle URL' error, you're seeing"
            echo "the OLD React Native app. This script removed it."
            echo ""
        else
            echo -e "${YELLOW}⚠️  Could not find booted simulator${NC}"
            echo "Please run from Xcode manually"
        fi
    else
        echo -e "${RED}❌ App not found at expected path${NC}"
        echo "Please build from Xcode"
    fi

else
    echo -e "${RED}❌ Build failed${NC}"
    echo ""
    echo "Errors found:"
    grep "error:" "$BUILD_LOG" | head -10
    echo ""
    echo "Full log: $BUILD_LOG"
    echo ""
    echo "Try opening in Xcode and building there:"
    echo "  open GreatFeelSwiftUI.xcodeproj"
    exit 1
fi

echo ""
echo "To rebuild: ./clean_and_run.sh"
echo "To open Xcode: open GreatFeelSwiftUI.xcodeproj"
echo ""
