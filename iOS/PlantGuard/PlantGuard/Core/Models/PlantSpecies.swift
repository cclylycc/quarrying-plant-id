//
//  PlantSpecies.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct PlantSpecies: Identifiable, Codable {
    let id: UUID
    let chineseName: String
    let latinName: String
    let category: PlantCategory
    let isInvasive: Bool
    let severity: String?
    let description: String
    let habitat: String?
    let distribution: String?
    let imageNames: [String]?
    
    init(
        id: UUID = UUID(),
        chineseName: String,
        latinName: String,
        category: PlantCategory,
        isInvasive: Bool = false,
        severity: String? = nil,
        description: String,
        habitat: String? = nil,
        distribution: String? = nil,
        imageNames: [String]? = nil
    ) {
        self.id = id
        self.chineseName = chineseName
        self.latinName = latinName
        self.category = category
        self.isInvasive = isInvasive
        self.severity = severity
        self.description = description
        self.habitat = habitat
        self.distribution = distribution
        self.imageNames = imageNames
    }
}

enum PlantCategory: String, Codable, CaseIterable {
    case aquatic = "Aquatic"
    case trees = "Trees"
    case shrubs = "Shrubs"
    case herbs = "Herbs"
    case grasses = "Grasses"
    case others = "Others"
    
    var icon: String {
        switch self {
        case .aquatic: return "drop.fill"
        case .trees: return "tree.fill"
        case .shrubs: return "leaf.fill"
        case .herbs: return "leaf.circle.fill"
        case .grasses: return "circle.grid.hex.fill"
        case .others: return "questionmark.circle.fill"
        }
    }
}

