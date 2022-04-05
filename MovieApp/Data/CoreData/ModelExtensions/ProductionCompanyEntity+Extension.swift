//
//  ProductionCompanyEntityX.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation

extension ProductionCompanyEntity {
    func toProductionCompany() -> ProductionCompany {
        return ProductionCompany(id: Int(self.id), logoPath: self.logoPath, name: self.name, originCountry: self.originalCountry)
    }
}
