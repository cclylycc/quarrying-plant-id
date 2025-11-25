# 修复 Xcode 项目文件

如果项目文件损坏，请按以下步骤操作：

## 方法 1：在 Xcode 中手动添加文件

1. 关闭 Xcode
2. 删除项目文件中的用户数据：
   ```bash
   rm -rf PlantGuard.xcodeproj/project.xcworkspace/xcuserdata
   rm -rf PlantGuard.xcodeproj/xcuserdata
   ```
3. 重新打开 Xcode
4. 在 Xcode 中，右键点击项目导航器中的 "PlantGuard" 文件夹
5. 选择 "Add Files to PlantGuard..."
6. 选择以下文件夹，确保选择 "Create groups" 和 "Add to targets: PlantGuard"：
   - Models/
   - Services/
   - Storage/
   - Theme/
   - Views/
   - Views/Camera/
   - Views/Discover/
   - Views/History/
   - Views/Profile/
7. 点击 "Add"

## 方法 2：使用命令行工具重新创建项目

如果方法1不行，可以尝试：

```bash
cd /Users/dong/Documents/GitHub/quarrying-plant-id/iOS/PlantGuard

# 备份当前项目
mv PlantGuard.xcodeproj PlantGuard.xcodeproj.backup

# 使用 Xcode 命令行工具创建新项目（需要先安装）
# 或者手动在 Xcode 中创建新项目，然后复制文件
```

## 方法 3：验证项目文件格式

检查项目文件的 JSON/plist 格式是否正确：

```bash
plutil -lint PlantGuard.xcodeproj/project.pbxproj
```

如果格式错误，可能需要重新创建项目文件。

