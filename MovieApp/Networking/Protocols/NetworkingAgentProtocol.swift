//
//  NetworkingAgentProtocol.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 26/03/2022.
//

import Foundation

protocol NetworkingAgentProtocol {
    /// Movie Details
    func getMovieTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void)
    func getMovieSimilar(_ id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieCreditByMovieId(_ id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getMovieDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    
    /// Movies
    func getTopRelatedMoveiList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    
    /// Series
    func getTVTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void)
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getTVSeriesDetailById(_ id: Int, completion: @escaping (MDBResult<TVSeriesDetailResponse>) -> Void)
    
    /// Search
    func searchMovie(_ text: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    
    /// Actor
    func getActorDetail(_ id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getActorMovieCredit(_ id: Int, completion: @escaping (MDBResult<ActorMovieCreditResponse>) -> Void)
    func getActorTVCredit(_ id: Int, completion: @escaping (MDBResult<CastTVCreditResponse>) -> Void)
}
