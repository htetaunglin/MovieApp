//
//  ProductionCompany.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 08/04/2022.
//

import Foundation
import RealmSwift

class ProductionCompanyObject: Object {
    @Persisted(primaryKey: true)
    var id: Int
    @Persisted
    var logoPath: String?
    @Persisted
    var name: String
    @Persisted
    var originalCountry: String?
    @Persisted(originProperty: "productionCompanies")
    var movies: LinkingObjects<MovieObject>
    
    
    func toProductionCompany() -> ProductionCompany {
        return ProductionCompany(id: id, logoPath: logoPath, name: name, originCountry: originalCountry)
    }
}
