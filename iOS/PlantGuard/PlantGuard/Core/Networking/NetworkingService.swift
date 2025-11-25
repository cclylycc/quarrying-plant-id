//
//  NetworkingService.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation
import UIKit

protocol NetworkingService {
    func identifyPlant(image: UIImage) async throws -> QuickIdentificationResponse
}

class PlantNetworkingService: NetworkingService {
    static let shared = PlantNetworkingService()
    
    private let baseURL = "http://143.47.52.94:8000"
    
    private init() {}
    
    func identifyPlant(image: UIImage) async throws -> QuickIdentificationResponse {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NetworkingError.invalidImage
        }
        
        let url = URL(string: "\(baseURL)/identify/quick")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"plant.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkingError.networkError
        }
        
        // Debug: Print actual API response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔍 API Response (raw): \(jsonString)")
        }
        
        // First, try to decode as a simple dictionary to check the structure
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            print("🔍 Parsed JSON keys: \(Array(jsonObject.keys).sorted())")
            print("🔍 JSON values:")
            for (key, value) in jsonObject {
                print("   \(key): \(value)")
            }
        }
        
        // First, try to parse as dictionary to extract values directly
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkingError.decodingError(NSError(domain: "JSONParsing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"]))
        }
        
        // Extract values directly from JSON dictionary
        let status = jsonObject["status"] as? Int ?? -1
        let message = jsonObject["message"] as? String ?? "Unknown"
        let inferenceTime = jsonObject["inference_time"] as? Double
        let chineseName = jsonObject["chinese_name"] as? String  // May not exist
        let latinName = jsonObject["latin_name"] as? String
        let probability = jsonObject["probability"] as? Double
        
        print("✅ Extracted from JSON:")
        print("   Status: \(status)")
        print("   Message: \(message)")
        print("   Chinese Name: \(chineseName ?? "nil")")
        print("   Latin Name: \(latinName ?? "nil")")
        print("   Probability: \(probability ?? -1)")
        print("   Inference Time: \(inferenceTime ?? -1)")
        
        // Parse invasive_info if present
        var invasiveInfo: InvasiveInfo? = nil
        if let invasiveInfoDict = jsonObject["invasive_info"] as? [String: Any] {
            let isInvasive = invasiveInfoDict["is_invasive"] as? Bool ?? false
            let severity = invasiveInfoDict["severity"] as? String ?? "Unknown"
            let reason = invasiveInfoDict["reason"] as? String ?? ""
            invasiveInfo = InvasiveInfo(isInvasive: isInvasive, severity: severity, reason: reason)
        }
        
        // Create response object directly from extracted values
        var result = QuickIdentificationResponse(
            status: status,
            message: message,
            inferenceTime: inferenceTime,
            chineseName: chineseName,
            latinName: latinName,
            probability: probability,
            invasiveInfo: invasiveInfo
        )
        
        // If we have latin_name but no chinese_name, use latin_name as display name
        // (API doesn't always return chinese_name)
        var finalChineseName = chineseName
        var finalLatinName = latinName ?? "Unknown Species"
        
        if finalChineseName == nil || finalChineseName!.isEmpty {
            // Use latin name as the display name if chinese name is not available
            finalChineseName = finalLatinName
            print("   ℹ️ Using latin_name as display name: \(finalLatinName)")
        }
        
        // Create final response with all extracted data
        let finalResponse = QuickIdentificationResponse(
            status: status,
            message: message,
            inferenceTime: inferenceTime ?? 0.0,
            chineseName: finalChineseName,
            latinName: finalLatinName,
            probability: probability ?? 0.0,
            invasiveInfo: invasiveInfo
        )
        
        print("✅ Final response:")
        print("   Chinese Name: \(finalResponse.chineseName ?? "nil")")
        print("   Latin Name: \(finalResponse.latinName ?? "nil")")
        print("   Probability: \(finalResponse.probability ?? -1)")
        
        // Add invasive info if needed
        if finalResponse.invasiveInfo == nil {
            return addInvasiveInfoIfNeeded(finalResponse)
        }
        
        return finalResponse
    }
    
    // Check if species is invasive using local database
    private func addInvasiveInfoIfNeeded(_ response: QuickIdentificationResponse) -> QuickIdentificationResponse {
        let database = InvasiveSpeciesDatabase.shared
        
        // Check against invasive species database
        if let invasiveInfo = database.checkIfInvasive(
            chineseName: response.chineseName,
            latinName: response.latinName
        ) {
            print("⚠️ Invasive species detected: \(response.latinName ?? "unknown")")
            print("   Severity: \(invasiveInfo.severity)")
            
            let invasiveInfoModel = InvasiveInfo(
                isInvasive: true,
                severity: invasiveInfo.severity,
                reason: invasiveInfo.reason
            )
            
            return QuickIdentificationResponse(
                status: response.status,
                message: response.message,
                inferenceTime: response.inferenceTime,
                chineseName: response.chineseName,
                latinName: response.latinName,
                probability: response.probability,
                invasiveInfo: invasiveInfoModel
            )
        }
        
        // Not invasive - return as safe species
        print("✅ Species is not in invasive database: \(response.latinName ?? "unknown")")
        return response
    }
}

enum NetworkingError: LocalizedError {
    case invalidImage
    case networkError
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Unable to process image"
        case .networkError:
            return "Network request failed. Please check your connection"
        case .decodingError(let error):
            return "Data parsing failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Mock Networking Service for Testing/Preview

class MockNetworkingService: NetworkingService {
    func identifyPlant(image: UIImage) async throws -> QuickIdentificationResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Return mock response
        return QuickIdentificationResponse(
            status: 0,
            message: "True",
            inferenceTime: 2.47,
            chineseName: "Water Hyacinth",
            latinName: "Eichhornia crassipes",
            probability: 0.966,
            invasiveInfo: InvasiveInfo(
                isInvasive: true,
                severity: "High",
                reason: "Water hyacinth is a highly invasive aquatic plant that reproduces rapidly, clogs waterways, and impacts aquatic ecosystems."
            )
        )
    }
}

