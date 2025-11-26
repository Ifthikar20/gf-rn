#!/bin/bash

# ============================================
# Great Feel iOS Build and Run Script
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Error handler
handle_error() {
    print_error "Build failed at step: $1"
    print_info "Check the output above for error details"
    exit 1
}

echo -e "${BLUE}🚀 Starting build process...${NC}"
echo ""

# Navigate to project directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$PROJECT_DIR" || handle_error "Navigate to project directory"

print_info "Project directory: $PROJECT_DIR"
echo ""

# Stop Metro bundler
print_info "Stopping any running Metro bundler..."
killall -9 node 2>/dev/null || true
sleep 2

# Clean everything
print_info "Cleaning build artifacts..."
rm -rf node_modules
rm -rf ios/Pods
rm -rf ios/build
rm -rf ~/Library/Developer/Xcode/DerivedData/greatfeel-*
rm -rf /tmp/metro-*
rm -rf /tmp/haste-map-*

print_success "Cleanup complete"
echo ""

# Install dependencies
print_info "Installing npm dependencies..."
if ! npm install; then
    handle_error "npm install"
fi

print_success "npm dependencies installed"
echo ""

# Install iOS pods
print_info "Installing iOS pods (this may take a few minutes)..."
cd ios || handle_error "Navigate to ios directory"
if ! pod install; then
    handle_error "pod install"
fi
cd .. || exit

print_success "iOS pods installed"
echo ""

# Start Metro bundler in a separate terminal
print_info "Starting Metro bundler in a new terminal window..."
print_warning "Metro bundler will open in a new terminal window"
print_warning "Keep that window open while the app is running"
echo ""

# Open Metro in new terminal window
osascript -e "tell application \"Terminal\" to do script \"cd '$PROJECT_DIR' && npx react-native start --reset-cache\"" 2>/dev/null

print_info "Waiting for Metro to start (20 seconds)..."
sleep 20

# Build and run on simulator
print_success "Metro bundler started"
echo ""
print_info "Building and running app on iPhone 15 Pro simulator..."
print_warning "This will take several minutes on first build..."
print_warning "Watch for any errors in the Metro bundler terminal window"
echo ""

# Run the build and capture output
if ! npx react-native run-ios --simulator="iPhone 15 Pro" 2>&1; then
    print_error "Build failed! Check the output above for errors"
    print_info "Common issues:"
    print_info "  - Check the Metro bundler terminal for JavaScript errors"
    print_info "  - Look for 'error:' messages in the build output above"
    print_info "  - Ensure Xcode is properly installed"
    exit 1
fi

echo ""
print_success "Build complete!"
echo ""
print_success "App should now be running on the simulator"
print_info "Metro bundler is running in a separate terminal window"
print_warning "Keep the Metro terminal open to see app logs and errors"
echo ""
print_info "To reload the app: Press Cmd+D in simulator, then 'Reload'"
print_info "To open developer menu: Press Cmd+D in simulator"
echo ""
