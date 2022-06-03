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
    
    /// Search
    func searchMovie(_ text: String, page: Int) -> Observable<MovieListResponse>
}
