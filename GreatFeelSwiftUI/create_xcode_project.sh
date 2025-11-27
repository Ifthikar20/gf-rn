#!/bin/bash

# GreatFeel SwiftUI - One-Command Xcode Project Creator
# Just run: ./create_xcode_project.sh

set -e

echo "🚀 Creating Xcode Project for GreatFeel SwiftUI"
echo "=============================================="
echo ""

PROJECT_NAME="GreatFeelSwiftUI"
BUNDLE_ID="com.greatfeel.GreatFeelSwiftUI"

# Navigate to script directory
cd "$(dirname "$0")"

echo "📁 Current directory: $(pwd)"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    echo "Please install Xcode from the App Store"
    exit 1
fi

echo "✅ Xcode found: $(xcodebuild -version | head -n 1)"
echo ""

# Check if project already exists
if [ -d "${PROJECT_NAME}.xcodeproj" ]; then
    echo "⚠️  Warning: ${PROJECT_NAME}.xcodeproj already exists"
    read -p "Do you want to delete it and create a new one? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "${PROJECT_NAME}.xcodeproj"
        echo "🗑️  Deleted existing project"
    else
        echo "❌ Aborted"
        exit 1
    fi
fi

echo "📝 Creating Xcode project structure..."
echo ""

# Create project directory
mkdir -p "${PROJECT_NAME}.xcodeproj"

# Get all Swift files
SWIFT_FILES=$(find . -name "*.swift" -type f | grep -v ".build" | sort)

# Generate file references and build file sections
FILE_REFS=""
BUILD_FILES=""
SOURCE_FILES=""

FILE_COUNTER=1000
BUILD_COUNTER=2000

# Process each Swift file
while IFS= read -r file; do
    if [ -n "$file" ]; then
        # Remove leading ./
        clean_path="${file#./}"
        filename=$(basename "$file")

        # Generate UUIDs (simplified - using counters)
        FILE_ID=$(printf "FILE%08d00000000000000" $FILE_COUNTER)
        BUILD_ID=$(printf "BUILD%07d00000000000000" $BUILD_COUNTER)

        # Add file reference
        FILE_REFS="${FILE_REFS}\n\t\t${FILE_ID} /* ${filename} */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ${filename}; sourceTree = \"<group>\"; };"

        # Add build file
        BUILD_FILES="${BUILD_FILES}\n\t\t${BUILD_ID} /* ${filename} in Sources */ = {isa = PBXBuildFile; fileRef = ${FILE_ID} /* ${filename} */; };"

        # Add to sources phase
        SOURCE_FILES="${SOURCE_FILES}\n\t\t\t\t${BUILD_ID} /* ${filename} in Sources */,"

        FILE_COUNTER=$((FILE_COUNTER + 1))
        BUILD_COUNTER=$((BUILD_COUNTER + 1))
    fi
done <<< "$SWIFT_FILES"

# Create the project.pbxproj file
cat > "${PROJECT_NAME}.xcodeproj/project.pbxproj" << 'PBXPROJ'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		APP00001 /* GreatFeelSwiftUIApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILE00001 /* GreatFeelSwiftUIApp.swift */; };
		VIEW0001 /* RootView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEVIEW1 /* RootView.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		APPFILE1 /* GreatFeelSwiftUI.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = GreatFeelSwiftUI.app; sourceTree = BUILT_PRODUCTS_DIR; };
		FILE00001 /* GreatFeelSwiftUIApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GreatFeelSwiftUIApp.swift; sourceTree = "<group>"; };
		FILEVIEW1 /* RootView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = RootView.swift; sourceTree = "<group>"; };
		INFOPLIST /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		FRAMEWORK1 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		ROOTGROUP /* Root */ = {
			isa = PBXGroup;
			children = (
				MAINGROUP /* GreatFeelSwiftUI */,
				PRODGROUP /* Products */,
			);
			sourceTree = "<group>";
		};
		MAINGROUP /* GreatFeelSwiftUI */ = {
			isa = PBXGroup;
			children = (
				APPGROUP /* App */,
				MODELGRP /* Models */,
				VIEWMGRP /* ViewModels */,
				VIEWSGRP /* Views */,
				SERVGRP /* Services */,
				THEMEGRP /* Theme */,
				INFOPLIST /* Info.plist */,
			);
			path = GreatFeelSwiftUI;
			sourceTree = "<group>";
		};
		PRODGROUP /* Products */ = {
			isa = PBXGroup;
			children = (
				APPFILE1 /* GreatFeelSwiftUI.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		APPGROUP /* App */ = {
			isa = PBXGroup;
			children = (
				FILE00001 /* GreatFeelSwiftUIApp.swift */,
			);
			path = App;
			sourceTree = "<group>";
		};
		MODELGRP /* Models */ = {
			isa = PBXGroup;
			children = (
			);
			path = Models;
			sourceTree = "<group>";
		};
		VIEWMGRP /* ViewModels */ = {
			isa = PBXGroup;
			children = (
			);
			path = ViewModels;
			sourceTree = "<group>";
		};
		VIEWSGRP /* Views */ = {
			isa = PBXGroup;
			children = (
				FILEVIEW1 /* RootView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
		SERVGRP /* Services */ = {
			isa = PBXGroup;
			children = (
			);
			path = Services;
			sourceTree = "<group>";
		};
		THEMEGRP /* Theme */ = {
			isa = PBXGroup;
			children = (
			);
			path = Theme;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		TARGET01 /* GreatFeelSwiftUI */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = CONFIGLST /* Build configuration list for PBXNativeTarget "GreatFeelSwiftUI" */;
			buildPhases = (
				SOURCES1 /* Sources */,
				FRAMEWORK1 /* Frameworks */,
				RESOURCE1 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = GreatFeelSwiftUI;
			productName = GreatFeelSwiftUI;
			productReference = APPFILE1 /* GreatFeelSwiftUI.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		PROJECT1 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					TARGET01 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = PROJCFGL /* Build configuration list for PBXProject "GreatFeelSwiftUI" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = ROOTGROUP;
			productRefGroup = PRODGROUP /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				TARGET01 /* GreatFeelSwiftUI */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		RESOURCE1 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		SOURCES1 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				APP00001 /* GreatFeelSwiftUIApp.swift in Sources */,
				VIEW0001 /* RootView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		DEBUGCFG /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		RELECFG /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		TARGETDBG /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Info.plist;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.greatfeel.GreatFeelSwiftUI;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		TARGETREL /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Info.plist;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.greatfeel.GreatFeelSwiftUI;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		PROJCFGL /* Build configuration list for PBXProject "GreatFeelSwiftUI" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				DEBUGCFG /* Debug */,
				RELECFG /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		CONFIGLST /* Build configuration list for PBXNativeTarget "GreatFeelSwiftUI" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				TARGETDBG /* Debug */,
				TARGETREL /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = PROJECT1 /* Project object */;
}
PBXPROJ

# Create workspace
mkdir -p "${PROJECT_NAME}.xcodeproj/project.xcworkspace"
mkdir -p "${PROJECT_NAME}.xcodeproj/project.xcworkspace/xcshareddata"

cat > "${PROJECT_NAME}.xcodeproj/project.xcworkspace/contents.xcworkspacedata" << 'WORKSPACE'
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
WORKSPACE

cat > "${PROJECT_NAME}.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist" << 'CHECKS'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>IDEDidComputeMac32BitWarning</key>
	<true/>
</dict>
</plist>
CHECKS

echo "✅ Xcode project created successfully!"
echo ""
echo "📂 Project structure:"
echo "   ${PROJECT_NAME}.xcodeproj/ ✓"
echo "   GreatFeelSwiftUI/ (source files) ✓"
echo "   Info.plist ✓"
echo ""
echo "🎉 All done! Now opening Xcode..."
echo ""
echo "⚠️  IMPORTANT: After Xcode opens:"
echo "   1. Select your Development Team in Signing & Capabilities"
echo "   2. Add all source files:"
echo "      - Right-click on GreatFeelSwiftUI folder in project navigator"
echo "      - Choose 'Add Files to GreatFeelSwiftUI...'"
echo "      - Select App, Models, ViewModels, Views, Services, Theme folders"
echo "      - Check 'Copy items if needed' and 'Create groups'"
echo "   3. Press ⌘R to build and run!"
echo ""

# Open Xcode
sleep 2
open "${PROJECT_NAME}.xcodeproj"

echo "✨ Setup complete! Happy coding!"
