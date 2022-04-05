//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData

protocol MovieRepository {
    func getDetail(_ id: Int, completion: @escaping (MovieDetailResponse?) -> Void)
    func saveMovieDetail(data: MovieDetailResponse)
    func saveSeriesDetail(data: TVSeriesDetailResponse)
    func saveList(type: MovieSeriesGroupType, data: [MovieResult]?)
    func saveSimilarContent(_ id: Int, data: [MovieResult])
    func getSimilarContent(_ id: Int, completion: @escaping ([MovieResult]) -> Void)
    func saveCasts(_ id: Int, data: [MovieCast])
    func getCasts(_ id: Int, completion: @escaping ([ActorInfoResponse]) -> Void)
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryImpl()
    
    private var contentTypeRepository: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    private override init() {
        super.init()
    }
    
    
    func getDetail(_ id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        coreData.context.perform {
            let fetchRequest : NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
            if let items = try? self.coreData.context.fetch(fetchRequest),
               let firstItem = items.first {
                completion(firstItem.toMovieDetailResponse())
            } else {
                completion(nil)
            }
        }
    }
    
    private func getMovieFetchRequestById(_ id: Int) -> NSFetchRequest<MovieEntity>{
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    
    func saveMovieDetail(data: MovieDetailResponse) {
        coreData.context.perform {
            let _ = data.toMovieEntity(context: self.coreData.context)
            self.coreData.saveContext()
        }
    }
    
    func saveSeriesDetail(data: TVSeriesDetailResponse) {
        coreData.context.perform {
            let _ = data.toMovieEntity(context: self.coreData.context)
            self.coreData.saveContext()
        }
    }
    
    func saveList(type: MovieSeriesGroupType, data: [MovieResult]?) {
        // Background Queue
//        coreData.context.perform {
            // Main Queue
            data?.forEach{
                $0.toMovieEntity(context: self.coreData.context, groupType: self.contentTypeRepository.getBelongToTypeEntity(type: type))
            }
            debugPrint("Movie Save List \(type.rawValue) \(data?.count ?? 0)")
            self.coreData.saveContext()
//        }
    }
    
    
    func saveSimilarContent(_ id: Int, data: [MovieResult]) {
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
            if let items = try? self.coreData.context.fetch(fetchRequest),
               let firstItem = items.first {
                data.map{ $0.toMovieEntity(context: self.coreData.context, groupType: self.contentTypeRepository.getBelongToTypeEntity(type: .actorMovieCredits))
                }.forEach{
                    firstItem.addToSimilarMovies($0)
                }
                self.coreData.saveContext()
            }
        }
        
    }
    
    func getSimilarContent(_ id: Int, completion: @escaping ([MovieResult]) -> Void) {
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
            if let items = try? self.coreData.context.fetch(fetchRequest),
               let firstItem = items.first {
                completion((firstItem.similarMovies as? Set<MovieEntity>)?.map{ $0.toMovieResult() } ?? [MovieResult]())
            }
        }
    }
    
    func saveCasts(_ id: Int, data: [MovieCast]) {
        coreData.context.perform {
            let type = self.contentTypeRepository.getBelongToTypeEntity(type: .actorMovieCredits)
            let fetchRequest: NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
            if let items = try? self.coreData.context.fetch(fetchRequest),
               let firstItem = items.first {
                // [MovieCast] -> [ActorInfoResponse] -> [ActorEntity]
                data
                    .map{ $0.toActorInfoResponse().toActorEntity(context: self.coreData.context, belongToType: type) } //
                    .forEach{ firstItem.addToCasts($0) }
            }
            self.coreData.saveContext()
        }
    }
    
    func getCasts(_ id: Int, completion: @escaping ([ActorInfoResponse]) -> Void) {
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
            if let items = try? self.coreData.context.fetch(fetchRequest),
               let firstItem = items.first {
                let actorEntities = firstItem.casts?.allObjects as? [ActorEntity] ?? [ActorEntity]()
                // [ActorEntity] -> [ActorInfoResponse]
                completion(actorEntities.map{ $0.toActorInfoResponse() })
            }
        }
    }
}
