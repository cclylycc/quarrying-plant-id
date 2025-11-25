#!/bin/bash

# 快速修复 Xcode 项目文件的脚本

echo "正在清理 Xcode 缓存..."

# 清理派生数据
rm -rf ~/Library/Developer/Xcode/DerivedData/PlantGuard-*

# 清理项目用户数据
rm -rf PlantGuard.xcodeproj/project.xcworkspace/xcuserdata
rm -rf PlantGuard.xcodeproj/xcuserdata

# 清理模块缓存
rm -rf ~/Library/Caches/com.apple.dt.Xcode/*

echo "清理完成！"
echo ""
echo "请执行以下步骤："
echo "1. 完全退出 Xcode"
echo "2. 重新打开 Xcode"
echo "3. 打开 PlantGuard.xcodeproj"
echo ""
echo "如果问题仍然存在，请在 Xcode 中："
echo "- 选择 File > Open Recent > Clear Menu"
echo "- 然后重新打开项目"

