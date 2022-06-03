//
//  RxSearchModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 03/06/2022.
//

import Foundation
import RxSwift

protocol RxSearchModel {
    func searchMovie(_ text: String, page: Int) -> Observable<MovieListResponse>
}

class RxSearchModelImpl: BaseModel, RxSearchModel {
    static let shared = RxSearchModelImpl()
    private override init(){}
    
    let disposeBag = DisposeBag()
    
    func searchMovie(_ text: String, page: Int) -> Observable<MovieListResponse> {
        return rxNetworkAgent.searchMovie(text, page: page)
    }
}
