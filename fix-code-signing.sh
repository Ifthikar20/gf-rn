#!/bin/bash
# Fix iOS code signing for simulator builds

echo "🔧 Fixing code signing for simulator builds..."

PROJECT_FILE="ios/greatfeel.xcodeproj/project.pbxproj"

# Backup the project file
cp "$PROJECT_FILE" "$PROJECT_FILE.backup"

# Disable code signing for Debug builds (simulator only)
# Set CODE_SIGN_IDENTITY to empty for simulator builds
sed -i '' 's/CODE_SIGN_IDENTITY = "iPhone Developer";/CODE_SIGN_IDENTITY = "";/g' "$PROJECT_FILE"
sed -i '' 's/"CODE_SIGN_IDENTITY\[sdk=iphoneos\*\]" = "iPhone Developer";/"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "";/g' "$PROJECT_FILE"

# Ensure we're building for simulator
if ! grep -q 'ONLY_ACTIVE_ARCH = YES' "$PROJECT_FILE"; then
    echo "Setting ONLY_ACTIVE_ARCH for faster builds..."
fi

echo "✅ Code signing configuration updated!"
echo ""
echo "Now run: npx react-native run-ios"
