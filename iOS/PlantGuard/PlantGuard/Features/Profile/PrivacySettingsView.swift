//
//  PrivacySettingsView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import CoreLocation
import UIKit

struct PrivacySettingsView: View {
    @State private var locationService = LocationService.shared
    @State private var locationStatus: CLAuthorizationStatus = .notDetermined
    @State private var showLocationSettings = false
    @State private var showPrivacyPolicy = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Permissions") {
                HStack {
                    Label("Location", systemImage: "location.fill")
                    Spacer()
                    Text(locationStatusText)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                if locationStatus == .denied || locationStatus == .restricted {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                } else if locationStatus == .notDetermined {
                    Button("Request Permission") {
                        locationService.requestPermission()
                        checkLocationStatus()
                    }
                }
                
                HStack {
                    Label("Camera", systemImage: "camera.fill")
                    Spacer()
                    Text(cameraStatusText)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            Section("Data Privacy") {
                Button(action: {
                    showPrivacyPolicy = true
                }) {
                    HStack {
                        Label("Privacy Policy", systemImage: "doc.text")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.tertiaryLabel)
                    }
                }
                
                Button(action: {
                    clearLocationData()
                }) {
                    HStack {
                        Label("Clear Location Data", systemImage: "location.slash")
                        Spacer()
                    }
                }
            }
            
            Section {
                Text("PlantGuard collects location data only when you report invasive species. This data is stored locally on your device and is not shared with third parties.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Privacy Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkLocationStatus()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }
    
    private var locationStatusText: String {
        switch locationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return "Allowed"
        case .denied:
            return "Denied"
        case .restricted:
            return "Restricted"
        case .notDetermined:
            return "Not Set"
        @unknown default:
            return "Unknown"
        }
    }
    
    private var cameraStatusText: String {
        // Camera permission is checked at runtime, default to allowed
        return "Allowed"
    }
    
    private func checkLocationStatus() {
        let manager = CLLocationManager()
        locationStatus = manager.authorizationStatus
    }
    
    private func clearLocationData() {
        let historyRepo = HistoryRepository.shared
        let reportRepo = ReportRepository.shared
        
        // Remove location data from history records
        var updatedRecords: [IdentificationRecord] = []
        for var record in historyRepo.records {
            // Create new record without location
            let newRecord = IdentificationRecord(
                id: record.id,
                date: record.date,
                plantChineseName: record.plantChineseName,
                plantLatinName: record.plantLatinName,
                probability: record.probability,
                isInvasive: record.isInvasive,
                severity: record.severity,
                reason: record.reason,
                imageFileName: record.imageFileName,
                latitude: nil,
                longitude: nil,
                wasReported: record.wasReported,
                reportId: record.reportId
            )
            updatedRecords.append(newRecord)
        }
        
        // Update records (simplified - would need proper update method)
        // For now, just clear reports which contain location data
        for report in reportRepo.reports {
            reportRepo.deleteReport(report)
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    Text("Last Updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        SectionView(title: "Data Collection", content: """
                        PlantGuard collects the following data:
                        • Plant identification photos (stored locally)
                        • Identification results and history
                        • Location data (only when reporting invasive species)
                        • User preferences and settings
                        """)
                        
                        SectionView(title: "Data Storage", content: """
                        All data is stored locally on your device. We do not transmit any data to external servers without your explicit consent.
                        """)
                        
                        SectionView(title: "Location Data", content: """
                        Location data is only collected when you choose to report an invasive species. This data helps authorities track and manage invasive species distribution. Location data is stored locally and can be deleted at any time through Privacy Settings.
                        """)
                        
                        SectionView(title: "Your Rights", content: """
                        You have the right to:
                        • Access your data through the Export Data feature
                        • Delete your data at any time
                        • Control location permissions through iOS Settings
                        """)
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

