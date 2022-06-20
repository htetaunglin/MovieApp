//
//  RxActorModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 04/06/2022.
//

import Foundation
import RxSwift

protocol RxActorModel {
    func subscribeAllPopularActor() -> Observable<[ActorInfoResponse]>
    func getHomePopularActor(page: Int) -> Observable<[ActorInfoResponse]>
    func getPopularActor(page: Int)
}


class RxActorModelImpl: BaseModel, RxActorModel {
    static let shared = RxActorModelImpl()
    private override init() {}
    
    var totalPageActorList: Int = 1
    let disposeBag = DisposeBag()
    
    private let actorRepo: ActorRepository = ActorRepositoryImpl.shared
    private let rxActorRepo: RxActorRepository = RxActorRepositoryImpl.shared
    
    func subscribeAllPopularActor() -> Observable<[ActorInfoResponse]> {
        let observableLocalActorList = rxActorRepo.getPopularActorsWithoutPagination()
        return observableLocalActorList
    }
    
    func getHomePopularActor(page: Int) -> Observable<[ActorInfoResponse]> {
        let observableRemoteActorList = rxNetworkAgent.getPopularActors(page: page)
        observableRemoteActorList.subscribe (onNext: { response in
            self.actorRepo.save(list: response.results ?? [])
        }).disposed(by: disposeBag)
        let observableLocalActorList = rxActorRepo.getPopularActors(page: page)
        return observableLocalActorList
    }
    
    func getPopularActor(page: Int) {
        let observableRemoteActorList = rxNetworkAgent.getPopularActors(page: page)
        observableRemoteActorList.subscribe (onNext: { response in
            self.actorRepo.save(list: response.results ?? [])
        }).disposed(by: disposeBag)
    }
}
