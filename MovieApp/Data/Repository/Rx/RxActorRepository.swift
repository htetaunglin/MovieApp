//
//  RxActorRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 04/06/2022.
//

import Foundation
import RxSwift
import RxRealm

protocol RxActorRepository {
    func getActorList(page: Int, type: ActorGroupType) -> Observable<[ActorInfoResponse]>
}


class RxActorRepositoryImpl: BaseRepository, RxActorRepository {
    static let shared : RxActorRepository = RxActorRepositoryImpl()
    private override init() {}
    
    private let pageSize: Int = 20
    
    func getActorList(page: Int, type: ActorGroupType) -> Observable<[ActorInfoResponse]> {
        let actorObjs = realDB.objects(ActorObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
            .suffix(from: (page * pageSize) - pageSize)
            .prefix(pageSize)
        return Observable.collection(from: actorObjs.base)
            .flatMap{ actors -> Observable<[ActorInfoResponse]> in
                return Observable.create{ (observer) -> Disposable in
                    let items = actors.map{ $0.toActorInfoResponse() }
                    observer.onNext(Array(items))
                    return Disposables.create()
                }
            }
    }
}
