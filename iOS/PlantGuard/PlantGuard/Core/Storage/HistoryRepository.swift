//
//  HistoryRepository.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

@Observable
class HistoryRepository {
    static let shared = HistoryRepository()
    
    private let storage: LocalStorageService
    private let fileName = "identification_history.json"
    
    private(set) var records: [IdentificationRecord] = []
    
    private init(storage: LocalStorageService = FileStorageService.shared) {
        self.storage = storage
        loadRecords()
    }
    
    func loadRecords() {
        do {
            records = try storage.load([IdentificationRecord].self, from: fileName)
        } catch {
            records = []
        }
    }
    
    func saveRecord(_ record: IdentificationRecord) {
        records.insert(record, at: 0)
        saveRecords()
    }
    
    func updateRecord(_ record: IdentificationRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
            saveRecords()
        }
    }
    
    func deleteRecord(_ record: IdentificationRecord) {
        records.removeAll { $0.id == record.id }
        saveRecords()
    }
    
    func getRecentRecords(limit: Int = 5) -> [IdentificationRecord] {
        Array(records.prefix(limit))
    }
    
    func getRecords(filter: HistoryFilter) -> [IdentificationRecord] {
        switch filter {
        case .all:
            return records
        case .invasive:
            return records.filter { $0.isInvasive }
        case .reported:
            return records.filter { $0.wasReported }
        }
    }
    
    private func saveRecords() {
        do {
            try storage.save(records, to: fileName)
        } catch {
            print("Failed to save records: \(error)")
        }
    }
}

enum HistoryFilter: String, CaseIterable {
    case all
    case invasive
    case reported
}

