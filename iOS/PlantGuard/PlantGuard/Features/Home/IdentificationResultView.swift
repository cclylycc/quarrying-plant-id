//
//  IdentificationResultView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import UIKit

struct IdentificationResultView: View {
    let image: UIImage
    let result: QuickIdentificationResponse
    @Environment(\.dismiss) var dismiss
    @State private var showReportFlow = false
    
    var onReport: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 28) {
                        // Hero Image with elegant rounded frame
                        ZStack(alignment: .bottomLeading) {
                            // Shadow layer for depth
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 380)
                                .offset(y: 8)
                                .blur(radius: 20)
                            
                            // Main image container with proper clipping
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(imageAspectRatio, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                                .overlay(
                                    // Subtle border
                                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.3), Color.clear],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .overlay(alignment: .bottomLeading) {
                                    // Elegant gradient overlay for text - strictly constrained
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(result.chineseName ?? "Unknown Plant")
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.65)
                                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        
                                        if let latinName = result.latinName, !latinName.isEmpty {
                                            Text(latinName)
                                                .font(.system(size: 13, design: .serif))
                                                .italic()
                                                .foregroundColor(.white.opacity(0.95))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.75)
                                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                        }
                                    }
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 20)
                                    .padding(.top, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        LinearGradient(
                                            colors: [.clear, .black.opacity(0.5), .black.opacity(0.7)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 28,
                                            style: .continuous
                                        )
                                    )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        }
                        .padding(.horizontal, AppTheme.padding)
                        .padding(.top, 48)
                        
                        // Content Section with elegant spacing
                        VStack(spacing: 20) {
                            // Status Card
                            statusCard
                            
                            // Confidence Badge
                            if let probability = result.probability {
                                confidenceBadge(probability: probability)
                            }
                            
                            // Invasive Info Card (if applicable)
                            if let invasiveInfo = result.invasiveInfo, invasiveInfo.isInvasive {
                                invasiveInfoCard(invasiveInfo: invasiveInfo)
                            }
                            
                            // Action Buttons
                            actionButtons
                        }
                        .padding(.horizontal, AppTheme.padding)
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 32, height: 32)
                            )
                    }
                }
            }
            .sheet(isPresented: $showReportFlow) {
                ReportFlowView(
                    plantName: result.chineseName ?? "Unknown Plant",
                    plantLatinName: result.latinName ?? "",
                    severity: result.invasiveInfo?.severity ?? "High",
                    onComplete: {
                        onReport?()
                        showReportFlow = false
                    }
                )
            }
        }
    }
    
    // MARK: - UI Components
    
    private var statusCard: some View {
        VStack(spacing: 16) {
            if let invasiveInfo = result.invasiveInfo, invasiveInfo.isInvasive {
                // Invasive Species Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Invasive Species")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Risk Level: \(invasiveInfo.severity)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.95))
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(.white.opacity(0.3))
                        .padding(.vertical, 4)
                    
                    Text(invasiveInfo.reason)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.95))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [AppTheme.invasive, AppTheme.invasive.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                .shadow(color: AppTheme.invasive.opacity(0.3), radius: 12, x: 0, y: 6)
            } else {
                // Safe Species Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Safe Species")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(.white.opacity(0.3))
                        .padding(.vertical, 4)
                    
                    Text("This plant is native or not known to be invasive in this region.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.95))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [AppTheme.safe, AppTheme.safe.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                .shadow(color: AppTheme.safe.opacity(0.3), radius: 12, x: 0, y: 6)
            }
        }
    }
    
    private func confidenceBadge(probability: Double) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(AppTheme.secondary)
                .font(.headline)
            
            Text("\(Int(probability * 100))% Confidence")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.secondary)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(AppTheme.secondary.opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(AppTheme.secondary.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func invasiveInfoCard(invasiveInfo: InvasiveInfo) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(AppTheme.invasive)
                    .font(.headline)
                
                Text("Why is this invasive?")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
            }
            
            Text(invasiveInfo.reason)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .premiumCard()
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            if let invasiveInfo = result.invasiveInfo, invasiveInfo.isInvasive {
                Button(action: {
                    showReportFlow = true
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "location.fill")
                        Text("Report to Authorities")
                    }
                    .appButton(style: .destructive)
                }
            }
            
            Button(action: {
                dismiss()
            }) {
                Text("Done")
                    .appButton(style: .secondary)
            }
        }
    }

    private var imageAspectRatio: CGFloat {
        let size = image.size
        guard size.height > 0 else { return 1 }
        return size.width / size.height
    }
}
