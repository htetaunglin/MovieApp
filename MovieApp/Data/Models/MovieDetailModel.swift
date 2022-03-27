//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol MovieDetailModel {
    func getMovieTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void)
    func getMovieSimilar(_ id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieCreditByMovieId(_ id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getMovieDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieDetailModelImpl: BaseModel, MovieDetailModel {
    
    static let shared = MovieDetailModelImpl()
    private override init(){}
    
    func getMovieTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void) {
        networkAgent.getMovieTrailerVideo(id, completion: completion)
    }
    
    func getMovieSimilar(_ id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getMovieSimilar(id, completion: completion)
    }
    
    func getMovieCreditByMovieId(_ id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        networkAgent.getMovieCreditByMovieId(id, completion: completion)
    }
    
    func getMovieDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getMovieDetailById(id, completion: completion)
    }
    

}
