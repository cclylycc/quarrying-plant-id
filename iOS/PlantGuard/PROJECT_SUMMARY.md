# PlantGuard iOS App - Project Summary

## Overview

A premium iOS 17+ SwiftUI application for identifying invasive plant species, educating users, and reporting invasive species with GPS location. Built with modern SwiftUI patterns, following Apple's Human Interface Guidelines.

## Architecture

### Feature-Based Structure
- **Features/Home** - Main identification flow, recent history, reports
- **Features/Encyclopedia** - Browse and learn about plant species
- **Features/Profile** - User stats, achievements, settings

### Core Modules
- **Core/Models** - Data models (IdentificationRecord, ReportRecord, PlantSpecies, etc.)
- **Core/Networking** - API service for plant identification
- **Core/Storage** - Local JSON persistence (HistoryRepository, ReportRepository)
- **Core/Auth** - Authentication service (Google/Email, mock implementation)
- **Core/Services** - LocationService, MockDataService
- **Core/Theme** - Design system (colors, gradients, card styles)
- **Core/Components** - Reusable UI components (FloatingCameraButton, CameraCaptureView)

## Key Features

### 1. Home Tab
- Hero card for quick plant identification
- Recent identifications (last 5)
- Reports summary
- Full history and report views with filters

### 2. Encyclopedia Tab
- Featured invasive species
- Category browsing (Aquatic, Trees, Shrubs, Herbs, Grasses, Others)
- National Invasive Species List
- Searchable encyclopedia with invasive/native sections
- Detailed plant information pages

### 3. Profile Tab
- User info with editable name
- Statistics cards (total identifications, invasive count, reports, distinct species)
- Achievements system
- Settings (permissions, data export, about)

### 4. Core Flow: Camera → API → Result → Reporting
- **Step 1**: Capture photo (PhotosPicker or Camera)
- **Step 2**: Call backend API (`POST /identify/quick`)
- **Step 3**: Display result with invasive status
- **Step 4**: Report flow with GPS location confirmation
- **Step 5**: Success screen with educational link

## Technical Highlights

### Modern SwiftUI
- iOS 17+ with Swift 5.9+
- `@Observable` macro for view models
- `NavigationStack` for navigation
- `async/await` for networking
- `PhotosPicker` and AVFoundation for camera

### Design System
- Apple Health app-inspired design
- Soft gradients and blurred backgrounds
- Card-based UI with rounded corners (20pt radius)
- Subtle shadows and animations
- SF Symbols throughout

### State Management
- `@Observable` for view models
- `@State` for local view state
- `@AppStorage` for user preferences
- File-based JSON storage with `Codable`

### Networking
- Protocol-based `NetworkingService`
- Real implementation for API calls
- Mock implementation for offline testing
- Multipart form-data image upload

### Storage
- `LocalStorageService` protocol
- `FileStorageService` implementation
- Image storage in Documents directory
- JSON persistence for history and reports

## API Integration

### Endpoint
- `POST http://143.47.52.94:8000/identify/quick`
- Request: `multipart/form-data` with image file
- Response: `QuickIdentificationResponse` with plant info and invasive status

### Response Model
```swift
struct QuickIdentificationResponse {
    let status: Int
    let message: String
    let inferenceTime: Double
    let chineseName: String
    let latinName: String
    let probability: Double
    let invasiveInfo: InvasiveInfo?
}
```

## Data Models

### IdentificationRecord
- Stores user identification history
- Includes image reference, plant names, probability
- Tracks invasive status and reporting

### ReportRecord
- Stores user-submitted reports
- Includes GPS coordinates and severity
- Linked to IdentificationRecord

### PlantSpecies
- Encyclopedia data model
- Categories, descriptions, habitat info
- Invasive status and severity

## Permissions

- **Camera**: Required for plant identification
- **Photo Library**: Alternative to camera
- **Location**: Required for reporting invasive species

## TODOs

1. Replace mock authentication with real Google Sign-In SDK
2. Implement real AVFoundation camera (currently uses PhotosPicker)
3. Hook up real reporting API endpoint
4. Add data export functionality
5. Implement settings app shortcuts for permissions
6. Add about/credits screen

## Project Setup

1. Open `PlantGuard.xcodeproj` in Xcode
2. Add all new files from `Core/` and `Features/` directories to the project
3. Ensure deployment target is iOS 17.0
4. Build and run

## File Structure

```
PlantGuard/
├── Core/
│   ├── Models/
│   ├── Networking/
│   ├── Storage/
│   ├── Auth/
│   ├── Services/
│   ├── Theme/
│   └── Components/
├── Features/
│   ├── Home/
│   ├── Encyclopedia/
│   └── Profile/
├── PlantGuardApp.swift
└── MainTabView.swift
```

## Design Principles

- **Minimalism**: Clean, uncluttered interfaces
- **Consistency**: Unified design language throughout
- **Accessibility**: Clear typography and contrast
- **Performance**: Efficient state management and async operations
- **User Experience**: Smooth animations and intuitive navigation

