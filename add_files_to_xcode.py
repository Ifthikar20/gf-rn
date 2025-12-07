#!/usr/bin/env python3
"""
Script to add new Swift files to Xcode project
"""
import uuid
import re
import sys

# Files to add with their paths
files_to_add = [
    {
        'name': 'OnboardingQuestion.swift',
        'path': 'GreatFeelSwiftUI/GreatFeelSwiftUI/Models/OnboardingQuestion.swift',
        'group': 'Models'
    },
    {
        'name': 'UserOnboardingData.swift',
        'path': 'GreatFeelSwiftUI/GreatFeelSwiftUI/Models/UserOnboardingData.swift',
        'group': 'Models'
    },
    {
        'name': 'OnboardingView.swift',
        'path': 'GreatFeelSwiftUI/GreatFeelSwiftUI/Views/Onboarding/OnboardingView.swift',
        'group': 'Onboarding'
    },
    {
        'name': 'PersonalizationService.swift',
        'path': 'GreatFeelSwiftUI/GreatFeelSwiftUI/Services/PersonalizationService.swift',
        'group': 'Services'
    },
    {
        'name': 'PersonalizedWelcomeBanner.swift',
        'path': 'GreatFeelSwiftUI/GreatFeelSwiftUI/Views/Components/PersonalizedWelcomeBanner.swift',
        'group': 'Components'
    }
]

def generate_uuid():
    """Generate a UUID in Xcode format (24 hex chars)"""
    return uuid.uuid4().hex[:24].upper()

def read_file(filepath):
    with open(filepath, 'r') as f:
        return f.read()

def write_file(filepath, content):
    with open(filepath, 'w') as f:
        f.write(content)

def add_files_to_project(pbxproj_path):
    content = read_file(pbxproj_path)

    # Generate UUIDs for all files
    file_data = []
    for file_info in files_to_add:
        file_ref_uuid = generate_uuid()
        build_file_uuid = generate_uuid()
        file_data.append({
            **file_info,
            'file_ref_uuid': file_ref_uuid,
            'build_file_uuid': build_file_uuid
        })

    # Find the PBXBuildFile section
    pbx_buildfile_match = re.search(r'(/\* Begin PBXBuildFile section \*/\n)', content)
    if pbx_buildfile_match:
        insert_pos = pbx_buildfile_match.end()
        new_entries = []
        for data in file_data:
            entry = f"\t\t{data['build_file_uuid']} /* {data['name']} in Sources */ = {{isa = PBXBuildFile; fileRef = {data['file_ref_uuid']} /* {data['name']} */; }};\n"
            new_entries.append(entry)
        content = content[:insert_pos] + ''.join(new_entries) + content[insert_pos:]

    # Find the PBXFileReference section
    pbx_fileref_match = re.search(r'(/\* Begin PBXFileReference section \*/\n)', content)
    if pbx_fileref_match:
        insert_pos = pbx_fileref_match.end()
        new_entries = []
        for data in file_data:
            # Extract just the relative path from Views/ or Models/ etc
            parts = data['path'].split('/')
            relative_path = '/'.join(parts[2:])  # Skip GreatFeelSwiftUI/GreatFeelSwiftUI
            entry = f"\t\t{data['file_ref_uuid']} /* {data['name']} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {data['name']}; sourceTree = \"<group>\"; }};\n"
            new_entries.append(entry)
        content = content[:insert_pos] + ''.join(new_entries) + content[insert_pos:]

    # Find PBXSourcesBuildPhase and add to sources
    sources_match = re.search(r'(files = \(\n)(.*?)(\);[\s\n]*isa = PBXSourcesBuildPhase;)', content, re.DOTALL)
    if sources_match:
        files_section = sources_match.group(2)
        new_entries = []
        for data in file_data:
            entry = f"\t\t\t\t{data['build_file_uuid']} /* {data['name']} in Sources */,\n"
            new_entries.append(entry)
        new_files_section = files_section + ''.join(new_entries)
        content = content[:sources_match.start(2)] + new_files_section + content[sources_match.end(2):]

    write_file(pbxproj_path, content)
    print("✅ Successfully added files to Xcode project!")
    print("\nAdded files:")
    for data in file_data:
        print(f"  - {data['name']}")
    print("\n⚠️  You may need to:")
    print("  1. Close Xcode")
    print("  2. Reopen the project")
    print("  3. Clean Build Folder (⇧⌘K)")
    print("  4. Build (⌘B)")

if __name__ == '__main__':
    pbxproj_path = 'GreatFeelSwiftUI/GreatFeelSwiftUI.xcodeproj/project.pbxproj'
    add_files_to_project(pbxproj_path)
