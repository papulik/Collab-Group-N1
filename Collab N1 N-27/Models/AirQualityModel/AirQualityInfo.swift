//
//  AirQualityInfo.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

struct AirQualityInfo: Decodable {
    let status: String
    let data: DataClass
    
    struct DataClass: Decodable {
        let city: String
        let state: String
        let country: String
        let location: Location
        let current: Current
        
        struct Location: Decodable {
            let type: String
            let coordinates: [Double]
        }
        
        struct Current: Decodable {
            let pollution: Pollution
            let weather: Weather
            
            struct Pollution: Decodable {
                let ts: String
                let aqius: Int
                let mainus: String
                let aqicn: Int
                let maincn: String
            }
            
            struct Weather: Decodable {
                let ts: String
                let tp: Int
                let pr: Int
                let hu: Int
                let ws: Double
                let wd: Int
                let ic: String
            }
        }
    }
}
