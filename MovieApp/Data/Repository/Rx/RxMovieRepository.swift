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
                    observer.onNext(items)
                    return Disposables.create()
                }
            }
    }
}
