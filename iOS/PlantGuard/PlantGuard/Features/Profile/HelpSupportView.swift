//
//  HelpSupportView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI

struct HelpSupportView: View {
    @State private var selectedFAQ: FAQItem?
    
    var body: some View {
        List {
            Section("Getting Started") {
                NavigationLink(destination: GuideView()) {
                    Label("User Guide", systemImage: "book.fill")
                }
                
                NavigationLink(destination: FAQView()) {
                    Label("Frequently Asked Questions", systemImage: "questionmark.circle.fill")
                }
            }
            
            Section("About") {
                NavigationLink(destination: AboutView()) {
                    Label("About PlantGuard", systemImage: "info.circle.fill")
                }
                
                HStack {
                    Label("Version", systemImage: "app.badge")
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Support") {
                Button(action: {
                    sendFeedback()
                }) {
                    HStack {
                        Label("Send Feedback", systemImage: "envelope.fill")
                        Spacer()
                    }
                }
                
                Button(action: {
                    rateApp()
                }) {
                    HStack {
                        Label("Rate App", systemImage: "star.fill")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0"
    }
    
    private func sendFeedback() {
        let email = "support@plantguard.app"
        let subject = "PlantGuard Feedback"
        let body = "Please share your feedback or report any issues you've encountered."
        
        if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Fallback: copy email to clipboard
                UIPasteboard.general.string = email
            }
        }
    }
    
    private func rateApp() {
        // In a real app, this would open the App Store rating page
        if let url = URL(string: "https://apps.apple.com/app/id1234567890") {
            UIApplication.shared.open(url)
        }
    }
}

struct GuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                GuideSection(
                    title: "1. Identify Plants",
                    icon: "camera.fill",
                    content: "Tap the camera button on any screen to take a photo of a plant. The app will use AI to identify the plant species."
                )
                
                GuideSection(
                    title: "2. View Results",
                    icon: "checkmark.circle.fill",
                    content: "After identification, you'll see the plant name, confidence level, and whether it's invasive or safe."
                )
                
                GuideSection(
                    title: "3. Report Invasive Species",
                    icon: "location.fill",
                    content: "If a plant is identified as invasive, you can report it to authorities with your location to help protect local ecosystems."
                )
                
                GuideSection(
                    title: "4. Browse Encyclopedia",
                    icon: "book.fill",
                    content: "Explore the Discover tab to learn about different plant species, their categories, and invasive species information."
                )
                
                GuideSection(
                    title: "5. View History",
                    icon: "clock.fill",
                    content: "Check your identification history in the History tab to review past identifications and reports."
                )
            }
            .padding()
        }
        .navigationTitle("User Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GuideSection: View {
    let title: String
    let icon: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppTheme.primary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct FAQView: View {
    let faqs: [FAQItem] = [
        FAQItem(
            question: "How accurate is the plant identification?",
            answer: "The accuracy depends on the quality of the photo and the plant species. The app shows a confidence percentage for each identification. For best results, take clear photos in good lighting."
        ),
        FAQItem(
            question: "What should I do if I find an invasive species?",
            answer: "If a plant is identified as invasive, you can report it through the app. This helps local authorities track and manage invasive species distribution. Make sure to provide accurate location information."
        ),
        FAQItem(
            question: "Is my data private?",
            answer: "Yes, all data is stored locally on your device. Location data is only collected when you choose to report an invasive species. You can manage your privacy settings in the Privacy section."
        ),
        FAQItem(
            question: "Can I use the app offline?",
            answer: "Plant identification requires an internet connection. However, you can browse your history and the encyclopedia offline."
        ),
        FAQItem(
            question: "How do I delete my data?",
            answer: "You can delete all your data through General Settings > Clear All Data. You can also export your data before deleting it."
        )
    ]
    
    var body: some View {
        List {
            ForEach(faqs) { faq in
                DisclosureGroup {
                    Text(faq.answer)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                } label: {
                    Text(faq.question)
                        .font(.system(.body, design: .rounded))
                }
            }
        }
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.primary)
                    .padding(.top, 40)
                
                Text("PlantGuard")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Protecting ecosystems, one identification at a time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("About")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("PlantGuard helps you identify plants and report invasive species to protect local ecosystems. Our mission is to empower citizens to contribute to biodiversity conservation through technology.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Features")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "camera.fill", text: "AI-powered plant identification")
                        FeatureRow(icon: "location.fill", text: "Invasive species reporting")
                        FeatureRow(icon: "book.fill", text: "Comprehensive plant encyclopedia")
                        FeatureRow(icon: "chart.bar.fill", text: "Personal identification history")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                Text("Version \(appVersion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0"
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primary)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
        }
    }
}

