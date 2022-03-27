//
//  MovieModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol MovieModel {
    func getTopRelatedMoveiList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
}

class MovieModelImpl: BaseModel, MovieModel {
    static let shared = MovieModelImpl()
    private override init(){}

    func getTopRelatedMoveiList(page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        networkAgent.getTopRelatedMoveiList(page: page, completion: completion)
    }

    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        networkAgent.getPopularMovieList(completion: completion)
    }

    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        networkAgent.getUpcomingMovieList(completion: completion)
    }
}
