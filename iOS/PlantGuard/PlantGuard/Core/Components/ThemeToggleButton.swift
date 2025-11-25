//
//  ThemeToggleButton.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI

struct ThemeToggleButton: View {
    @AppStorage("appColorScheme") private var storedScheme: String = "System"
    
    private var currentIcon: String {
        switch storedScheme {
        case "Light":
            return "sun.max.fill"
        case "Dark":
            return "moon.fill"
        default:
            return "circle.lefthalf.filled"
        }
    }
    
    private func toggleTheme() {
        switch storedScheme {
        case "System":
            storedScheme = "Light"
        case "Light":
            storedScheme = "Dark"
        case "Dark":
            storedScheme = "System"
        default:
            storedScheme = "Light"
        }
    }
    
    var body: some View {
        Button(action: {
            toggleTheme()
        }) {
            Image(systemName: currentIcon)
                .font(.system(size: 18))
                .foregroundColor(.primary)
        }
    }
}

