//
//  SolarInfo.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

// MARK: - SolarData

struct SolarData: Decodable {
    let avgDNI: SolarMetric
    let avgGHI: SolarMetric
    let avgLatTilt: SolarMetric
    
    enum CodingKeys: String, CodingKey {
        case avgDNI = "avg_dni"
        case avgGHI = "avg_ghi"
        case avgLatTilt = "avg_lat_tilt"
    }
}

// MARK: - SolarMetric

struct SolarMetric: Decodable {
    let annual: Double
    let monthly: [String: Double]
}

// MARK: - SolarDataResponse

struct SolarDataResponse: Decodable {
    let outputs: SolarData
}
