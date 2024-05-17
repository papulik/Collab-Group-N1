//
//  PopulationInfo.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

struct TotalPopulation: Decodable {
    var total_population: [Population]
}

struct Population: Decodable {
    var date: String
    var population: Int
}
