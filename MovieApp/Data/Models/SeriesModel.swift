//
//  SeriesModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol SeriesModel {
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
}

class SeriesModelImpl: BaseModel, SeriesModel {
    static let shared = SeriesModelImpl()
    private override init(){}
    
    private let movieRepo: MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared

    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        let contentType : MovieSeriesGroupType = .popularSeries
        networkAgent.getPopularSeriesList{ result in
            switch result {
            case .success(let response):
                self.movieRepo.saveList(type: contentType, data: response.results)
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.contentTypeRepo.getMoviesOrSeries(type: contentType){
                completion(.success($0))
            }
        }
    }
}
