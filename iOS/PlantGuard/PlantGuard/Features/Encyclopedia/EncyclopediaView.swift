//
//  EncyclopediaView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI

struct EncyclopediaView: View {
    @State private var searchText = ""
    @State private var viewModel = EncyclopediaViewModel()
    @State private var showCamera = false
    
    var filteredSpecies: [PlantSpecies] {
        if searchText.isEmpty { return viewModel.allSpecies }
        return viewModel.allSpecies.filter {
            $0.chineseName.localizedCaseInsensitiveContains(searchText) ||
            $0.latinName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search species...", text: $searchText)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                    if searchText.isEmpty {
                        // Featured
                        featuredSection
                        
                        // Categories Grid
                        categoriesSection
                        
                        // Invasive List
                        invasiveSection
                    } else {
                        // Search Results
                        searchResultsSection
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.top)
            }
            .background(Color(.systemBackground)) // Adapts to dark mode
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ThemeToggleButton()
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraCaptureView { _ in showCamera = false }
            }
            .task { await viewModel.loadData() }
        }
    }
    
    private var featuredSection: some View {
        VStack(spacing: 16) {
            Text("Featured Species")
                .sectionTitle()
            
            NavigationLink(destination: PlantDetailView(species: viewModel.featuredSpecies)) {
                ZStack(alignment: .bottomLeading) {
                    // Placeholder Gradient/Image
                    LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("INVASIVE ALERT")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppTheme.invasive)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            Spacer()
                        }
                        
                        Text(viewModel.featuredSpecies.chineseName)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(viewModel.featuredSpecies.description)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(2)
                    }
                    .padding(24)
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: AppTheme.primary.opacity(0.3), radius: 15, x: 0, y: 8)
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var categoriesSection: some View {
        VStack(spacing: 16) {
            Text("Categories")
                .sectionTitle()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(PlantCategory.allCases, id: \.self) { category in
                    NavigationLink(destination: CategorySpeciesView(category: category)) {
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: 64, height: 64)
                                
                                Image(systemName: category.icon)
                                    .font(.title2)
                                    .foregroundColor(AppTheme.primary)
                            }
                            
                            Text(category.rawValue)
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var invasiveSection: some View {
        VStack(spacing: 16) {
            Text("High Risk List")
                .sectionTitle()
            
            VStack(spacing: 20) {
                ForEach(viewModel.invasiveSpecies) { species in
                    NavigationLink(destination: PlantDetailView(species: species)) {
                        SpeciesListRow(species: species)
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                        .padding(.leading, 80) // Indent divider
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var searchResultsSection: some View {
        LazyVStack(spacing: 0) {
            ForEach(filteredSpecies) { species in
                NavigationLink(destination: PlantDetailView(species: species)) {
                    VStack {
                        SpeciesListRow(species: species)
                            .padding(.vertical, 8)
                        Divider()
                            .padding(.leading, 80)
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@Observable
class EncyclopediaViewModel {
    var allSpecies: [PlantSpecies] = []
    var featuredSpecies: PlantSpecies = PlantSpecies(
        chineseName: "Water Hyacinth",
        latinName: "Eichhornia crassipes",
        category: .aquatic,
        isInvasive: true,
        severity: "High",
        description: "Loading...",
        habitat: nil
    )
    var invasiveSpecies: [PlantSpecies] = []
    
    func loadData() async {
        let mockData = MockDataService.shared
        allSpecies = mockData.getAllSpecies()
        featuredSpecies = mockData.getFeaturedSpecies()
        invasiveSpecies = mockData.getInvasiveSpecies()
    }
}

struct SpeciesListRow: View {
    let species: PlantSpecies
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5))
                .frame(width: 64, height: 64)
                .overlay {
                    Image(systemName: species.category.icon)
                        .foregroundColor(.gray)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(species.chineseName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(species.latinName)
                    .font(.system(.caption, design: .serif)) // Serif for Latin names looks nice
                    .italic()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if species.isInvasive {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(AppTheme.invasive)
            }
        }
    }
}

// Placeholder views that need to be implemented
struct CategorySpeciesView: View {
    let category: PlantCategory
    @State private var species: [PlantSpecies] = []
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(species) { species in
                    NavigationLink(destination: PlantDetailView(species: species)) {
                        SpeciesListRow(species: species)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .task {
            species = MockDataService.shared.getSpeciesByCategory(category)
        }
    }
}

struct PlantDetailView: View {
    let species: PlantSpecies
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Image placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.tertiarySystemFill))
                    .frame(height: 300)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                
                // Info
                VStack(alignment: .leading, spacing: 16) {
                    Text(species.chineseName)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    
                    Text(species.latinName)
                        .font(.title3)
                        .italic()
                        .foregroundColor(.secondary)
                    
                    if species.isInvasive {
                        Text("Invasive - \(species.severity ?? "High") Risk")
                            .pillBadge(color: AppTheme.invasive)
                    }
                    
                    Divider()
                    
                    Text("Description")
                        .font(.headline)
                    Text(species.description)
                        .foregroundColor(.secondary)
                    
                    if let habitat = species.habitat {
                        Text("Habitat")
                            .font(.headline)
                        Text(habitat)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .premiumCard()
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
        .navigationTitle(species.chineseName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
