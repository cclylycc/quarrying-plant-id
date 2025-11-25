//
//  LocalStorageService.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation
import UIKit

protocol LocalStorageService {
    func load<T: Decodable>(_ type: T.Type, from fileName: String) throws -> T
    func save<T: Encodable>(_ value: T, to fileName: String) throws
    func delete(fileName: String) throws
}

class FileStorageService: LocalStorageService {
    static let shared = FileStorageService()
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private init() {}
    
    func load<T: Decodable>(_ type: T.Type, from fileName: String) throws -> T {
        let url = documentsDirectory.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw StorageError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }
    
    func save<T: Encodable>(_ value: T, to fileName: String) throws {
        let url = documentsDirectory.appendingPathComponent(fileName)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(value)
        try data.write(to: url)
    }
    
    func delete(fileName: String) throws {
        let url = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    func saveImage(_ image: UIImage, fileName: String) throws -> String {
        let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
        }
        
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.imageEncodingFailed
        }
        try imageData.write(to: fileURL)
        return fileName
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

enum StorageError: LocalizedError {
    case fileNotFound
    case imageEncodingFailed
    case encodingError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .imageEncodingFailed:
            return "Failed to encode image"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}

