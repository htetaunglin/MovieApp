//
//  ActorRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData

protocol ActorRepository {
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void)
    func save(list: [ActorInfoResponse])
    func saveDetails(data: ActorDetailResponse)
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void)
    func getTotalPageActorList(completion: @escaping (Int) -> Void)
    func getMoviesByActor(_ id: Int, isSeries: Bool, completion: @escaping ([MovieResult]) -> Void)
    func saveMoviesByActor(_ id: Int, list: [MovieResult])
}

class ActorRepositoryRealmImpl: BaseRepository, ActorRepository {
    
    static let shared: ActorRepository = ActorRepositoryRealmImpl()
    private let pageSize: Int = 20
    
    private override init() {
        super.init()
    }
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        // Pagination
        let actorObjs = realDB.objects(ActorObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
            .suffix(from: (page * pageSize) - pageSize)
            .prefix(pageSize)
        completion(actorObjs.map{ $0.toActorInfoResponse() })
    }
    
    func save(list: [ActorInfoResponse]) {
        do {
            try realDB.write{
                realDB.add(list.map{ $0.toActorObject() }, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveDetails(data: ActorDetailResponse) {
        do {
            try realDB.write{
                realDB.add(data.toActorObject(), update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void) {
        let actor = realDB.object(ofType: ActorObject.self, forPrimaryKey: id)
        completion(actor?.toActorDetailResponse())
    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
        let actorObjs = realDB.objects(ActorObject.self)
        completion(actorObjs.count)
    }
    
    func getMoviesByActor(_ id: Int, isSeries: Bool, completion: @escaping ([MovieResult]) -> Void) {
        //
        if let actorObj = realDB.object(ofType: ActorObject.self, forPrimaryKey: id) {
            completion(actorObj.movies.filter{ $0.video == isSeries }.map{ $0.toMovieResult() })
        }
    }
    
    func saveMoviesByActor(_ id: Int, list: [MovieResult]) {
        let actorObj = realDB.object(ofType: ActorObject.self, forPrimaryKey: id)
        do {
            try realDB.write{
                let movieObj = list.map{ movie -> MovieObject in
                    if let movie = realDB.object(ofType: MovieObject.self, forPrimaryKey: movie.id) {
                        movie.actors.append(actorObj!)
                        return movie
                    } else {
                        var genres = [GenreObject]()
                        movie.genreIDS?.forEach{ genreId in
                            if let genreObj = realDB.object(ofType: GenreObject.self, forPrimaryKey: genreId){
                                genres.append(genreObj)
                            }
                        }
                        let movieObject = movie.toMovieObject(genres: genres)
                        movieObject.actors.append(actorObj!)
                        return movieObject
                    }
                }
                realDB.add(movieObj, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

class ActorRepositoryImpl: BaseRepository, ActorRepository {
    
    static let shared: ActorRepository = ActorRepositoryImpl()
    private let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    private let pageSize: Int = 20
    
    private override init() {
        super.init()
    }
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "insertedAt", ascending: false),
                NSSortDescriptor(key: "popularity", ascending: false),
                NSSortDescriptor(key: "name", ascending: true)
            ]
            fetchRequest.fetchLimit = self.pageSize
            fetchRequest.fetchOffset = (self.pageSize * page) - self.pageSize
            
            do {
                let items = try self.coreData.context.fetch(fetchRequest)
                completion(items.map{ $0.toActorInfoResponse() })
            } catch {
                completion([ActorInfoResponse]())
            }
        }
    }
    
    
    func save(list: [ActorInfoResponse]) {
        coreData.context.perform {
            list.forEach{
                let _ = $0.toActorEntity(context: self.coreData.context, belongToType: self.getBelongToType(type: .actorMovieCredits))
            }
            self.coreData.saveContext()
        }
    }
    
    func saveDetails(data: ActorDetailResponse) {
        var _ = data.toActorEntity(context: coreData.context)
        coreData.saveContext()
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        if let items = try? self.coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            completion(firstItem.toActorDetailResponse())
        } else {
            completion(nil)
        }
    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
            do{
                let items = try self.coreData.context.fetch(fetchRequest)
                completion(items.count / self.pageSize)
            } catch {
                debugPrint("\(#function) \(error)")
            }
        }
    }
    
    
    func getMoviesByActor(_ id: Int, isSeries: Bool, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        do{
            let items = try self.coreData.context.fetch(fetchRequest)
            if let firstItem = items.first {
                let movieEntities = firstItem.credits?.allObjects as? [MovieEntity] ?? [MovieEntity]()
                completion(movieEntities.map{ $0.toMovieResult() }.filter{ $0.video == isSeries })
            }
        } catch {
            debugPrint("\(#function) \(error)")
        }
    }
    
    func saveMoviesByActor(_ id: Int, list: [MovieResult]) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        do {
            let items = try self.coreData.context.fetch(fetchRequest)
            if let firstItem = items.first {
                list.forEach{
                    firstItem.addToCredits($0.toMovieEntity(context: coreData.context, groupType: self.getBelongToType(type: .actorMovieCredits)))
                }
            }
        } catch {
            debugPrint("\(#function) \(error)")
        }
        coreData.saveContext()
    }
    
    private func getBelongToType(type: MovieSeriesGroupType) -> BelongsToTypeEntity{
        return self.contentTypeRepo.getBelongToTypeEntity(type: .actorMovieCredits)
    }
}

