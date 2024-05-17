//
//  AirQualityViewModel.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

class AirQualityViewModel {
    
    var airQualityInfo: AirQualityInfo?
    
    func fetchAirQuality(lat: Double, lon: Double, completion: @escaping (Result<AirQualityInfo, Error>) -> Void) {
        let apiKey = "956a74f9-d6e9-4a37-953e-5b41fb2c6b29"
        let urlString = "https://api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(lon)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 2, userInfo: nil)))
            return
        }
        
        NetworkingService.shared.fetchData(from: url, completion: completion)
    }
}
