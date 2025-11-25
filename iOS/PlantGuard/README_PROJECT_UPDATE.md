# Project Update Instructions

由于项目文件结构复杂，建议在Xcode中手动添加新文件：

## 需要添加的文件

### Core/Models
- Core/Models/InvasiveInfo.swift
- Core/Models/QuickIdentificationResponse.swift
- Core/Models/IdentificationRecord.swift
- Core/Models/ReportRecord.swift
- Core/Models/PlantSpecies.swift
- Core/Models/UserAccount.swift
- Core/Models/Achievement.swift

### Core/Networking
- Core/Networking/NetworkingService.swift

### Core/Storage
- Core/Storage/LocalStorageService.swift
- Core/Storage/HistoryRepository.swift
- Core/Storage/ReportRepository.swift

### Core/Auth
- Core/Auth/AuthService.swift

### Core/Services
- Core/Services/LocationService.swift
- Core/Services/MockDataService.swift

### Core/Theme
- Core/Theme/AppTheme.swift

### Core/Components
- Core/Components/FloatingCameraButton.swift
- Core/Components/CameraCaptureView.swift

### Features/Home
- Features/Home/HomeView.swift
- Features/Home/IdentificationResultView.swift
- Features/Home/ReportFlowView.swift
- Features/Home/HistoryListView.swift

### Features/Encyclopedia
- Features/Encyclopedia/EncyclopediaView.swift

### Features/Profile
- Features/Profile/ProfileView.swift

## 步骤

1. 在Xcode中打开项目
2. 右键点击项目导航器中的"PlantGuard"组
3. 选择"Add Files to PlantGuard..."
4. 选择上述文件（可以多选）
5. 确保勾选"Copy items if needed"（如果文件不在项目目录中）
6. 确保勾选"Create groups"（不是folder references）
7. 确保勾选目标"PlantGuard"
8. 点击"Add"

所有文件应该会自动添加到正确的编译阶段。

