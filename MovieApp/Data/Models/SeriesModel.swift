//
//  SeriesModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol SeriesModel {
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
}

class SeriesModelImpl: BaseModel, SeriesModel {
    static let shared = SeriesModelImpl()
    private override init(){}

    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularSeriesList(completion: completion)
    }
}
