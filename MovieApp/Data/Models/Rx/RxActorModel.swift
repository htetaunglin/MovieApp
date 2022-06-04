//
//  RxActorModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 04/06/2022.
//

import Foundation
import RxSwift

protocol RxActorModel {
    func getPopularActor(page: Int) -> Observable<ActorListResponse>
}


class RxActorModelImpl: BaseModel, RxActorModel {
    static let shared = RxActorModelImpl()
    private override init() {}
    
    var totalPageActorList: Int = 1
    let disposeBag = DisposeBag()
    
    private let actorRepo: ActorRepository = ActorRepositoryRealmImpl.shared
    private let rxActorRepo: RxActorRepository = RxActorRepositoryImpl.shared
    
    func getPopularActor(page: Int) -> Observable<ActorListResponse> {
        let observableRemoteActorList = rxNetworkAgent.getPopularActors(page: page)
        observableRemoteActorList.subscribe (onNext: { response in
            self.actorRepo.save(list: response.results ?? [])
        }).disposed(by: disposeBag)
        
        let observableLocalActorList = rxActorRepo.getActorList(page: page, type: .popularActor)
            .flatMap{ actors -> Observable<ActorListResponse> in
                let response = ActorListResponse(dates: nil, page: page, results: actors, totalPages: self.totalPageActorList, totalResults: 0)
                return .just(response)
            }
        return observableLocalActorList
    }
}
