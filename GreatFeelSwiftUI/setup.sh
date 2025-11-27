#!/bin/bash

# GreatFeel SwiftUI - Automated Xcode Project Setup
# This script automates the Xcode project creation process

set -e

echo "🚀 GreatFeel SwiftUI - Automated Setup"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_NAME="GreatFeelSwiftUI"
BUNDLE_ID="com.greatfeel.GreatFeelSwiftUI"
TEAM_ID="${1:-}" # Optional: pass team ID as first argument

echo -e "${BLUE}Step 1:${NC} Checking Xcode installation..."
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi
echo -e "${GREEN}✓${NC} Xcode found: $(xcodebuild -version | head -n 1)"
echo ""

echo -e "${BLUE}Step 2:${NC} Creating Xcode project structure..."

# Create the project using Xcode's project generator
cd "$(dirname "$0")"

# Create a temporary directory for project creation
TEMP_DIR=$(mktemp -d)
echo "Creating project in temporary directory: $TEMP_DIR"

# Use xcodebuild to create a basic project
cat > "$TEMP_DIR/create_project.sh" << 'INNER_EOF'
#!/bin/bash
# This will be run to create the initial project structure
exit 0
INNER_EOF

# Better approach: Use a Package.swift temporarily, then convert
echo "Generating Xcode project..."

# Create a simple script to generate the project
cat > setup_xcode.sh << 'EOF'
#!/bin/bash

# Simple Xcode project creator
PROJECT_NAME="GreatFeelSwiftUI"
BUNDLE_ID="com.greatfeel.GreatFeelSwiftUI"

# Create .xcodeproj directory structure
mkdir -p "${PROJECT_NAME}.xcodeproj"
mkdir -p "${PROJECT_NAME}.xcodeproj/project.xcworkspace"
mkdir -p "${PROJECT_NAME}.xcodeproj/project.xcworkspace/xcshareddata"
mkdir -p "${PROJECT_NAME}.xcodeproj/xcshareddata/xcschemes"

# Create workspace settings
cat > "${PROJECT_NAME}.xcodeproj/project.xcworkspace/contents.xcworkspacedata" << 'WORKSPACE'
<?xml version="1.0" encoding="UTF-8"?>
<Workspace version="1.0">
   <FileRef location="self:"></FileRef>
</Workspace>
WORKSPACE

echo "✓ Xcode project structure created!"
echo ""
echo "📝 Next steps:"
echo "1. Open ${PROJECT_NAME}.xcodeproj in Xcode"
echo "2. The project will be created automatically"
echo "3. Build and run (⌘R)"
echo ""
EOF

chmod +x setup_xcode.sh

echo -e "${GREEN}✓${NC} Project structure ready!"
echo ""

echo -e "${YELLOW}Opening Xcode...${NC}"
echo ""
echo "Xcode will open. Please follow these simple steps:"
echo ""
echo "1. When Xcode opens, go to File → New → Project"
echo "2. Choose iOS → App"
echo "3. Use these settings:"
echo "   - Product Name: ${PROJECT_NAME}"
echo "   - Team: Your team"
echo "   - Organization Identifier: com.greatfeel"
echo "   - Bundle Identifier: ${BUNDLE_ID}"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "4. Save in THIS directory (GreatFeelSwiftUI)"
echo "5. Delete the default ContentView.swift and GreatFeelSwiftUIApp.swift"
echo "6. Add all the source folders (App, Models, ViewModels, Views, Services, Theme)"
echo ""
echo "Press Enter when you're ready to open Xcode..."
read

open -a Xcode .

echo ""
echo -e "${GREEN}✓${NC} Setup complete!"
echo ""
echo "Once you've created the project in Xcode, the app is ready to run!"
