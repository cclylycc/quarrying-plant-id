# 快速修复：添加新文件到Xcode项目

## 问题
新创建的文件（Core/ 和 Features/ 目录）还没有添加到Xcode项目中，所以编译时找不到这些类。

## 解决方案（推荐）

### 方法1：在Xcode中批量添加文件（最简单）

1. **打开Xcode项目**
   ```
   打开 PlantGuard.xcodeproj
   ```

2. **选择所有新文件**
   - 在Finder中，导航到 `iOS/PlantGuard/PlantGuard/`
   - 选择 `Core` 和 `Features` 文件夹
   - 拖拽这两个文件夹到Xcode的项目导航器中

3. **配置添加选项**
   - ✅ 勾选 "Copy items if needed"（如果文件不在项目目录中）
   - ✅ 选择 "Create groups"（不是folder references）
   - ✅ 确保勾选目标 "PlantGuard"
   - 点击 "Finish"

4. **清理并重新构建**
   - 在Xcode菜单：Product → Clean Build Folder (Shift+Cmd+K)
   - 然后：Product → Build (Cmd+B)

### 方法2：逐个添加（如果方法1不行）

1. 在Xcode项目导航器中，右键点击 "PlantGuard"
2. 选择 "Add Files to PlantGuard..."
3. 导航到 `PlantGuard/Core/Models/`，选择所有.swift文件
4. 重复步骤2-3，为以下目录添加文件：
   - `Core/Models/` (7个文件)
   - `Core/Networking/` (1个文件)
   - `Core/Storage/` (3个文件)
   - `Core/Auth/` (1个文件)
   - `Core/Services/` (2个文件)
   - `Core/Theme/` (1个文件)
   - `Core/Components/` (2个文件)
   - `Features/Home/` (4个文件)
   - `Features/Encyclopedia/` (1个文件)
   - `Features/Profile/` (1个文件)

## 验证

添加文件后，你应该能在Xcode中看到：
- ✅ 项目导航器中有 `Core` 和 `Features` 文件夹
- ✅ 所有.swift文件都在编译目标中
- ✅ 构建时没有 "Cannot find type" 错误

## 如果还有问题

1. **检查文件引用**
   - 在Xcode中选择一个文件
   - 查看右侧的File Inspector
   - 确保 "Target Membership" 中勾选了 "PlantGuard"

2. **清理派生数据**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/PlantGuard-*
   ```

3. **重新打开项目**
   - 关闭Xcode
   - 重新打开项目

