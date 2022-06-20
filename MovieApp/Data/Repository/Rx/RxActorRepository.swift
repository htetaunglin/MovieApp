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
    func getPopularActors(page: Int) -> Observable<[ActorInfoResponse]>
    func getPopularActorsWithoutPagination() -> Observable<[ActorInfoResponse]>
    func getDetails(id: Int) -> Observable<ActorDetailResponse?>
    func getMovieCredit(id: Int, isTVSeries: Bool) -> Observable<[MovieResult]>
}

class RxActorRepositoryImpl: BaseRepository, RxActorRepository {
    
    static let shared : RxActorRepository = RxActorRepositoryImpl()
    private override init() {}
    
    func getPopularActors(page: Int) -> Observable<[ActorInfoResponse]> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        fetchRequest.fetchOffset = page
        fetchRequest.fetchLimit = (20 * page) - 20
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map{ $0.map{ $0.toActorInfoResponse()}}
    }
    
    
    func getPopularActorsWithoutPagination() -> Observable<[ActorInfoResponse]> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map{ $0.map{ $0.toActorInfoResponse()}}
    }
    
    
    
    func getDetails(id: Int) -> Observable<ActorDetailResponse?> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .do(onNext: { value in
                debugPrint("Rx Local - \(value.count)")
            })
            .map{ $0.first?.toActorDetailResponse() }
    }
    
    func getMovieCredit(id: Int, isTVSeries: Bool) -> Observable<[MovieResult]> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .do(onNext: { value in
                debugPrint("Rx Local - \(value.count)")
            })
            .map{ items in
                if let firstItem = items.first {
                    let movieEntities = firstItem.credits?.allObjects as? [MovieEntity] ?? [MovieEntity]()
                    return movieEntities.map{ $0.toMovieResult() }.filter{ $0.video == isTVSeries }
                } else {
                    return [MovieResult]()
                }
            }
    }
}
