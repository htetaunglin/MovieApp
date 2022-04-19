//
//  ProductionCountryObject.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 08/04/2022.
//

import Foundation
import RealmSwift

class ProductionCountryObject: Object {
    @Persisted
    var iso3166_1: String?
    @Persisted(primaryKey: true)
    var name: String
    @Persisted(originProperty: "productionCountries")
    var movies: LinkingObjects<MovieObject>
    
    func toProductionCountry() -> ProductionCountry {
        return ProductionCountry(iso3166_1: iso3166_1, name: name)
    }
}
