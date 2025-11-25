#!/usr/bin/env python3
"""
Add all new Swift files from Core/ and Features/ directories to Xcode project.
"""

import os
import re
import uuid

PROJECT_FILE = "PlantGuard.xcodeproj/project.pbxproj"

def generate_id():
    """Generate a 24-character uppercase hex ID"""
    return ''.join([f'{uuid.uuid4().hex[i:i+2].upper()}' for i in range(0, 24, 2)])[:24]

def get_all_swift_files():
    """Get all Swift files in Core/ and Features/ directories"""
    files = []
    for root, dirs, filenames in os.walk("PlantGuard"):
        if "Core" in root or "Features" in root:
            for filename in filenames:
                if filename.endswith(".swift"):
                    rel_path = os.path.relpath(os.path.join(root, filename), "PlantGuard")
                    files.append(rel_path)
    return sorted(files)

def read_project():
    with open(PROJECT_FILE, 'r') as f:
        return f.read()

def write_project(content):
    with open(PROJECT_FILE, 'w') as f:
        f.write(content)

def add_files_to_project():
    """Add all new files to the project"""
    content = read_project()
    
    # Get all Swift files
    swift_files = get_all_swift_files()
    
    # Check which files are already in the project
    existing_files = set()
    for match in re.finditer(r'path = "([^"]+\.swift)"', content):
        existing_files.add(match.group(1))
    
    # Files to add
    files_to_add = [f for f in swift_files if f not in existing_files]
    
    if not files_to_add:
        print("All files are already in the project!")
        return
    
    print(f"Found {len(files_to_add)} files to add:")
    for f in files_to_add:
        print(f"  - {f}")
    
    # Generate IDs for new files
    file_refs = {}
    build_files = {}
    
    for file_path in files_to_add:
        file_id = generate_id()
        build_id = generate_id()
        file_name = os.path.basename(file_path)
        
        file_refs[file_path] = (file_id, build_id, file_name)
        build_files[file_path] = build_id
    
    # Add PBXFileReference entries
    file_ref_section_end = "/* End PBXFileReference section */"
    new_file_refs = []
    for file_path, (file_id, build_id, file_name) in file_refs.items():
        new_file_refs.append(
            f'\t\t{file_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{file_path}"; sourceTree = "<group>"; }};\n'
        )
    
    if new_file_refs:
        content = content.replace(
            file_ref_section_end,
            ''.join(new_file_refs) + '\t\t' + file_ref_section_end
        )
    
    # Add PBXBuildFile entries
    build_file_section_end = "/* End PBXBuildFile section */"
    new_build_files = []
    for file_path, (file_id, build_id, file_name) in file_refs.items():
        new_build_files.append(
            f'\t\t{build_id} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {file_name} */; }};\n'
        )
    
    if new_build_files:
        content = content.replace(
            build_file_section_end,
            ''.join(new_build_files) + '\t\t' + build_file_section_end
        )
    
    # Add to Sources build phase
    sources_pattern = r'(AA000016 /\* Sources \*/ = \{[^}]+files = \()([^)]+)(\);'
    match = re.search(sources_pattern, content, re.DOTALL)
    if match:
        existing_sources = match.group(2)
        new_sources = []
        for file_path, (file_id, build_id, file_name) in file_refs.items():
            new_sources.append(f'\t\t\t\t{build_id} /* {file_name} in Sources */,\n')
        
        if new_sources:
            updated_sources = existing_sources + ''.join(new_sources)
            content = content.replace(
                match.group(0),
                match.group(1) + updated_sources + match.group(3)
            )
    
    # Add to groups (simplified - add to main PlantGuard group for now)
    # This is a simplified approach - in a real scenario, you'd want to create proper group hierarchy
    plantguard_group_pattern = r'(AA000011 /\* PlantGuard \*/ = \{[^}]+children = \()([^)]+)(\);'
    match = re.search(plantguard_group_pattern, content, re.DOTALL)
    if match:
        # For now, we'll add Core and Features groups if they don't exist
        # This is a simplified version - you may need to manually organize in Xcode
        
        # Check if Core group exists
        if 'AA00CORE' not in content:
            core_group_id = generate_id()
            core_group_entry = f'\t\t{core_group_id} /* Core */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t);\n\t\t\tpath = Core;\n\t\t\tsourceTree = "<group>";\n\t\t}};\n'
            content = content.replace('AA000700 /* Views */', f'{core_group_id} /* Core */,\n\t\t\tAA000700 /* Views */')
            # Add group definition
            content = content.replace(
                '/* End PBXGroup section */',
                core_group_entry + '\t\t/* End PBXGroup section */'
            )
        
        # Check if Features group exists
        if 'AA00FEAT' not in content:
            features_group_id = generate_id()
            features_group_entry = f'\t\t{features_group_id} /* Features */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t);\n\t\t\tpath = Features;\n\t\t\tsourceTree = "<group>";\n\t\t}};\n'
            content = content.replace('AA000700 /* Views */', f'{features_group_id} /* Features */,\n\t\t\tAA000700 /* Views */')
            # Add group definition
            content = content.replace(
                '/* End PBXGroup section */',
                features_group_entry + '\t\t/* End PBXGroup section */'
            )
    
    write_project(content)
    print(f"\nSuccessfully added {len(files_to_add)} files to project!")
    print("\nNote: You may need to organize files into proper groups in Xcode.")
    print("The files are now in the project and will compile.")

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    add_files_to_project()

