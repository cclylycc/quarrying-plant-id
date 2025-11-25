# PlantGuard iOS 项目结构说明

## 项目概览

这是一个完整的iOS应用项目，使用SwiftUI构建，用于识别入侵植物物种并支持用户上报功能。

## 目录结构

```
iOS/
└── PlantGuard/
    ├── PlantGuard.xcodeproj/          # Xcode项目文件
    │   └── project.pbxproj
    └── PlantGuard/                    # 源代码目录
        ├── Info.plist                  # 应用配置和权限声明
        ├── Assets.xcassets/            # 资源文件
        ├── Preview Content/            # 预览资源
        │
        ├── Models/                     # 数据模型
        │   ├── InvasiveInfo.swift
        │   ├── QuickIdentificationResponse.swift
        │   ├── ReportRecord.swift
        │   ├── IdentificationHistory.swift
        │   └── PlantSpecies.swift
        │
        ├── Services/                   # 服务层
        │   ├── PlantIdentificationService.swift  # API调用服务
        │   ├── LocationService.swift             # 位置服务
        │   └── MockDataService.swift             # 模拟数据服务
        │
        ├── Storage/                    # 存储层
        │   └── StorageManager.swift   # 本地JSON文件存储管理
        │
        ├── Theme/                      # 主题和样式
        │   └── AppTheme.swift
        │
        ├── Views/                      # 视图层
        │   ├── Camera/                 # 相机相关视图
        │   │   ├── CameraView.swift
        │   │   ├── IdentificationResultView.swift
        │   │   └── ReportFlowView.swift
        │   │
        │   ├── Discover/               # 发现标签页
        │   │   └── DiscoverView.swift
        │   │
        │   ├── History/                # 历史标签页
        │   │   └── HistoryView.swift
        │   │
        │   ├── Profile/                # 个人标签页
        │   │   └── ProfileView.swift
        │   │
        │   └── MainTabView.swift       # 主标签视图和浮动相机按钮
        │
        ├── PlantGuardApp.swift         # 应用入口
        └── ContentView.swift           # 根视图
```

## 核心组件说明

### 1. Models（数据模型）

- **InvasiveInfo**: 入侵物种信息
- **QuickIdentificationResponse**: API识别响应
- **ReportRecord**: 上报记录
- **IdentificationHistory**: 识别历史记录
- **PlantSpecies**: 植物物种信息

### 2. Services（服务层）

- **PlantIdentificationService**: 
  - 处理与后端API的通信
  - 上传图片进行识别
  - 处理响应数据

- **LocationService**: 
  - 管理位置权限
  - 获取当前位置
  - 使用CoreLocation框架

- **MockDataService**: 
  - 提供模拟植物数据
  - 用于开发和测试

### 3. Storage（存储层）

- **StorageManager**: 
  - 管理本地JSON文件存储
  - 处理识别历史、上报记录和用户配置
  - 使用Documents目录存储数据

### 4. Views（视图层）

#### Camera（相机流程）
- **CameraView**: 相机/相册选择界面
- **IdentificationResultView**: 识别结果展示
- **ReportFlowView**: 上报流程（提示→位置确认→成功）

#### 标签页视图
- **DiscoverView**: 植物百科和发现功能
- **HistoryView**: 识别历史记录
- **ProfileView**: 用户信息和统计

#### 主视图
- **MainTabView**: 
  - 管理三个标签页
  - 浮动相机按钮
  - 识别流程协调

## 数据流

1. **识别流程**:
   ```
   用户点击相机按钮 
   → CameraView选择/拍摄照片 
   → PlantIdentificationService调用API 
   → IdentificationResultView显示结果 
   → 用户保存到历史或上报
   ```

2. **上报流程**:
   ```
   识别结果为入侵物种 
   → ReportFlowView提示上报 
   → 获取GPS位置 
   → 地图确认位置 
   → 保存上报记录 
   → 更新历史记录状态
   ```

3. **数据存储**:
   ```
   所有数据通过StorageManager 
   → 保存为JSON文件 
   → 存储在Documents目录
   ```

## 配置要求

- **iOS版本**: 17.0+
- **Swift版本**: 5.9+
- **Xcode版本**: 15.0+
- **后端API**: 需要运行在 `http://0.0.0.0:8000`

## 权限配置

在 `Info.plist` 中已配置：
- `NSCameraUsageDescription`: 相机权限
- `NSPhotoLibraryUsageDescription`: 相册权限
- `NSLocationWhenInUseUsageDescription`: 位置权限

## 注意事项

1. 首次运行需要授予相机和位置权限
2. 确保后端服务正在运行
3. 如果API不可用，会使用模拟数据判断入侵物种
4. 所有数据存储在本地，不会上传到外部服务器（除了识别API）

## 开发建议

1. 在Xcode中打开 `PlantGuard.xcodeproj`
2. 选择目标设备（iOS 17+）
3. 确保后端服务运行在正确地址
4. 运行项目进行测试

## 扩展功能（TODO）

- [ ] 真实的上报API集成
- [ ] 数据导出功能
- [ ] 更多成就类型
- [ ] 离线模式支持
- [ ] 植物详情图片
- [ ] 分享功能

