//
//  SolarViewModel.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

final class SolarDataViewModel {
    
    // MARK: - Properties
    var solarData: SolarData?
    
    // MARK: - Methods
    func fetchSolarData(address: String, completion: @escaping (Result<SolarData, Error>) -> Void) {
        let apiKey = "NHnRDWjH0QLAR7v66UHhZOq249oz5pbeu8dABdqR"
        let urlString = "https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=\(apiKey)&address=\(address)"
        print("URL String: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        NetworkingService.shared.fetchData(from: url) { (result: Result<SolarDataResponse, Error>) in
            switch result {
            case .success(let data):
                self.solarData = data.outputs
                completion(.success(data.outputs))
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func getSolarData() -> SolarData? {
        return solarData
    }
}
