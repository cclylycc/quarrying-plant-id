//
//  HomeView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import UIKit

struct HomeView: View {
    @State private var showCamera = false
    @State private var showResult = false
    @State private var capturedImage: UIImage?
    @State private var identificationResult: QuickIdentificationResponse?
    @State private var isIdentifying = false
    
    @State private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Section
                    heroSection
                        .padding(.top, 10)
                    
                    // Recent Identifications
                    if !homeViewModel.recentRecords.isEmpty {
                        recentSection
                    }
                    
                    // Stats/Reports
                    reportSummarySection
                    
                    Spacer(minLength: 80) // Space for floating button
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PlantGuard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ThemeToggleButton()
                }
            }
            .sheet(isPresented: $showCamera, onDismiss: {
                // Process image after sheet is fully dismissed
                if let image = capturedImage {
                    identifyPlant(image: image)
                }
            }) {
                CameraCaptureView { image in
                    // Store image and close sheet
                    capturedImage = image
                    showCamera = false
                }
            }
            .fullScreenCover(isPresented: $showResult) {
                if let image = capturedImage, let result = identificationResult {
                    IdentificationResultView(
                        image: image,
                        result: result,
                        onReport: {
                            updateHistoryWithReport(result: result)
                        }
                    )
                }
            }
            .overlay {
                if isIdentifying {
                    loadingOverlay
                }
            }
            .task {
                await homeViewModel.loadData()
            }
        }
    }
    
    // MARK: - UI Components
    
    private var heroSection: some View {
        Button(action: { showCamera = true }) {
            ZStack(alignment: .bottomLeading) {
                // Simulated Image Background with Gradient
                LinearGradient(
                    colors: [Color(hex: "1B5E20"), Color(hex: "4CAF50")],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Text("Tap to Identify")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Text("Identify Invasive Species")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text("Protect your local ecosystem by identifying and reporting harmful plants.")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                }
                .padding(24)
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
    
    private var recentSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                
                Spacer()
                
                NavigationLink(destination: HistoryListView()) {
                    Text("See All")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.primary)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(homeViewModel.recentRecords) { record in
                        NavigationLink(destination: IdentificationDetailView(record: record)) {
                            RecentCard(record: record)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // Space for shadow
            }
        }
    }
    
    private var reportSummarySection: some View {
        VStack(spacing: 16) {
            Text("Impact")
                .sectionTitle()
            
            HStack(spacing: 12) {
                // Total Reports Card
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(AppTheme.primary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(homeViewModel.totalReports)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Reports Submitted")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .premiumCard()
                
                // Latest Contribution Card
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "clock.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(AppTheme.accent)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(homeViewModel.lastReport != nil ? formatDate(homeViewModel.lastReport!.date) : "None")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)
                        
                        Text("Latest Contribution")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .premiumCard()
            }
            .padding(.horizontal)
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: 24) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Analyzing Plant...")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
    
    // MARK: - Helpers
    private func identifyPlant(image: UIImage) {
        isIdentifying = true
        Task {
            do {
                let result = try await PlantNetworkingService.shared.identifyPlant(image: image)
                await MainActor.run {
                    identificationResult = result
                    isIdentifying = false
                    
                    // Automatically save to history
                    saveToHistory(image: image, result: result)
                    
                    // Show result
                    showResult = true
                }
            } catch {
                await MainActor.run {
                    isIdentifying = false
                    // Ideally show toast/alert
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func saveToHistory(image: UIImage, result: QuickIdentificationResponse) {
        // Validate required fields
        guard let chineseName = result.chineseName,
              let latinName = result.latinName,
              let probability = result.probability else {
            print("Error: API response missing required fields")
            return
        }
        
        let storage = FileStorageService.shared
        let fileName = "\(UUID().uuidString).jpg"
        try? storage.saveImage(image, fileName: fileName)
        
        let record = IdentificationRecord(
            plantChineseName: chineseName,
            plantLatinName: latinName,
            probability: probability,
            isInvasive: result.invasiveInfo?.isInvasive ?? false,
            severity: result.invasiveInfo?.severity,
            reason: result.invasiveInfo?.reason,
            imageFileName: fileName
        )
        HistoryRepository.shared.saveRecord(record)
        Task { await homeViewModel.loadData() }
    }
    
    private func updateHistoryWithReport(result: QuickIdentificationResponse) {
        Task { await homeViewModel.loadData() }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Subviews

struct RecentCard: View {
    let record: IdentificationRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area
            if let fileName = record.imageFileName,
               let image = FileStorageService.shared.loadImage(fileName: fileName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 160, height: 160)
                    .overlay(Image(systemName: "photo").font(.largeTitle).foregroundColor(.gray))
            }
            
            // Info Area
            VStack(alignment: .leading, spacing: 8) {
                Text(record.plantChineseName)
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                HStack {
                    if record.isInvasive {
                        Label("Invasive", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.invasive)
                    } else {
                        Label("Safe", systemImage: "checkmark.shield.fill")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.safe)
                    }
                }
            }
            .padding(12)
            .frame(width: 160, alignment: .leading)
            .background(Color(.systemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

@Observable
class HomeViewModel {
    var recentRecords: [IdentificationRecord] = []
    var totalReports: Int = 0
    var lastReport: ReportRecord?
    
    func loadData() async {
        let historyRepo = HistoryRepository.shared
        let reportRepo = ReportRepository.shared
        
        recentRecords = historyRepo.getRecentRecords(limit: 5)
        totalReports = reportRepo.reports.count
        lastReport = reportRepo.reports.first
    }
}
