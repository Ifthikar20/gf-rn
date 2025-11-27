#!/bin/bash

# Validation Script - Check all files are present and not empty

echo "🔍 Validating GreatFeel SwiftUI Project"
echo "========================================"
echo ""

cd "$(dirname "$0")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ISSUES=0

# Check all Swift files
echo "📝 Checking Swift files..."
echo ""

while IFS= read -r file; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ MISSING:${NC} $file"
        ((ISSUES++))
    elif [ ! -s "$file" ]; then
        echo -e "${RED}✗ EMPTY:${NC} $file"
        ((ISSUES++))
    else
        LINE_COUNT=$(wc -l < "$file" | tr -d ' ')
        if [ "$LINE_COUNT" -lt 10 ]; then
            echo -e "${YELLOW}⚠ SHORT:${NC} $file (only $LINE_COUNT lines)"
        else
            echo -e "${GREEN}✓${NC} $file ($LINE_COUNT lines)"
        fi
    fi
done < <(find GreatFeelSwiftUI -name "*.swift" -type f | sort)

echo ""

# Check Info.plist
echo "📄 Checking Info.plist..."
if [ -f "Info.plist" ]; then
    if [ -s "Info.plist" ]; then
        echo -e "${GREEN}✓${NC} Info.plist exists and has content"
    else
        echo -e "${RED}✗${NC} Info.plist is empty!"
        ((ISSUES++))
    fi
else
    echo -e "${RED}✗${NC} Info.plist not found!"
    ((ISSUES++))
fi

echo ""

# Summary
echo "📊 Summary:"
TOTAL_FILES=$(find GreatFeelSwiftUI -name "*.swift" -type f | wc -l | tr -d ' ')
echo "   • Total Swift files: $TOTAL_FILES"
echo "   • Expected: ~34 files"

if [ "$TOTAL_FILES" -lt 30 ]; then
    echo -e "   ${RED}⚠️  Warning: Some files may be missing!${NC}"
    ((ISSUES++))
fi

echo ""

# Check project structure
echo "📁 Checking directory structure..."
REQUIRED_DIRS=(
    "GreatFeelSwiftUI/App"
    "GreatFeelSwiftUI/Models"
    "GreatFeelSwiftUI/ViewModels"
    "GreatFeelSwiftUI/Views/Auth"
    "GreatFeelSwiftUI/Views/Main"
    "GreatFeelSwiftUI/Views/Components"
    "GreatFeelSwiftUI/Views/Shared"
    "GreatFeelSwiftUI/Services/Network"
    "GreatFeelSwiftUI/Services/Storage"
    "GreatFeelSwiftUI/Services/Audio"
    "GreatFeelSwiftUI/Theme"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        FILE_COUNT=$(find "$dir" -maxdepth 1 -name "*.swift" -type f | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} $dir ($FILE_COUNT files)"
    else
        echo -e "${RED}✗${NC} $dir ${RED}MISSING!${NC}"
        ((ISSUES++))
    fi
done

echo ""

# Final verdict
echo "════════════════════════════════════"
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo "   Your project is complete and ready to build."
    echo ""
    echo "Next step: ./setup_and_build.sh"
    exit 0
else
    echo -e "${RED}❌ Found $ISSUES issue(s)!${NC}"
    echo "   Please fix these issues before building."
    exit 1
fi
