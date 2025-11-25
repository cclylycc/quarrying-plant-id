#!/usr/bin/env python3
"""
修复 Xcode 项目文件的脚本
检查并修复可能的格式问题
"""

import re
import sys

def fix_project_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 检查 PBXProject 部分是否缺少对象ID
    if 'AA000018 /* Project object */' not in content:
        # 查找 PBXProject 部分
        pattern = r'(/\* Begin PBXProject section \*/\s+)(\s+isa = PBXProject;)'
        replacement = r'\1\t\tAA000018 /* Project object */ = {\2'
        content = re.sub(pattern, replacement, content)
    
    # 确保所有引用都是正确的
    # 检查是否有 BuildFile ID 被错误地用在 Group children 中
    build_file_ids = re.findall(r'AA0001(00|02|04|06|08|10|12|14|16|18|20|22|24|26|28|30|32) /\* .* \*/ = \{isa = PBXBuildFile', content)
    
    # 检查 Group children 中是否有 BuildFile ID
    for match in build_file_ids:
        build_id = f'AA0001{match[0]}'
        # 在 Group children 中查找这个 ID
        pattern = f'(children = \\([^)]*){build_id}([^)]*\\))'
        if re.search(pattern, content):
            print(f"警告: 发现 BuildFile ID {build_id} 被用在 Group children 中")
    
    # 写回文件
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("项目文件已检查并修复")

if __name__ == '__main__':
    fix_project_file('PlantGuard.xcodeproj/project.pbxproj')

