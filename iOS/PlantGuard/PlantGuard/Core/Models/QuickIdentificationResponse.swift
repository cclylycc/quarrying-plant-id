//
//  QuickIdentificationResponse.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct QuickIdentificationResponse: Codable {
    let status: Int
    let message: String
    let inferenceTime: Double?
    let chineseName: String?
    let latinName: String?
    let probability: Double?
    let invasiveInfo: InvasiveInfo?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case inferenceTime = "inference_time"
        case chineseName = "chinese_name"
        case latinName = "latin_name"
        case probability
        case invasiveInfo = "invasive_info"
    }
}

