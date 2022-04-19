//
//  SeriesDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol SeriesDetailModel {
    func getTVSeriesDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getTVTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void)
}

class SeriesDetailModelImpl: BaseModel, SeriesDetailModel {
    static let shared = SeriesDetailModelImpl()
    private override init(){}
    
    private let movieRepo: MovieRepository = MovieRepositoryRealmImpl.shared
    
    func getTVSeriesDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void){
        networkAgent.getTVSeriesDetailById(id){ result in
            switch(result) {
            case .success(let response):
                self.movieRepo.saveSeriesDetail(data: response)
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.movieRepo.getDetail(id){ item in
                if let item = item {
                    completion(.success(item))
                } else {
                    completion(.failure("Failed to get detail with id \(id)"))
                }
            }
        }
    }
    
    func getTVTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void) {
        networkAgent.getTVTrailerVideo(id, completion: completion)
    }
}
