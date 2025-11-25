//
//  ReportRecord.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct ReportRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let plantChineseName: String
    let plantLatinName: String
    let latitude: Double
    let longitude: Double
    let severity: String
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        plantChineseName: String,
        plantLatinName: String,
        latitude: Double,
        longitude: Double,
        severity: String
    ) {
        self.id = id
        self.date = date
        self.plantChineseName = plantChineseName
        self.plantLatinName = plantLatinName
        self.latitude = latitude
        self.longitude = longitude
        self.severity = severity
    }
}

