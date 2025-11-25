//
//  ReportRepository.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

@Observable
class ReportRepository {
    static let shared = ReportRepository()
    
    private let storage: LocalStorageService
    private let fileName = "reports.json"
    
    private(set) var reports: [ReportRecord] = []
    
    private init(storage: LocalStorageService = FileStorageService.shared) {
        self.storage = storage
        loadReports()
    }
    
    func loadReports() {
        do {
            reports = try storage.load([ReportRecord].self, from: fileName)
        } catch {
            reports = []
        }
    }
    
    func saveReport(_ report: ReportRecord) {
        reports.insert(report, at: 0)
        saveReports()
    }
    
    func deleteReport(_ report: ReportRecord) {
        reports.removeAll { $0.id == report.id }
        saveReports()
    }
    
    func getUniqueLocations() -> Set<String> {
        var locations = Set<String>()
        for report in reports {
            let key = "\(String(format: "%.2f", report.latitude)),\(String(format: "%.2f", report.longitude))"
            locations.insert(key)
        }
        return locations
    }
    
    private func saveReports() {
        do {
            try storage.save(reports, to: fileName)
        } catch {
            print("Failed to save reports: \(error)")
        }
    }
}

