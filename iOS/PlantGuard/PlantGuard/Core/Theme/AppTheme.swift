//
//  AppTheme.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import UIKit

struct AppTheme {
    // MARK: - Colors
    // Nature-inspired premium colors
    static let primary = Color(hex: "2E7D32") // Deep Forest Green
    static let secondary = Color(hex: "81C784") // Soft Green
    static let accent = Color(hex: "FFB74D") // Warm Orange
    static let background = Color(hex: "F2F2F7") // System Gray 6 equivalent for base
    
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "43A047"), Color(hex: "2E7D32")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [Color(uiColor: .systemBackground).opacity(0.95), Color(uiColor: .systemBackground).opacity(0.85)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Semantic Colors
    static let invasive = Color(hex: "D32F2F") // Alert Red
    static let invasiveRed = Color(hex: "D32F2F") // Alert Red (alias for compatibility)
    static let safe = Color(hex: "388E3C") // Safe Green
    static let warning = Color(hex: "F57C00") // Warning Orange
    
    // Text Colors
    static let textSecondary = Color.secondary
    static let textPrimary = Color.primary
    
    // Surface Colors
    static var surface: Color {
        Color(uiColor: .systemBackground)
    }
    
    // Compatibility aliases for old code
    static let primaryAccent = primary
    static let secondaryAccent = secondary
    
    // MARK: - Layout
    static let cornerRadius: CGFloat = 24
    static let cardCornerRadius: CGFloat = 24 // Alias for compatibility
    static let padding: CGFloat = 20
    static let cardPadding: CGFloat = 20 // Alias for compatibility
    
    // Background gradients
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(uiColor: .systemGroupedBackground),
                Color(uiColor: .systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Shadows
    static let shadow = ShadowStyle(
        color: Color.black.opacity(0.08),
        radius: 15,
        x: 0,
        y: 5
    )
    
    static let shadowLight = ShadowStyle(
        color: Color.black.opacity(0.04),
        radius: 4,
        x: 0,
        y: 2
    )
}

// MARK: - Helper Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers
struct PremiumCardModifier: ViewModifier {
    var padding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(
                        color: AppTheme.shadow.color,
                        radius: AppTheme.shadow.radius,
                        x: AppTheme.shadow.x,
                        y: AppTheme.shadow.y
                    )
            }
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppTheme.primary)
                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
            }
    }
}

extension View {
    func premiumCard(padding: CGFloat = 20) -> some View {
        modifier(PremiumCardModifier(padding: padding))
    }
    
    // Compatibility alias
    func appCard(style: CardStyle = .default) -> some View {
        premiumCard(padding: AppTheme.cardPadding)
    }
    
    func primaryButtonStyle() -> some View {
        modifier(PrimaryButtonModifier())
    }
    
    // Compatibility for old appButton usage
    func appButton(style: ButtonStyle = .primary) -> some View {
        self
            .font(.system(.headline, design: .rounded))
            .foregroundColor(style == .primary || style == .destructive ? .white : .primary)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(style == .primary ? AppTheme.primary : 
                          style == .destructive ? AppTheme.invasive : 
                          Color(uiColor: .secondarySystemBackground))
                    .shadow(
                        color: (style == .primary ? AppTheme.primary : 
                               style == .destructive ? AppTheme.invasive : 
                               Color.clear).opacity(0.3),
                        radius: 8, x: 0, y: 4
                    )
            }
    }
    
    // Secondary button style
    func appSecondaryButton() -> some View {
        self
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.primary)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))
            }
    }
    
    // Pill badge modifier
    func pillBadge(color: Color = .blue) -> some View {
        self
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
    
    func sectionTitle() -> some View {
        self
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 10)
    }
}

// Compatibility enums for old code
enum CardStyle {
    case `default`
    case thin
    case gradient
}

enum ButtonStyle {
    case primary
    case secondary
    case destructive
}
