#!/bin/bash
# 简单的文件添加脚本 - 在Xcode中手动添加更可靠

echo "=========================================="
echo "需要在Xcode中手动添加文件"
echo "=========================================="
echo ""
echo "请按照以下步骤操作："
echo ""
echo "1. 打开 Xcode"
echo "2. 打开 PlantGuard.xcodeproj"
echo "3. 在Finder中，导航到:"
echo "   $(pwd)/PlantGuard/"
echo "4. 选择 Core 和 Features 文件夹"
echo "5. 拖拽到Xcode的项目导航器中"
echo "6. 确保勾选:"
echo "   - Copy items if needed"
echo "   - Create groups"
echo "   - Target: PlantGuard"
echo "7. 点击 Finish"
echo ""
echo "需要添加的文件列表："
find PlantGuard/Core PlantGuard/Features -name "*.swift" | wc -l
echo "个Swift文件"
echo ""
echo "文件位置："
find PlantGuard/Core PlantGuard/Features -name "*.swift" | head -5
echo "..."
