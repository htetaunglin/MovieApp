//
//  ProductionCountryEntityX.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation

extension ProductionCountryEntity {
    func toProductionCountry() -> ProductionCountry {
        return ProductionCountry(iso3166_1: self.iso3166_1, name: self.name)
    }
}
