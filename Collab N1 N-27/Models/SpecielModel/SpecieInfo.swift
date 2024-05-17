//
//  SpecieInfo.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

struct PlaceAutocompleteResult: Codable {
    let results: [Place]
}

struct Place: Codable {
    let id: Int
    let name: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case displayName = "display_name"
    }
}

struct Response: Decodable {
    let results: [TaxonResult]
}

struct TaxonResult: Decodable {
    let taxon: Taxon
}

struct Taxon: Decodable {
    let name: String?
    let defaultPhoto: DefaultPhoto?
    let wikipediaUrl: String?
    let iconicTaxonName: String?
    let preferredCommonName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case defaultPhoto = "default_photo"
        case wikipediaUrl = "wikipedia_url"
        case iconicTaxonName = "iconic_taxon_name"
        case preferredCommonName = "preferred_common_name"
    }
}

struct DefaultPhoto: Decodable {
    let squareUrl: String?
    let mediumUrl: String?

    enum CodingKeys: String, CodingKey {
        case squareUrl = "square_url"
        case mediumUrl = "medium_url"
    }
}
