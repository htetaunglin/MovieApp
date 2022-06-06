//
//  RxActorRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 04/06/2022.
//

import Foundation
import RxSwift
import RxRealm
import RxCoreData
import CoreData

protocol RxActorRepository {
    func getPopularActors() -> Observable<[ActorInfoResponse]>
}


class RxActorRepositoryRealmImpl: BaseRepository, RxActorRepository {
    static let shared : RxActorRepository = RxActorRepositoryRealmImpl()
    private override init() {}
    
    func getPopularActors() -> Observable<[ActorInfoResponse]> {
        let actorObjs = realDB.objects(ActorObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
        return Observable.collection(from: actorObjs)
            .map{ $0.map{ $0.toActorInfoResponse()}}
    }
}

class RxActorRepositoryImpl: BaseRepository, RxActorRepository {
    static let shared : RxActorRepository = RxActorRepositoryImpl()
    private override init() {}
    
    func getPopularActors() -> Observable<[ActorInfoResponse]> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map{ $0.map{ $0.toActorInfoResponse()}}
    }
}
