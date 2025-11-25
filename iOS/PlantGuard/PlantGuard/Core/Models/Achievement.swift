//
//  Achievement.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let unlockCondition: String
    let dateUnlocked: Date?
    let icon: String
    
    var isUnlocked: Bool {
        dateUnlocked != nil
    }
    
    init(
        id: String,
        name: String,
        description: String,
        unlockCondition: String,
        dateUnlocked: Date? = nil,
        icon: String = "star.fill"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.unlockCondition = unlockCondition
        self.dateUnlocked = dateUnlocked
        self.icon = icon
    }
}

