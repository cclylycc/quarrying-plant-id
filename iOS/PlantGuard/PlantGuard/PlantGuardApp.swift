//
//  PlantGuardApp.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI

@main
struct PlantGuardApp: App {
    @AppStorage("appColorScheme") private var storedScheme: String = "System"
    
    var colorScheme: ColorScheme? {
        switch storedScheme {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil // System
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(colorScheme)
        }
    }
}
