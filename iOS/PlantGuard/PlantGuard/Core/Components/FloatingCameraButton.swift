//
//  FloatingCameraButton.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI

struct FloatingCameraButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            Image(systemName: "camera.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.primaryAccent, AppTheme.secondaryAccent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: Color.black.opacity(0.25),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                }
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .opacity(isPressed ? 0.8 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingCameraButtonOverlay: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingCameraButton(action: action)
                        .padding(.trailing, 20)
                        .padding(.bottom, 100)
                }
            }
        }
    }
}

extension View {
    func floatingCameraButton(action: @escaping () -> Void) -> some View {
        modifier(FloatingCameraButtonOverlay(action: action))
    }
}

