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
    
    /// Series
    func getPopularSeriesList() -> Observable<MovieListResponse>
    
    /// Search
    func searchMovie(_ text: String, page: Int) -> Observable<MovieListResponse>
    
    /// Actor
    func getPopularActors(page: Int) -> Observable<ActorListResponse>
}
