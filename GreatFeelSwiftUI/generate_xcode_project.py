#!/usr/bin/env python3

"""
Xcode Project Generator for GreatFeel SwiftUI
Generates a complete, valid Xcode project with all Swift files properly configured
"""

import os
import hashlib
import json

def generate_uuid(name):
    """Generate a consistent 24-character hex ID for Xcode"""
    hash_obj = hashlib.md5(name.encode())
    return hash_obj.hexdigest()[:24].upper()

def find_swift_files(base_path):
    """Find all Swift files and organize by directory"""
    files = {}
    for root, dirs, filenames in os.walk(base_path):
        # Skip hidden directories and build artifacts
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'build']

        for filename in filenames:
            if filename.endswith('.swift'):
                rel_path = os.path.relpath(os.path.join(root, filename), base_path)
                files[rel_path] = filename

    return files

def create_pbxproj(swift_files):
    """Generate complete project.pbxproj content"""

    # Generate IDs for files
    file_refs = {}
    build_files = {}

    for path, filename in swift_files.items():
        file_id = generate_uuid(f"FILE_{path}")
        build_id = generate_uuid(f"BUILD_{path}")
        file_refs[path] = {'id': file_id, 'name': filename}
        build_files[path] = {'id': build_id, 'file_ref_id': file_id, 'name': filename}

    # Fixed IDs for main structure
    PROJECT_ID = "1F1234567890ABCDEF000001"
    TARGET_ID = "1F1234567890ABCDEF000002"
    PRODUCTS_GROUP_ID = "1F1234567890ABCDEF000003"
    MAIN_GROUP_ID = "1F1234567890ABCDEF000004"
    APP_PRODUCT_ID = "1F1234567890ABCDEF000005"
    SOURCES_PHASE_ID = "1F1234567890ABCDEF000006"
    FRAMEWORKS_PHASE_ID = "1F1234567890ABCDEF000007"
    RESOURCES_PHASE_ID = "1F1234567890ABCDEF000008"
    PROJECT_CONFIG_LIST_ID = "1F1234567890ABCDEF000009"
    TARGET_CONFIG_LIST_ID = "1F1234567890ABCDEF00000A"
    DEBUG_PROJECT_CONFIG_ID = "1F1234567890ABCDEF00000B"
    RELEASE_PROJECT_CONFIG_ID = "1F1234567890ABCDEF00000C"
    DEBUG_TARGET_CONFIG_ID = "1F1234567890ABCDEF00000D"
    RELEASE_TARGET_CONFIG_ID = "1F1234567890ABCDEF00000E"
    MAIN_SRC_GROUP_ID = "1F1234567890ABCDEF00000F"

    # Group IDs
    group_ids = {
        'App': generate_uuid("GROUP_App"),
        'Models': generate_uuid("GROUP_Models"),
        'ViewModels': generate_uuid("GROUP_ViewModels"),
        'Views': generate_uuid("GROUP_Views"),
        'Views/Auth': generate_uuid("GROUP_Views_Auth"),
        'Views/Main': generate_uuid("GROUP_Views_Main"),
        'Views/Components': generate_uuid("GROUP_Views_Components"),
        'Views/Shared': generate_uuid("GROUP_Views_Shared"),
        'Services': generate_uuid("GROUP_Services"),
        'Services/Network': generate_uuid("GROUP_Services_Network"),
        'Services/Storage': generate_uuid("GROUP_Services_Storage"),
        'Services/Audio': generate_uuid("GROUP_Services_Audio"),
        'Theme': generate_uuid("GROUP_Theme"),
    }

    # Build PBXFileReference section
    file_reference_section = ""
    for path, info in sorted(file_refs.items()):
        file_reference_section += f"\t\t{info['id']} /* {info['name']} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {info['name']}; sourceTree = \"<group>\"; }};\n"

    # Build PBXBuildFile section
    build_file_section = ""
    for path, info in sorted(build_files.items()):
        build_file_section += f"\t\t{info['id']} /* {info['name']} in Sources */ = {{isa = PBXBuildFile; fileRef = {info['file_ref_id']} /* {info['name']} */; }};\n"

    # Build PBXSourcesBuildPhase section
    sources_phase_files = ""
    for path, info in sorted(build_files.items()):
        sources_phase_files += f"\t\t\t\t{info['id']} /* {info['name']} in Sources */,\n"

    # Build PBXGroup sections
    def get_files_in_directory(dir_path):
        """Get file IDs for files in a specific directory"""
        files_in_dir = []
        for path, info in sorted(file_refs.items()):
            file_dir = os.path.dirname(path)
            if file_dir == dir_path:
                files_in_dir.append(f"\t\t\t\t{info['id']} /* {info['name']} */,\n")
        return ''.join(files_in_dir)

    # Generate the complete pbxproj file
    pbxproj_content = f'''// !$*UTF8*$!
{{
\tarchiveVersion = 1;
\tclasses = {{
\t}};
\tobjectVersion = 56;
\tobjects = {{

/* Begin PBXBuildFile section */
{build_file_section}/* End PBXBuildFile section */

/* Begin PBXFileReference section */
\t\t{APP_PRODUCT_ID} /* GreatFeelSwiftUI.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = GreatFeelSwiftUI.app; sourceTree = BUILT_PRODUCTS_DIR; }};
{file_reference_section}/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t{FRAMEWORKS_PHASE_ID} /* Frameworks */ = {{
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t{MAIN_GROUP_ID} /* Main */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{MAIN_SRC_GROUP_ID} /* GreatFeelSwiftUI */,
\t\t\t\t{PRODUCTS_GROUP_ID} /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{MAIN_SRC_GROUP_ID} /* GreatFeelSwiftUI */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{group_ids['App']} /* App */,
\t\t\t\t{group_ids['Models']} /* Models */,
\t\t\t\t{group_ids['ViewModels']} /* ViewModels */,
\t\t\t\t{group_ids['Views']} /* Views */,
\t\t\t\t{group_ids['Services']} /* Services */,
\t\t\t\t{group_ids['Theme']} /* Theme */,
\t\t\t);
\t\t\tpath = GreatFeelSwiftUI;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{PRODUCTS_GROUP_ID} /* Products */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{APP_PRODUCT_ID} /* GreatFeelSwiftUI.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['App']} /* App */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('App')}\t\t\t);
\t\t\tpath = App;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Models']} /* Models */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Models')}\t\t\t);
\t\t\tpath = Models;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['ViewModels']} /* ViewModels */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('ViewModels')}\t\t\t);
\t\t\tpath = ViewModels;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Views']} /* Views */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{group_ids['Views/Auth']} /* Auth */,
\t\t\t\t{group_ids['Views/Main']} /* Main */,
\t\t\t\t{group_ids['Views/Components']} /* Components */,
\t\t\t\t{group_ids['Views/Shared']} /* Shared */,
\t\t\t);
\t\t\tpath = Views;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Views/Auth']} /* Auth */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Views/Auth')}\t\t\t);
\t\t\tpath = Auth;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Views/Main']} /* Main */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Views/Main')}\t\t\t);
\t\t\tpath = Main;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Views/Components']} /* Components */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Views/Components')}\t\t\t);
\t\t\tpath = Components;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Views/Shared']} /* Shared */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Views/Shared')}\t\t\t);
\t\t\tpath = Shared;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Services']} /* Services */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{group_ids['Services/Network']} /* Network */,
\t\t\t\t{group_ids['Services/Storage']} /* Storage */,
\t\t\t\t{group_ids['Services/Audio']} /* Audio */,
\t\t\t);
\t\t\tpath = Services;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Services/Network']} /* Network */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Services/Network')}\t\t\t);
\t\t\tpath = Network;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Services/Storage']} /* Storage */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Services/Storage')}\t\t\t);
\t\t\tpath = Storage;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Services/Audio']} /* Audio */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Services/Audio')}\t\t\t);
\t\t\tpath = Audio;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{group_ids['Theme']} /* Theme */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{get_files_in_directory('Theme')}\t\t\t);
\t\t\tpath = Theme;
\t\t\tsourceTree = "<group>";
\t\t}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t{TARGET_ID} /* GreatFeelSwiftUI */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {TARGET_CONFIG_LIST_ID} /* Build configuration list for PBXNativeTarget "GreatFeelSwiftUI" */;
\t\t\tbuildPhases = (
\t\t\t\t{SOURCES_PHASE_ID} /* Sources */,
\t\t\t\t{FRAMEWORKS_PHASE_ID} /* Frameworks */,
\t\t\t\t{RESOURCES_PHASE_ID} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = GreatFeelSwiftUI;
\t\t\tproductName = GreatFeelSwiftUI;
\t\t\tproductReference = {APP_PRODUCT_ID} /* GreatFeelSwiftUI.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t{PROJECT_ID} /* Project object */ = {{
\t\t\tisa = PBXProject;
\t\t\tattributes = {{
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1500;
\t\t\t\tLastUpgradeCheck = 1500;
\t\t\t\tTargetAttributes = {{
\t\t\t\t\t{TARGET_ID} = {{
\t\t\t\t\t\tCreatedOnToolsVersion = 15.0;
\t\t\t\t\t}};
\t\t\t\t}};
\t\t\t}};
\t\t\tbuildConfigurationList = {PROJECT_CONFIG_LIST_ID} /* Build configuration list for PBXProject "GreatFeelSwiftUI" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = {MAIN_GROUP_ID};
\t\t\tproductRefGroup = {PRODUCTS_GROUP_ID} /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t{TARGET_ID} /* GreatFeelSwiftUI */,
\t\t\t);
\t\t}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t{RESOURCES_PHASE_ID} /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t{SOURCES_PHASE_ID} /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{sources_phase_files}\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t{DEBUG_PROJECT_CONFIG_ID} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tASASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;
\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_COMMA = YES;
\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;
\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;
\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;
\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;
\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;
\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;
\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;
\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tENABLE_USER_SCRIPT_SANDBOXING = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$$(inherited)",
\t\t\t\t);
\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;
\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;
\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;
\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;
\t\t\t\tLOCALIZATION_PREFERS_STRING_CATALOGS = YES;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{RELEASE_PROJECT_CONFIG_ID} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tASASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;
\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_COMMA = YES;
\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;
\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;
\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;
\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;
\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;
\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;
\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;
\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_USER_SCRIPT_SANDBOXING = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;
\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;
\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;
\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;
\t\t\t\tLOCALIZATION_PREFERS_STRING_CATALOGS = YES;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t}};
\t\t\tname = Release;
\t\t}};
\t\t{DEBUG_TARGET_CONFIG_ID} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tASASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Info.plist;
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.greatfeel.GreatFeelSwiftUI;
\t\t\t\tPRODUCT_NAME = "GreatFeelSwiftUI";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{RELEASE_TARGET_CONFIG_ID} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tASASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Info.plist;
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.greatfeel.GreatFeelSwiftUI;
\t\t\t\tPRODUCT_NAME = "GreatFeelSwiftUI";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Release;
\t\t}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t{PROJECT_CONFIG_LIST_ID} /* Build configuration list for PBXProject "GreatFeelSwiftUI" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{DEBUG_PROJECT_CONFIG_ID} /* Debug */,
\t\t\t\t{RELEASE_PROJECT_CONFIG_ID} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
\t\t{TARGET_CONFIG_LIST_ID} /* Build configuration list for PBXNativeTarget "GreatFeelSwiftUI" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{DEBUG_TARGET_CONFIG_ID} /* Debug */,
\t\t\t\t{RELEASE_TARGET_CONFIG_ID} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
/* End XCConfigurationList section */
\t}};
\trootObject = {PROJECT_ID} /* Project object */;
}}
'''

    return pbxproj_content

def create_workspace_files():
    """Create workspace metadata files"""
    contents_xcworkspacedata = '''<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
'''

    workspace_checks = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>IDEDidComputeMac32BitWarning</key>
\t<true/>
</dict>
</plist>
'''

    return contents_xcworkspacedata, workspace_checks

def main():
    print("🔨 Generating Complete Xcode Project for GreatFeel SwiftUI")
    print("=" * 60)
    print()

    # Get the base path
    base_path = "GreatFeelSwiftUI"

    if not os.path.exists(base_path):
        print(f"❌ Error: Directory '{base_path}' not found!")
        print(f"   Current directory: {os.getcwd()}")
        return 1

    # Find all Swift files
    print("📁 Finding Swift files...")
    swift_files = find_swift_files(base_path)
    print(f"   Found {len(swift_files)} Swift files")
    print()

    # Create project directory
    project_dir = "GreatFeelSwiftUI.xcodeproj"
    if os.path.exists(project_dir):
        print(f"🗑️  Removing existing project: {project_dir}")
        import shutil
        shutil.rmtree(project_dir)

    os.makedirs(project_dir, exist_ok=True)
    os.makedirs(f"{project_dir}/project.xcworkspace", exist_ok=True)
    os.makedirs(f"{project_dir}/project.xcworkspace/xcshareddata", exist_ok=True)

    # Generate project file
    print("⚙️  Generating project.pbxproj...")
    pbxproj_content = create_pbxproj(swift_files)

    with open(f"{project_dir}/project.pbxproj", 'w') as f:
        f.write(pbxproj_content)
    print("   ✓ project.pbxproj created")

    # Generate workspace files
    print("⚙️  Generating workspace files...")
    contents, checks = create_workspace_files()

    with open(f"{project_dir}/project.xcworkspace/contents.xcworkspacedata", 'w') as f:
        f.write(contents)
    print("   ✓ contents.xcworkspacedata created")

    with open(f"{project_dir}/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist", 'w') as f:
        f.write(checks)
    print("   ✓ IDEWorkspaceChecks.plist created")

    print()
    print("✅ Xcode project generated successfully!")
    print()
    print("📊 Project Summary:")
    print(f"   • {len(swift_files)} Swift files added")
    print(f"   • All files added to build target")
    print(f"   • Proper group structure created")
    print(f"   • iOS 16.0+ deployment target")
    print()
    print("🚀 Next steps:")
    print("   1. Open the project:")
    print("      open GreatFeelSwiftUI.xcodeproj")
    print()
    print("   2. Select your team in Signing & Capabilities")
    print()
    print("   3. Select a simulator (iPhone 15 Pro)")
    print()
    print("   4. Press ⌘R to build and run!")
    print()
    print("✨ The project is complete and ready to build!")

    return 0

if __name__ == "__main__":
    exit(main())
