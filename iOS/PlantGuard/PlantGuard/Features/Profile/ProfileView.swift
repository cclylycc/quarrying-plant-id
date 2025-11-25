//
//  ProfileView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName = "Explorer"
    @State private var isEditingName = false
    @State private var editedName = ""
    @State private var viewModel = ProfileViewModel()
    @State private var showCamera = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerSection
                        .padding(.top, 20)
                    
                    // Stats Grid
                    statsSection
                    
                    // Achievements
                    achievementsSection
                    
                    // Settings List
                    settingsSection
                    
                    Spacer(minLength: 80)
                }
                .padding(.horizontal)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ThemeToggleButton()
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraCaptureView { _ in showCamera = false }
            }
            .task { await viewModel.loadData() }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryGradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 10, y: 5)
                
                Text(String(userName.prefix(1)))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            if isEditingName {
                HStack {
                    TextField("Name", text: $editedName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    
                    Button("Done") {
                        userName = editedName
                        isEditingName = false
                    }
                    .fontWeight(.bold)
                }
            } else {
                HStack {
                    Text(userName)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Button {
                        editedName = userName
                        isEditingName = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Text("Nature Guardian Level 1")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())
        }
    }
    
    private var statsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatBox(title: "Identified", value: "\(viewModel.totalIdentifications)", icon: "camera.fill", color: AppTheme.primary)
            StatBox(title: "Invasive", value: "\(viewModel.invasiveCount)", icon: "exclamationmark.triangle.fill", color: AppTheme.invasive)
            StatBox(title: "Reports", value: "\(viewModel.reportsCount)", icon: "location.fill", color: AppTheme.accent)
            StatBox(title: "Species", value: "\(viewModel.distinctSpeciesCount)", icon: "leaf.fill", color: AppTheme.secondary)
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
                .padding(.vertical, 10) // Space for shadow
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            VStack(spacing: 0) {
                NavigationLink(destination: GeneralSettingsView()) {
                    SettingsRow(icon: "gear", title: "General", showDivider: true)
                }
                .buttonStyle(.plain)
                
                NavigationLink(destination: PrivacySettingsView()) {
                    SettingsRow(icon: "lock", title: "Privacy", showDivider: true)
                }
                .buttonStyle(.plain)
                
                NavigationLink(destination: HelpSupportView()) {
                    SettingsRow(icon: "questionmark.circle", title: "Help & Support", showDivider: false)
                }
                .buttonStyle(.plain)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

@Observable
class ProfileViewModel {
    var totalIdentifications: Int = 0
    var invasiveCount: Int = 0
    var reportsCount: Int = 0
    var distinctSpeciesCount: Int = 0
    var achievements: [Achievement] = []
    
    func loadData() async {
        let historyRepo = HistoryRepository.shared
        let reportRepo = ReportRepository.shared
        
        totalIdentifications = historyRepo.records.count
        invasiveCount = historyRepo.records.filter { $0.isInvasive }.count
        reportsCount = reportRepo.reports.count
        
        let distinctNames = Set(historyRepo.records.map { $0.plantChineseName })
        distinctSpeciesCount = distinctNames.count
        
        achievements = calculateAchievements(
            totalIdentifications: totalIdentifications,
            invasiveCount: invasiveCount,
            reportsCount: reportsCount
        )
    }
    
    private func calculateAchievements(
        totalIdentifications: Int,
        invasiveCount: Int,
        reportsCount: Int
    ) -> [Achievement] {
        var achievements: [Achievement] = []
        
        if totalIdentifications > 0 {
            achievements.append(Achievement(
                id: "first_identification",
                name: "First Identification",
                description: "Identified your first plant",
                unlockCondition: "Identify 1 plant",
                dateUnlocked: Date(),
                icon: "camera.fill"
            ))
        }
        
        if reportsCount > 0 {
            achievements.append(Achievement(
                id: "first_report",
                name: "First Report",
                description: "Reported your first invasive species",
                unlockCondition: "Report 1 invasive species",
                dateUnlocked: Date(),
                icon: "location.fill"
            ))
        }
        
        if totalIdentifications >= 10 {
            achievements.append(Achievement(
                id: "ten_plants",
                name: "Plant Explorer",
                description: "Identified 10 different plants",
                unlockCondition: "Identify 10 plants",
                dateUnlocked: Date(),
                icon: "leaf.fill"
            ))
        }
        
        if invasiveCount >= 3 {
            achievements.append(Achievement(
                id: "three_invasive",
                name: "Invasive Hunter",
                description: "Found 3 invasive species",
                unlockCondition: "Identify 3 invasive species",
                dateUnlocked: Date(),
                icon: "exclamationmark.triangle.fill"
            ))
        }
        
        return achievements
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .padding(10)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Spacer()
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(height: 140)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? AppTheme.accent : Color(.tertiarySystemFill))
                    .frame(width: 70, height: 70)
                
                Image(systemName: achievement.icon)
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            Text(achievement.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
        .opacity(achievement.isUnlocked ? 1 : 0.5)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let showDivider: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(.body, design: .rounded))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.tertiaryLabel)
            }
            .padding(16)
            
            if showDivider {
                Divider()
                    .padding(.leading, 56)
            }
        }
    }
}

extension Color {
    static let tertiaryLabel = Color(uiColor: .tertiaryLabel)
}
