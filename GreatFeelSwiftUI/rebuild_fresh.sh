#!/bin/bash

echo "🔧 Regenerating Xcode Project with Fix"
echo "======================================="
echo ""

cd "$(dirname "$0")"

# Remove old project
echo "Removing old project..."
rm -rf GreatFeelSwiftUI.xcodeproj

# Regenerate project
echo "Generating new project..."
python3 generate_xcode_project.py

echo ""
echo "✅ Project regenerated!"
echo ""
echo "Now run:"
echo "  open GreatFeelSwiftUI.xcodeproj"
echo ""
echo "Then in Xcode:"
echo "  1. Select 'iPhone 15 Pro' simulator"
echo "  2. Press ⌘R to build and run"
echo ""
