//
//  PopulationViewModel.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

class PopulationViewModel {
    var totalPopulation: TotalPopulation?
    
    func fetchPopulation(country: String, completion: @escaping (Result<[Population], Error>) -> Void) {
        let urlString = "https://d6wn6bmjj722w.population.io/1.0/population/\(country)/today-and-tomorrow/?format=json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 2, userInfo: nil)))
            return
        }
        
        NetworkingService.shared.fetchData(from: url) { (result: Result<TotalPopulation, Error>) in
            switch result {
            case .success(let totalPopulation):
                completion(.success(totalPopulation.total_population))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
