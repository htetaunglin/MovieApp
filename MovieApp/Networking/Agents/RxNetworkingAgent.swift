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

class RxNetworkingAgent : BaseNetworkingAgent {
    static let shared = RxNetworkingAgent()
    
    private override init(){
        
    }
    
    func getPopularMovieList() -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MDBEndpoint.popularMovieList)
            .flatMap{
                item -> Observable in Observable.just(item.1)
            }
//        return Observable.create{ (observer) -> Disposable in
//            AF.request(MDBEndpoint.popularMovieList)
//                .responseDecodable(of: MovieListResponse.self) {response in
//                    switch response.result {
//                    case .success(let data):
//                        observer.onNext(data)
//                        observer.onCompleted()
//                    case .failure(let error):
//                        observer.onError(error)
//                    }
//                }
//            return Disposables.create()
//        }
    }
}
