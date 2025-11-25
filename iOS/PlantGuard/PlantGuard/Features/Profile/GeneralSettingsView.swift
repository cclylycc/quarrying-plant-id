//
//  GeneralSettingsView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import UserNotifications
import UIKit

struct GeneralSettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("autoSaveEnabled") private var autoSaveEnabled = true
    @AppStorage("highQualityImages") private var highQualityImages = false
    @State private var showExportAlert = false
    @State private var showClearDataAlert = false
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Appearance") {
                Picker("Theme", selection: $storedScheme) {
                    HStack {
                        Image(systemName: "circle.lefthalf.filled")
                        Text("System")
                    }
                    .tag("System")
                    
                    HStack {
                        Image(systemName: "sun.max.fill")
                        Text("Light")
                    }
                    .tag("Light")
                    
                    HStack {
                        Image(systemName: "moon.fill")
                        Text("Dark")
                    }
                    .tag("Dark")
                }
                .pickerStyle(.menu)
            }
            
            Section("Identification") {
                Toggle("Auto-save Results", isOn: $autoSaveEnabled)
                    .onChange(of: autoSaveEnabled) { _, newValue in
                        // Auto-save is already handled in HomeView
                    }
                
                Toggle("High Quality Images", isOn: $highQualityImages)
                    .onChange(of: highQualityImages) { _, newValue in
                        // This affects image compression quality
                    }
            }
            
            Section("Notifications") {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { _, newValue in
                        if newValue {
                            requestNotificationPermission()
                        }
                    }
            }
            
            Section("Data Management") {
                Button(action: {
                    exportData()
                }) {
                    HStack {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                        Spacer()
                    }
                }
                
                Button(role: .destructive, action: {
                    showClearDataAlert = true
                }) {
                    HStack {
                        Label("Clear All Data", systemImage: "trash")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("General Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Clear All Data", isPresented: $showClearDataAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("This will delete all identification history, reports, and saved images. This action cannot be undone.")
        }
        .alert("Export Successful", isPresented: $showExportAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your data has been exported successfully.")
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    private func exportData() {
        let historyRepo = HistoryRepository.shared
        let reportRepo = ReportRepository.shared
        
        var exportText = "PlantGuard Data Export\n"
        exportText += "Generated: \(Date())\n\n"
        
        exportText += "=== Identification History ===\n"
        for record in historyRepo.records {
            exportText += "Date: \(record.date)\n"
            exportText += "Plant: \(record.plantChineseName) (\(record.plantLatinName))\n"
            exportText += "Confidence: \(Int(record.probability * 100))%\n"
            exportText += "Invasive: \(record.isInvasive ? "Yes" : "No")\n"
            if let severity = record.severity {
                exportText += "Severity: \(severity)\n"
            }
            exportText += "\n"
        }
        
        exportText += "\n=== Reports ===\n"
        for report in reportRepo.reports {
            exportText += "Date: \(report.date)\n"
            exportText += "Plant: \(report.plantChineseName) (\(report.plantLatinName))\n"
            exportText += "Location: \(report.latitude), \(report.longitude)\n"
            exportText += "Severity: \(report.severity)\n"
            exportText += "\n"
        }
        
        // Share the export
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(
                activityItems: [exportText],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityVC, animated: true)
            }
            
            self.showExportAlert = true
        }
    }
    
    private func clearAllData() {
        let historyRepo = HistoryRepository.shared
        let reportRepo = ReportRepository.shared
        let storage = FileStorageService.shared
        
        // Clear all records
        for record in historyRepo.records {
            historyRepo.deleteRecord(record)
            if let fileName = record.imageFileName {
                try? storage.delete(fileName: fileName)
            }
        }
        
        // Clear all reports
        for report in reportRepo.reports {
            reportRepo.deleteReport(report)
        }
        
        // Clear storage files
        try? storage.delete(fileName: "identification_history.json")
        try? storage.delete(fileName: "reports.json")
    }
}

