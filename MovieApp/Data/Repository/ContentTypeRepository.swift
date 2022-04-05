//
//  ContentTypeRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name: String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getBelongToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity
}

class ContentTypeRepositoryImpl: BaseRepository, ContentTypeRepository {
   
    static let shared : ContentTypeRepository = ContentTypeRepositoryImpl()
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
   
    
    private override init() {
        super.init()
        initialzeData()
    }
    
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
    
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        if let entity = contentTypeMap[type.rawValue],
           let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity> {
            debugPrint("Item Set - \(type.rawValue) \(entity.movies?.count ?? 0)")
            completion(Array(itemSet.sorted(by: { first, second -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                return firstDate.compare(secondDate) == .orderedDescending
            })).map{ $0.toMovieResult() })
        } else {
            completion([MovieResult]())
        }
            
    }
    
    func getBelongToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity {
        if let entity =  contentTypeMap[type.rawValue] {
            return entity
        }
        return save(name: type.rawValue)
    }
}
