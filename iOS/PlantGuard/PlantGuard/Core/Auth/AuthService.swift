//
//  AuthService.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

protocol AuthService {
    var currentUser: UserAccount? { get }
    func signInWithGoogle() async throws
    func signInWithEmail(email: String, password: String) async throws
    func signOut() async throws
}

@Observable
class MockAuthService: AuthService {
    static let shared = MockAuthService()
    
    private let storage: LocalStorageService
    private let userDefaultsKey = "currentUser"
    
    private(set) var currentUser: UserAccount?
    
    private init(storage: LocalStorageService = FileStorageService.shared) {
        self.storage = storage
        loadCurrentUser()
    }
    
    func signInWithGoogle() async throws {
        // TODO: Replace with real Google Sign-In SDK
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let user = UserAccount(
            displayName: "Google User",
            email: "user@gmail.com",
            authProvider: .google
        )
        
        currentUser = user
        saveCurrentUser(user)
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        // TODO: Replace with real email/password authentication
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Basic validation
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        
        let user = UserAccount(
            displayName: email.components(separatedBy: "@").first ?? "User",
            email: email,
            authProvider: .email
        )
        
        currentUser = user
        saveCurrentUser(user)
    }
    
    func signOut() async throws {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    private func loadCurrentUser() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(UserAccount.self, from: data) {
            currentUser = user
        }
    }
    
    private func saveCurrentUser(_ user: UserAccount) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please try again"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

