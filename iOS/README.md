# PlantGuard iOS App

一个用于识别入侵植物物种、教育用户并允许他们向当地有关部门报告发现的入侵物种的iOS应用。

## 功能特性

### 📱 三个主要标签页

1. **发现 (Discover)**
   - 入侵物种百科全书
   - 国家入侵物种名录
   - 分类浏览（水生植物、乔木、灌木、草本、禾草等）
   - 可搜索的植物百科

2. **历史 (History)**
   - 用户识别历史记录
   - AI识别结果和上报状态
   - 筛选功能（全部/仅入侵物种/已上报）
   - 详细的识别信息查看

3. **个人 (Profile)**
   - 用户头像和姓名编辑
   - 统计数据（总识别数、入侵物种数、上报数等）
   - 成就系统
   - 设置选项

### 📷 核心功能流程

1. **相机识别**
   - 浮动相机按钮（右下角）
   - 支持拍照或从相册选择
   - AI识别植物物种

2. **识别结果展示**
   - 植物图片
   - 中文名和拉丁名
   - 识别置信度
   - 入侵状态和风险等级

3. **上报流程**
   - 入侵物种上报提示
   - GPS位置获取和确认
   - 地图位置调整
   - 成功上报确认

## 技术栈

- **SwiftUI** (iOS 17+)
- **Swift 5.9+**
- **AVFoundation** - 相机功能
- **CoreLocation** - 位置服务
- **MapKit** - 地图显示
- **PhotosPicker** - 相册选择
- **URLSession** - 网络请求

## 项目结构

```
PlantGuard/
├── Models/
│   ├── InvasiveInfo.swift
│   ├── QuickIdentificationResponse.swift
│   ├── ReportRecord.swift
│   ├── IdentificationHistory.swift
│   └── PlantSpecies.swift
├── Services/
│   ├── PlantIdentificationService.swift
│   ├── LocationService.swift
│   └── MockDataService.swift
├── Storage/
│   └── StorageManager.swift
├── Theme/
│   └── AppTheme.swift
├── Views/
│   ├── Camera/
│   │   ├── CameraView.swift
│   │   ├── IdentificationResultView.swift
│   │   └── ReportFlowView.swift
│   ├── Discover/
│   │   └── DiscoverView.swift
│   ├── History/
│   │   └── HistoryView.swift
│   ├── Profile/
│   │   └── ProfileView.swift
│   └── MainTabView.swift
├── PlantGuardApp.swift
└── ContentView.swift
```

## 配置

### API端点

默认API地址为 `http://0.0.0.0:8000`，可在 `PlantIdentificationService.swift` 中修改：

```swift
private let baseURL = "http://0.0.0.0:8000"
```

### 权限配置

应用需要以下权限（已在 `Info.plist` 中配置）：

- **相机权限** - 用于拍摄植物照片
- **相册权限** - 用于选择已有照片
- **位置权限** - 用于记录入侵物种发现地点

## 数据存储

应用使用本地JSON文件存储：

- `identification_history.json` - 识别历史记录
- `reports.json` - 上报记录
- `user_profile.json` - 用户配置文件

所有数据存储在应用的Documents目录中。

## 使用说明

1. **启动后端服务**
   ```bash
   cd /path/to/quarrying-plant-id
   python app.py
   ```

2. **打开Xcode项目**
   - 打开 `PlantGuard.xcodeproj`
   - 选择目标设备（iOS 17+）
   - 运行项目

3. **使用应用**
   - 点击右下角的浮动相机按钮
   - 选择拍照或从相册选择
   - 等待AI识别结果
   - 如果是入侵物种，可以上报到有关部门

## 注意事项

- 确保后端服务正在运行（默认端口8000）
- 首次使用需要授予相机和位置权限
- 如果API不可用，应用会使用模拟数据判断入侵物种

## TODO

- [ ] 实现真实的上报API集成
- [ ] 添加数据导出功能
- [ ] 完善成就系统
- [ ] 添加更多植物数据
- [ ] 优化地图交互体验
- [ ] 添加离线模式支持

## 设计理念

应用设计灵感来自Apple Health应用，采用：
- 简洁优雅的界面
- 卡片式布局
- 柔和的渐变背景
- 流畅的动画效果
- 清晰的视觉层次

## 许可证

与主项目保持一致。

