//
//  SpecieViewModel.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

protocol SpecieViewModelDelegate: AnyObject {
    func didFetchSpeciesData()
}

final class SpecieViewModel {
    
    weak var delegate: SpecieViewModelDelegate?
    
    var places = [Place]()
    var speciesInfo = [TaxonResult]()
    
    var autocompleteURL: URL!
    var speciesCountsURL: URL!
    
    // MARK: - Data Fetching
    func fetchAutocompleteData() {
        NetworkingService.shared.fetchData(from: self.autocompleteURL) { [weak self] (result: Result<PlaceAutocompleteResult, Error>) in
            switch result {
            case .success(let autocompleteResult):
                if let place = autocompleteResult.results.first {
                    let cityID = place.id
                    self?.speciesCountsURL = URL(string: "https://api.inaturalist.org/v1/observations/species_counts?place_id=\(cityID)")!
                    self?.fetchSpeciesCountsData()
                }
            case .failure(let error):
                print("შეცდომა ქალაქის ავტომატური დასრულებისას: \(error)")
            }
        }
    }
    
    func fetchSpeciesCountsData() {
        NetworkingService.shared.fetchData(from: self.speciesCountsURL) { [weak self] (result: Result<Response, Error>) in
            switch result {
            case .success(let speciesCountsResult):
                self?.speciesInfo = speciesCountsResult.results
                self?.delegate?.didFetchSpeciesData()
            case .failure(let error):
                print("შეცდომა სახეობების რაოდენობის მიღებისას: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    func searchButtonDidTap(for city: String) {
        guard let autocompleteURL = URL(string: "https://api.inaturalist.org/v1/places/autocomplete?q=\(city)") else {
            return
        }
        self.autocompleteURL = autocompleteURL
        self.fetchAutocompleteData()
    }
}
