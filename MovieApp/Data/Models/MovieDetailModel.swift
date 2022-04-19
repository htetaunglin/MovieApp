//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol MovieDetailModel {
    func getMovieTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void)
    func getMovieSimilar(_ id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieCreditByMovieId(_ id: Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void)
    func getMovieDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieDetailModelImpl: BaseModel, MovieDetailModel {
    
    static let shared = MovieDetailModelImpl()
    private override init(){}
    
    private let movieRepo: MovieRepository = MovieRepositoryRealmImpl.shared
    
    func getMovieTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void) {
        networkAgent.getMovieTrailerVideo(id, completion: completion)
    }
    
    func getMovieSimilar(_ id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getMovieSimilar(id){ result in
            switch result {
            case .success(let response):
                self.movieRepo.saveSimilarContent(id, data: response.results ?? [])
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.movieRepo.getSimilarContent(id){ movieList in
                completion(.success(movieList))
            }
        }
    }
    
    func getMovieCreditByMovieId(_ id: Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void) {
        networkAgent.getMovieCreditByMovieId(id){ result in
            switch result {
            case .success(let response):
                self.movieRepo.saveCasts(id, data: response.cast ?? [])
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.movieRepo.getCasts(id){ completion(.success($0)) }
        }
    }
    
    func getMovieDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getMovieDetailById(id){ result in
            switch result{
            case .success(let response):
                self.movieRepo.saveMovieDetail(data: response)
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
}
