#!/usr/bin/env python3
"""
Update Xcode project file to include all new Swift files in Core and Features directories.
"""

import os
import re
import uuid

PROJECT_FILE = "PlantGuard.xcodeproj/project.pbxproj"
BASE_DIR = "PlantGuard"

# New files to add
NEW_FILES = [
    # Core/Models
    ("Core/Models/InvasiveInfo.swift", "Core"),
    ("Core/Models/QuickIdentificationResponse.swift", "Core"),
    ("Core/Models/IdentificationRecord.swift", "Core"),
    ("Core/Models/ReportRecord.swift", "Core"),
    ("Core/Models/PlantSpecies.swift", "Core"),
    ("Core/Models/UserAccount.swift", "Core"),
    ("Core/Models/Achievement.swift", "Core"),
    
    # Core/Networking
    ("Core/Networking/NetworkingService.swift", "Core"),
    
    # Core/Storage
    ("Core/Storage/LocalStorageService.swift", "Core"),
    ("Core/Storage/HistoryRepository.swift", "Core"),
    ("Core/Storage/ReportRepository.swift", "Core"),
    
    # Core/Auth
    ("Core/Auth/AuthService.swift", "Core"),
    
    # Core/Services
    ("Core/Services/LocationService.swift", "Core"),
    ("Core/Services/MockDataService.swift", "Core"),
    
    # Core/Theme
    ("Core/Theme/AppTheme.swift", "Core"),
    
    # Core/Components
    ("Core/Components/FloatingCameraButton.swift", "Core"),
    ("Core/Components/CameraCaptureView.swift", "Core"),
    
    # Features/Home
    ("Features/Home/HomeView.swift", "Features"),
    ("Features/Home/IdentificationResultView.swift", "Features"),
    ("Features/Home/ReportFlowView.swift", "Features"),
    ("Features/Home/HistoryListView.swift", "Features"),
    
    # Features/Encyclopedia
    ("Features/Encyclopedia/EncyclopediaView.swift", "Features"),
    
    # Features/Profile
    ("Features/Profile/ProfileView.swift", "Features"),
]

def generate_uuid():
    """Generate a UUID in the format used by Xcode (uppercase, no dashes)"""
    return ''.join(str(uuid.uuid4()).upper().split('-'))[:24]

def read_project_file():
    """Read the project file"""
    with open(PROJECT_FILE, 'r') as f:
        return f.read()

def write_project_file(content):
    """Write the project file"""
    with open(PROJECT_FILE, 'w') as f:
        f.write(content)

def add_file_references(content):
    """Add PBXFileReference entries for new files"""
    file_refs = {}
    build_files = {}
    
    # Find the last file reference
    last_ref_match = re.search(r'AA\d+ /\* .+ \*/ = \{isa = PBXFileReference', content)
    
    for file_path, group_type in NEW_FILES:
        if file_path in content:
            continue  # Already exists
            
        file_name = os.path.basename(file_path)
        file_id = generate_uuid()
        build_id = generate_uuid()
        
        file_refs[file_path] = (file_id, build_id)
        
        # Add file reference
        file_ref_entry = f'\t\t{file_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{file_path}"; sourceTree = "<group>"; }};\n'
        
        # Add build file
        build_file_entry = f'\t\t{build_id} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {file_name} */; }};\n'
        
        # Insert before the last file reference section end
        content = content.replace('/* End PBXFileReference section */', 
                                 file_ref_entry + '\t\t/* End PBXFileReference section */')
        
        # Insert build file
        content = content.replace('/* End PBXBuildFile section */',
                                 build_file_entry + '\t\t/* End PBXBuildFile section */')
        
        # Add to Sources build phase
        sources_match = re.search(r'(AA000016 /\* Sources \*/ = \{[^}]+files = \(([^)]+)\);', content, re.DOTALL)
        if sources_match:
            sources_content = sources_match.group(2)
            new_source = f'\t\t\t\t{build_id} /* {file_name} in Sources */,\n'
            if new_source not in sources_content:
                content = content.replace(sources_match.group(0),
                                        sources_match.group(0).replace(');',
                                                                      f'\t\t\t\t{build_id} /* {file_name} in Sources */,\n\t\t\t);'))
    
    return content, file_refs

def add_to_groups(content, file_refs):
    """Add files to appropriate groups"""
    # Find Core group
    core_group_match = re.search(r'(AA\d+ /\* Core \*/ = \{[^}]+children = \(([^)]+)\);', content, re.DOTALL)
    
    # Find Features group  
    features_group_match = re.search(r'(AA\d+ /\* Features \*/ = \{[^}]+children = \(([^)]+)\);', content, re.DOTALL)
    
    # Create groups if they don't exist
    if not core_group_match:
        # Add Core group
        core_group_id = generate_uuid()
        core_group_entry = f'\t\t{core_group_id} /* Core */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t);\n\t\t\tpath = Core;\n\t\t\tsourceTree = "<group>";\n\t\t}};\n'
        # Insert before Views group
        content = content.replace('AA000700 /* Views */', f'{core_group_id} /* Core */,\n\t\t\tAA000700 /* Views */')
    
    if not features_group_match:
        # Add Features group
        features_group_id = generate_uuid()
        features_group_entry = f'\t\t{features_group_id} /* Features */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t);\n\t\t\tpath = Features;\n\t\t\tsourceTree = "<group>";\n\t\t}};\n'
        # Insert before Views group
        content = content.replace('AA000700 /* Views */', f'{features_group_id} /* Features */,\n\t\t\tAA000700 /* Views */')
    
    return content

def main():
    print("Reading project file...")
    content = read_project_file()
    
    print("Adding file references...")
    content, file_refs = add_file_references(content)
    
    print("Adding to groups...")
    content = add_to_groups(content, file_refs)
    
    print("Writing updated project file...")
    write_project_file(content)
    
    print("Done! Please verify the project file can be opened in Xcode.")

if __name__ == "__main__":
    main()

