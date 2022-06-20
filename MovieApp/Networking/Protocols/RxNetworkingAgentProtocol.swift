//
//  BaseNetworkingAgent.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 31/05/2022.
//

import Foundation
import RxSwift

protocol RxNetworkingAgentProtocol {
    /// Movies
    func getPopularMovieList() -> Observable<MovieListResponse>
    func getUpcomingMovieList() -> Observable<MovieListResponse>
    func getTopRelatedMovieList(page: Int) -> Observable<MovieListResponse>
    func getMovieSimilar(_ id: Int) -> Observable<MovieListResponse>
    func getMovieDetailById(_ id: Int) -> Observable<MovieDetailResponse>
    func getMovieCreditByMovieId(_ id: Int) -> Observable<MovieCreditResponse>
    func getMovieTrailerVideo(_ id: Int) -> Observable<TrailerResponse>
    
    /// Series
    func getPopularSeriesList() -> Observable<MovieListResponse>
    func getTVSeriesDetailById(_ id: Int) -> Observable<TVSeriesDetailResponse>
    func getTVTrailerVideo(_ id: Int) -> Observable<TrailerResponse>
    
    /// Search
    func searchMovie(_ text: String, page: Int) -> Observable<MovieListResponse>
    
    /// Actor
    func getPopularActors(page: Int) -> Observable<ActorListResponse>
    func getActorDetail(_ id: Int) -> Observable<ActorDetailResponse>
    func getActorMovieCredit(_ id: Int) -> Observable<ActorMovieCreditResponse>
    func getActorTVCredit(_ id: Int) -> Observable<CastTVCreditResponse>
    
    /// Genre
    func getGenreList() -> Observable<MovieGenreList>
}
