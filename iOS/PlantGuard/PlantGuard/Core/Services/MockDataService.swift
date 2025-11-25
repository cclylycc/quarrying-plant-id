//
//  MockDataService.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    func getAllSpecies() -> [PlantSpecies] {
        [
            PlantSpecies(
                chineseName: "Water Hyacinth",
                latinName: "Eichhornia crassipes",
                category: .aquatic,
                isInvasive: true,
                severity: "High",
                description: "Water hyacinth is a highly invasive aquatic plant native to South America. It reproduces rapidly, forming dense floating mats that clog waterways, affecting aquatic ecosystems and navigation.",
                habitat: "Freshwater lakes, rivers, ponds",
                distribution: "Tropical and subtropical regions worldwide",
                imageNames: nil
            ),
            PlantSpecies(
                chineseName: "Giant Salvinia",
                latinName: "Salvinia molesta",
                category: .aquatic,
                isInvasive: true,
                severity: "High",
                description: "Giant salvinia is a free-floating aquatic fern that forms dense mats on water surfaces, blocking sunlight and depleting oxygen levels.",
                habitat: "Still or slow-moving freshwater",
                distribution: "Tropical and subtropical regions",
                imageNames: nil
            ),
            PlantSpecies(
                chineseName: "Tree of Heaven",
                latinName: "Ailanthus altissima",
                category: .trees,
                isInvasive: true,
                severity: "High",
                description: "Tree of Heaven is a fast-growing deciduous tree that spreads aggressively through root suckers and seeds, outcompeting native vegetation.",
                habitat: "Urban areas, roadsides, disturbed sites",
                distribution: "Temperate regions worldwide",
                imageNames: nil
            ),
            PlantSpecies(
                chineseName: "Japanese Knotweed",
                latinName: "Fallopia japonica",
                category: .herbs,
                isInvasive: true,
                severity: "High",
                description: "Japanese knotweed is a perennial herbaceous plant that forms dense thickets, displacing native plants and causing structural damage.",
                habitat: "Riversides, roadsides, disturbed areas",
                distribution: "Temperate regions",
                imageNames: nil
            ),
            PlantSpecies(
                chineseName: "Common Reed",
                latinName: "Phragmites australis",
                category: .grasses,
                isInvasive: true,
                severity: "Medium",
                description: "Common reed is a tall perennial grass that forms dense stands in wetlands, altering ecosystem structure.",
                habitat: "Wetlands, marshes, riverbanks",
                distribution: "Worldwide",
                imageNames: nil
            ),
            PlantSpecies(
                chineseName: "Native Oak",
                latinName: "Quercus robur",
                category: .trees,
                isInvasive: false,
                severity: nil,
                description: "Native oak is a large deciduous tree native to temperate regions, providing important habitat for wildlife.",
                habitat: "Forests, woodlands",
                distribution: "Temperate regions",
                imageNames: nil
            )
        ]
    }
    
    func getFeaturedSpecies() -> PlantSpecies {
        getAllSpecies().first { $0.isInvasive } ?? getAllSpecies().first!
    }
    
    func getSpeciesByCategory(_ category: PlantCategory) -> [PlantSpecies] {
        getAllSpecies().filter { $0.category == category }
    }
    
    func getInvasiveSpecies() -> [PlantSpecies] {
        getAllSpecies().filter { $0.isInvasive }
    }
}

