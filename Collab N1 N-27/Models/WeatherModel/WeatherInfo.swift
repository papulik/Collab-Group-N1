//
//  WeatherInfo.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

struct WeatherInfo: Decodable {
    let list: [WeatherForecast]
    let city: CityInfo
    
    struct WeatherForecast: Decodable {
        let dt: Int
        let main: MainInfo
        let weather: [Weather]
        let wind: Wind
        
        struct MainInfo: Decodable {
            let temp: Double
            let tempMin: Double
            let tempMax: Double
            
            enum CodingKeys: String, CodingKey {
                case temp, tempMin = "temp_min", tempMax = "temp_max"
            }
        }
        
        struct Weather: Decodable {
            let description: String
            let icon: String
        }
        
        struct Wind: Decodable {
            let speed: Double
        }
    }
    
    struct CityInfo: Decodable {
        let name: String
    }
}



