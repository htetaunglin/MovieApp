//
//  RxNetworkingAgent.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 31/05/2022.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

enum MDBError: Error {
    case withMessage(String)
}

class RxNetworkingAgent : RxNetworkingAgentProtocol {
    static let shared = RxNetworkingAgent()
    private init(){}
    
    func getPopularMovieList() -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.popularMovieList)
            .flatMap{ Observable.just($0.1) }
    }
    
    func getUpcomingMovieList() -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.upcomingMovieList)
            .flatMap{ Observable.just($0.1) }
    }
    
    func searchMovie(_ text: String, page: Int) -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.searchMovie(page, text))
            .flatMap{ Observable.just($0.1) }
    }
    
    func getPopularActors(page: Int) -> Observable<ActorListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.popularPeople(page))
            .flatMap{ Observable.just($0.1) }
    }
    
    func getPopularSeriesList() -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.popularSeriesList)
            .flatMap{ Observable.just($0.1) }
    }
    
    func getTopRelatedMovieList(page: Int) -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.topRelatedMovieList(page))
            .flatMap{ Observable.just($0.1) }
    }
}
