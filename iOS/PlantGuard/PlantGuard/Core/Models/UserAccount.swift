//
//  UserAccount.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct UserAccount: Codable {
    let id: UUID
    let displayName: String
    let email: String?
    let authProvider: AuthProvider
    
    init(
        id: UUID = UUID(),
        displayName: String,
        email: String? = nil,
        authProvider: AuthProvider
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.authProvider = authProvider
    }
}

enum AuthProvider: String, Codable {
    case google
    case email
    case guest
}

