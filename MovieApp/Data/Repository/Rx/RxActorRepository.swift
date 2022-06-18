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
    func getDetails(id: Int) -> Observable<ActorDetailResponse?>
    func saveDetails(data: ActorDetailResponse)
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
    
    func getDetails(id: Int) -> Observable<ActorDetailResponse?> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .do(onNext: { value in
                debugPrint("Local \(value.count)")
            })
            .map{ $0.first?.toActorDetailResponse() }
    }
    
    func saveDetails(data: ActorDetailResponse) {
//        CDObservable(fetchRequest: <#T##NSFetchRequest<NSManagedObject>#>, context: <#T##NSManagedObjectContext#>)
//        data.toActorEntity(context: coreData.context)?.rx.
//        coreData.context.rx.update(data.toActorEntity(context: coreData.context)?.entity.rx)
    }
}
