//
//  RxMovieRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/06/2022.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

protocol RxMovieRepository {
    func getMoviesByGroupType(type: MovieSeriesGroupType) -> Observable<[MovieResult]>
    func getDetail(_ id: Int) -> Observable<MovieDetailResponse>
    func getCasts(_ id: Int) -> Observable<[ActorInfoResponse]>
}

class RxMovieRepositoryRealmImpl: BaseRepository, RxMovieRepository {
    static let shared : RxMovieRepository = RxMovieRepositoryRealmImpl()
    private override init() {}

    let genreRepository = GenreRepositoryRealmImpl.shared

    func getMoviesByGroupType(type: MovieSeriesGroupType) -> Observable<[MovieResult]> {
        if let object = self.realDB.object(ofType: BelongToTypeObject.self, forPrimaryKey: type.rawValue){
            return Observable.collection(from: object.movies)
                .flatMap{ movies -> Observable<[MovieResult]> in
                    return Observable.create{ (observer) -> Disposable in
                        let items = movies.map{ $0.toMovieResult() }
                        observer.onNext(Array(items))
                        return Disposables.create()
                    }
                }
        }
        return Observable.empty()
    }

    func getDetail(_ id: Int) -> Observable<MovieDetailResponse> {
        return Observable.empty()
    }
    
    func getCasts(_ id: Int) -> Observable<[ActorInfoResponse]> {
        return Observable.empty()
    }
    

}

class RxMovieRepositoryImpl: BaseRepository, RxMovieRepository {
    static let shared : RxMovieRepository = RxMovieRepositoryImpl()
    private override init() {}
    
    let contentTypeRepo = RxContentTypeRepositoryImpl.shared
    
    func getMoviesByGroupType(type: MovieSeriesGroupType) -> Observable<[MovieResult]> {
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "name", "\(type.rawValue)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .flatMap{ belongToTypeEntity -> Observable<[MovieResult]> in
                let movies = belongToTypeEntity.first?.movies as? Set<MovieEntity>
                return Observable.create{ (observer) -> Disposable in
                    let items = movies?.map{ $0.toMovieResult() } ?? []
                    observer.onNext( items.sorted { m1, m2 -> Bool in
                        (m1.popularity ?? 0) < (m2.popularity ?? 0)
                    })
                    return Disposables.create()
                }
            }
    }
    
    func getDetail(_ id: Int) -> Observable<MovieDetailResponse> {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: true)]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .flatMap{ movies -> Observable<MovieDetailResponse> in
                return Observable.create{ (observer) -> Disposable in
//                    debugPrint("Not Found in-> \(movies)")
                    if let firstItem = movies.first {
                        observer.onNext(firstItem.toMovieDetailResponse())
                    } else {
//                        observer.onError(MovieNotFound())
                    }
                    return Disposables.create()
                }
            }
    }
    
    func getCasts(_ id: Int) -> Observable<[ActorInfoResponse]> {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: true)]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .flatMap{ movies -> Observable<[ActorInfoResponse]> in
                return Observable.create{ (observer) -> Disposable in
//                    debugPrint("Not Found in-> \(movies)")
                    if let firstItem = movies.first {
                        let actorEntities = firstItem.casts?.allObjects as? [ActorEntity] ?? [ActorEntity]()
                        observer.onNext(actorEntities.map{ $0.toActorInfoResponse() })
                    } else {
//                        observer.onError(MovieNotFound())
                    }
                    return Disposables.create()
                }
            }
    }
}


class MovieNotFound: Error {
}
