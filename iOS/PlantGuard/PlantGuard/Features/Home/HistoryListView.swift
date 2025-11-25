//
//  HistoryListView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import UIKit

struct HistoryListView: View {
    @State private var filter: HistoryFilter = .all
    private let historyRepository = HistoryRepository.shared
    
    var filteredRecords: [IdentificationRecord] {
        historyRepository.getRecords(filter: filter)
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Segmented Control
                pickerView
                    .padding()
                
                if filteredRecords.isEmpty {
                    ContentUnavailableView("No Records", systemImage: "clock", description: Text("Start identifying plants to build your history."))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredRecords) { record in
                                NavigationLink(destination: IdentificationDetailView(record: record)) {
                                    ModernListRow(record: record)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, AppTheme.padding)
                    }
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var pickerView: some View {
        HStack(spacing: 0) {
            ForEach(HistoryFilter.allCases, id: \.self) { option in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        filter = option
                    }
                }) {
                    Text(optionName(option))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(filter == option ? .semibold : .regular)
                        .foregroundColor(filter == option ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(filter == option ? AppTheme.primary : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func optionName(_ filter: HistoryFilter) -> String {
        switch filter {
        case .all: return "All"
        case .invasive: return "Invasive"
        case .reported: return "Reported"
        }
    }
}

// Helper to reuse row
extension IdentificationRecord {
    func toPlantSpecies() -> PlantSpecies {
        PlantSpecies(
            chineseName: self.plantChineseName,
            latinName: self.plantLatinName,
            category: .others,
            isInvasive: self.isInvasive,
            severity: self.severity,
            description: ""
        )
    }
}

struct ModernListRow: View {
    let record: IdentificationRecord
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5))
                .frame(width: 64, height: 64)
                .overlay {
                    if let fileName = record.imageFileName,
                       let image = FileStorageService.shared.loadImage(fileName: fileName) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(record.plantChineseName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(record.plantLatinName)
                    .font(.system(.caption, design: .serif))
                    .italic()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if record.isInvasive {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(AppTheme.invasive)
            }
        }
        .padding(.vertical, 8)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius / 2, style: .continuous))
        .shadow(color: AppTheme.shadowLight.color, radius: AppTheme.shadowLight.radius, x: AppTheme.shadowLight.x, y: AppTheme.shadowLight.y)
    }
}

struct IdentificationDetailView: View {
    let record: IdentificationRecord
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Image with rounded frame
                if let fileName = record.imageFileName,
                   let image = FileStorageService.shared.loadImage(fileName: fileName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        .shadow(color: AppTheme.shadow.color, radius: AppTheme.shadow.radius, x: AppTheme.shadow.x, y: AppTheme.shadow.y)
                } else {
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                        .fill(Color(.systemGray5))
                        .frame(height: 300)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                }
                
                // Info Card
                VStack(alignment: .leading, spacing: 20) {
                    // Plant Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text(record.plantChineseName)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(record.plantLatinName)
                            .font(.system(.title3, design: .serif))
                            .italic()
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Confidence Badge
                    HStack {
                        Text("\(Int(record.probability * 100))% Confidence")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(AppTheme.secondary.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Invasive Status
                    if record.isInvasive {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(AppTheme.invasive)
                                
                                Text("Invasive Species")
                                    .font(.system(.headline, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.invasive)
                            }
                            
                            if let severity = record.severity {
                                Text("Risk Level: \(severity)")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            
                            if let reason = record.reason {
                                Text(reason)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.invasive.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius / 2, style: .continuous))
                    } else {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(AppTheme.safe)
                            
                            Text("Safe Species")
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.safe)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.safe.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius / 2, style: .continuous))
                    }
                    
                    // Report Status
                    if record.wasReported {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("Reported to Authorities")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius / 2, style: .continuous))
                    }
                    
                    // Date
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Identified on")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        Text(record.date, format: .dateTime.day().month().year().hour().minute())
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .premiumCard()
            }
            .padding(.horizontal, AppTheme.padding)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
