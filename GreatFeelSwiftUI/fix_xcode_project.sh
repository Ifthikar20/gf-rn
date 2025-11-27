#!/bin/bash

# Fix Xcode Project - Add all Swift files correctly

echo "🔧 Fixing Xcode Project File References"
echo "========================================"
echo ""

cd "$(dirname "$0")"

PROJECT_FILE="GreatFeelSwiftUI.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: Xcode project not found!"
    echo "Please run ./create_xcode_project.sh first"
    exit 1
fi

echo "📋 Listing all Swift files..."

# Find all Swift files (excluding hidden directories and build artifacts)
SWIFT_FILES=$(find GreatFeelSwiftUI -name "*.swift" -type f | grep -v ".build" | grep -v "DerivedData" | sort)

echo ""
echo "Found Swift files:"
echo "$SWIFT_FILES" | sed 's/^/  ✓ /'
echo ""

echo "📝 Instructions to fix in Xcode:"
echo ""
echo "1. Open the project:"
echo "   open GreatFeelSwiftUI.xcodeproj"
echo ""
echo "2. In Xcode's left sidebar, select the GreatFeelSwiftUI folder (blue icon)"
echo ""
echo "3. Delete any red (missing) file references:"
echo "   - Right-click each red file → Delete → Remove Reference"
echo ""
echo "4. Add all source files properly:"
echo "   - Right-click 'GreatFeelSwiftUI' folder → Add Files to 'GreatFeelSwiftUI'..."
echo "   - Navigate to: GreatFeelSwiftUI folder"
echo "   - Select these folders (hold ⌘ to multi-select):"
echo "     • App"
echo "     • Models"
echo "     • ViewModels"
echo "     • Views"
echo "     • Services"
echo "     • Theme"
echo "   - In the dialog, CHECK these boxes:"
echo "     ✅ Copy items if needed"
echo "     ✅ Create groups (NOT folder references)"
echo "     ✅ Add to targets: GreatFeelSwiftUI"
echo "   - Click 'Add'"
echo ""
echo "5. Verify files were added:"
echo "   - Expand all folders in project navigator"
echo "   - Each .swift file should appear (not red)"
echo "   - Click on any .swift file - it should show in the editor"
echo ""
echo "6. Clean and rebuild:"
echo "   - Press ⌘Shift+K (Clean Build Folder)"
echo "   - Press ⌘R (Build and Run)"
echo ""

read -p "Press Enter to open Xcode and follow these steps..."

open GreatFeelSwiftUI.xcodeproj

echo ""
echo "✅ Xcode opened! Follow the steps above to fix the project."
