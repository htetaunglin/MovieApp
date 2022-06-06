//
//  RxContentTypeRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 05/06/2022.
//

import Foundation
import RxSwift
import CoreData

protocol RxContentTypeRepository{
    func save(name: String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type: MovieSeriesGroupType) -> Observable<[MovieResult]>
    func getBelongToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity
}

class RxContentTypeRepositoryImpl: BaseRepository, RxContentTypeRepository {
    
    static let shared : RxContentTypeRepository = RxContentTypeRepositoryImpl()
    private override init() {
        super.init()
        initialzeData()
    }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    
    private func initialzeData(){
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        do {
            let dataSource = try coreData.context.fetch(fetchRequest)
            if dataSource.isEmpty {
                MovieSeriesGroupType.allCases.forEach{
                    save(name: $0.rawValue)
                }
            } else {
                dataSource.forEach{
                    if let key = $0.name {
                        contentTypeMap[key] = $0
                    }
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    
    @discardableResult
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        contentTypeMap[name] = entity
        coreData.saveContext()
        return entity
    }
    
    func getMoviesOrSeries(type: MovieSeriesGroupType) -> Observable<[MovieResult]> {
        return Observable.empty()
    }
    
    func getBelongToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity {
        if let entity =  contentTypeMap[type.rawValue] {
            return entity
        }
        return save(name: type.rawValue)
    }
}
