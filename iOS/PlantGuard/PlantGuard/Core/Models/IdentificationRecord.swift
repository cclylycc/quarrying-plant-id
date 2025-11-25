//
//  IdentificationRecord.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct IdentificationRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let plantChineseName: String
    let plantLatinName: String
    let probability: Double
    let isInvasive: Bool
    let severity: String?
    let reason: String?
    let imageFileName: String?
    let latitude: Double?
    let longitude: Double?
    let wasReported: Bool
    let reportId: UUID?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        plantChineseName: String,
        plantLatinName: String,
        probability: Double,
        isInvasive: Bool = false,
        severity: String? = nil,
        reason: String? = nil,
        imageFileName: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        wasReported: Bool = false,
        reportId: UUID? = nil
    ) {
        self.id = id
        self.date = date
        self.plantChineseName = plantChineseName
        self.plantLatinName = plantLatinName
        self.probability = probability
        self.isInvasive = isInvasive
        self.severity = severity
        self.reason = reason
        self.imageFileName = imageFileName
        self.latitude = latitude
        self.longitude = longitude
        self.wasReported = wasReported
        self.reportId = reportId
    }
}

