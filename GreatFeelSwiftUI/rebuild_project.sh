#!/bin/bash

# Quick rebuild script - Regenerates Xcode project with fixed settings

echo "🔧 Regenerating Xcode Project with Fix"
echo "======================================="
echo ""

cd "$(dirname "$0")"

# Remove old project
if [ -d "GreatFeelSwiftUI.xcodeproj" ]; then
    echo "🗑️  Removing old project..."
    rm -rf GreatFeelSwiftUI.xcodeproj
    rm -f build_log.txt
    echo "   ✓ Cleaned up"
    echo ""
fi

# Regenerate
echo "🔨 Generating new project with fix..."
echo ""
python3 generate_xcode_project.py

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Project regenerated successfully!"
    echo ""
    echo "The build error is now fixed. Next steps:"
    echo ""
    echo "1. If Xcode is open, close it"
    echo "2. Open the project: open GreatFeelSwiftUI.xcodeproj"
    echo "3. Select your Team in Signing & Capabilities"
    echo "4. Press ⌘R to build and run"
    echo ""

    read -p "Would you like to open the project now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Opening Xcode..."
        open GreatFeelSwiftUI.xcodeproj
    fi
else
    echo ""
    echo "❌ Error during generation"
    exit 1
fi
