//
//  SpecieViewModel.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

protocol SpecieViewModelDelegate: AnyObject {
    func didStartFetchingSpeciesData()
    func didFetchSpeciesData()
    func didFailToFetchSpeciesData(with error: Error)
}

final class SpecieViewModel {
    weak var delegate: SpecieViewModelDelegate?
    
    var places = [Place]()
    var speciesInfo = [TaxonResult]()
    
    var autocompleteURL: URL!
    var speciesCountsURL: URL!
    
    // MARK: - Data Fetching
    func fetchAutocompleteData(for city: String) {
        delegate?.didStartFetchingSpeciesData()
        
        NetworkingService.shared.fetchData(from: self.autocompleteURL) { [weak self] (result: Result<PlaceAutocompleteResult, Error>) in
            switch result {
            case .success(let autocompleteResult):
                let matchingPlaces = autocompleteResult.results.filter { $0.name.lowercased() == city.lowercased() || $0.displayName.lowercased() == city.lowercased() }
                if let firstPlace = matchingPlaces.first {
                    self?.fetchSpeciesCounts(for: [firstPlace])
                } else {
                    self?.delegate?.didFailToFetchSpeciesData(with: NSError(domain: "error", code: 0, userInfo: nil))
                }
            case .failure(let error):
                self?.delegate?.didFailToFetchSpeciesData(with: error)
            }
        }
    }
    
    private func fetchSpeciesCounts(for places: [Place]) {
        var remainingPlaces = places
        
        func fetchNext() {
            guard let place = remainingPlaces.first else {
                self.delegate?.didFailToFetchSpeciesData(with: NSError(domain: "error", code: 0, userInfo: nil))
                return
            }
            
            remainingPlaces.removeFirst()
            
            self.speciesCountsURL = URL(string: "https://api.inaturalist.org/v1/observations/species_counts?place_id=\(place.id)")!
            
            NetworkingService.shared.fetchData(from: self.speciesCountsURL) { [weak self] (result: Result<TaxonResponse, Error>) in
                switch result {
                case .success(let speciesCountsResult):
                    if !speciesCountsResult.results.isEmpty {
                        self?.speciesInfo = speciesCountsResult.results
                        self?.delegate?.didFetchSpeciesData()
                    } else {
                        fetchNext()
                    }
                case .failure:
                    fetchNext()
                }
            }
        }
        fetchNext()
    }
    
    // MARK: - Actions
    func searchButtonDidTap(for city: String) {
        guard let autocompleteURL = URL(string: "https://api.inaturalist.org/v1/places/autocomplete?q=\(city)") else {
            return
        }
        
        self.autocompleteURL = autocompleteURL
        self.fetchAutocompleteData(for: city)
    }
}
