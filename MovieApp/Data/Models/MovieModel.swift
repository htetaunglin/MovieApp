//
//  MovieModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol MovieModel {
    // Showcase
    func getTopRelatedMoveiList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
}

class MovieModelImpl: BaseModel, MovieModel {
    static let shared = MovieModelImpl()
    private override init(){}
    
    private let movieRepo: MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared

    /// Showcase
    func getTopRelatedMoveiList(page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        let contentType : MovieSeriesGroupType = .topRatedMovies
        networkAgent.getTopRelatedMoveiList(page: page){ result in
            var movieListResponse: MovieListResponse?
            switch result {
            case .success(let response):
                self.movieRepo.saveList(type: contentType, data: response.results)
                movieListResponse = response
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.contentTypeRepo.getMoviesOrSeries(type: contentType){ res in
                // TODO Paging with CoreData (example: ActorModel)
                if let response = movieListResponse {
                    // Change [MovieResult] to MovieListResponse
                    let newMovieListResponse = MovieListResponse(dates: response.dates , page: page, results: res, totalPages: response.totalPages, totalResults: response.totalResults)
                    completion(.success(newMovieListResponse))
                } else {
                    let newMovieListResponse = MovieListResponse(dates: nil, page: page - 1, results: res, totalPages: nil, totalResults: nil)
                    completion(.success(newMovieListResponse))
                }
            }
        }
    }

    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void){
        let contentType : MovieSeriesGroupType = .popularMovies
        networkAgent.getPopularMovieList{ result in
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

    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void){
        let contentType : MovieSeriesGroupType = .upcomingMovies
        networkAgent.getUpcomingMovieList{ result in
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
