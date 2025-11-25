//
//  InvasiveInfo.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct InvasiveInfo: Codable {
    let isInvasive: Bool
    let severity: String
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case isInvasive = "is_invasive"
        case severity
        case reason
    }
}

