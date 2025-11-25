//
//  ReportFlowView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import MapKit
import CoreLocation

struct ReportFlowView: View {
    let plantName: String
    let plantLatinName: String
    let severity: String
    let onComplete: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var currentStep: ReportStep = .prompt
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var showSuccess = false
    
    @State private var locationService = LocationService.shared
    
    enum ReportStep {
        case prompt
        case location
        case success
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient.ignoresSafeArea()
                
                switch currentStep {
                case .prompt:
                    promptView
                case .location:
                    locationView
                case .success:
                    successView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if currentStep != .success {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            locationService.requestPermission()
            locationService.startUpdatingLocation()
            if let location = locationService.currentLocation {
                selectedLocation = location.coordinate
                region.center = location.coordinate
            }
        }
    }
    
    private var promptView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppTheme.invasiveRed)
                
                Text("Report to Authorities?")
                    .font(.system(size: 32, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Risk Level: \(severity)")
                        .font(.headline)
                        .foregroundColor(AppTheme.invasiveRed)
                    
                    Text("Species: \(plantName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                Text("Reporting invasive species helps:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    Label("Help authorities take timely control measures", systemImage: "checkmark.circle.fill")
                    Label("Protect local ecosystems and biodiversity", systemImage: "checkmark.circle.fill")
                    Label("Build invasive species distribution database", systemImage: "checkmark.circle.fill")
                }
                .font(.body)
                .foregroundColor(.secondary)
            }
            .appCard()
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: {
                    currentStep = .location
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("📍 Report & Contribute")
                    }
                    .appButton(style: .destructive)
                }
                .padding(.horizontal)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .appButton(style: .secondary)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
    }
    
    private var locationView: some View {
        VStack(spacing: 20) {
            Text("Confirm Location")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Drag the map to adjust location marker")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Map(coordinateRegion: $region, annotationItems: [MapPin(coordinate: selectedLocation ?? region.center)]) { pin in
                MapMarker(coordinate: pin.coordinate, tint: .red)
            }
            .frame(height: 450)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
            .padding(.horizontal)
            .onChange(of: region.center.latitude) { _ in
                selectedLocation = region.center
            }
            .onChange(of: region.center.longitude) { _ in
                selectedLocation = region.center
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    if let location = locationService.currentLocation {
                        selectedLocation = location.coordinate
                        region.center = location.coordinate
                    }
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Use Current Location")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                    Button(action: {
                        submitReport()
                    }) {
                        Text("Confirm & Submit")
                            .appButton(style: .primary)
                    }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private var successView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
                .scaleEffect(showSuccess ? 1.0 : 0.3)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showSuccess)
            
            VStack(spacing: 12) {
                Text("Report Submitted")
                    .font(.system(size: 32, weight: .bold))
                
                Text("You've helped protect the local ecosystem. Thank you for your contribution!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            Button(action: {
                onComplete()
                dismiss()
            }) {
                Text("Learn More About This Species")
                    .appButton(style: .primary)
            }
            .padding(.horizontal)
            .padding(.bottom, 60)
        }
        .onAppear {
            withAnimation {
                showSuccess = true
            }
        }
    }
    
    private func submitReport() {
        let coordinate = selectedLocation ?? region.center
        let report = ReportRecord(
            plantChineseName: plantName,
            plantLatinName: plantLatinName,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            severity: severity
        )
        
        ReportRepository.shared.saveReport(report)
        
        // Update identification record if exists
        let historyRepo = HistoryRepository.shared
        if let record = historyRepo.records.first(where: { $0.plantChineseName == plantName }) {
            let updatedRecord = IdentificationRecord(
                id: record.id,
                date: record.date,
                plantChineseName: record.plantChineseName,
                plantLatinName: record.plantLatinName,
                probability: record.probability,
                isInvasive: record.isInvasive,
                severity: record.severity,
                reason: record.reason,
                imageFileName: record.imageFileName,
                latitude: record.latitude,
                longitude: record.longitude,
                wasReported: true,
                reportId: report.id
            )
            historyRepo.updateRecord(updatedRecord)
        }
        
        // TODO: Hook up real reporting API when available
        currentStep = .success
    }
}

struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

