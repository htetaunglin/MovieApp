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
    func getMoviesByGroupType(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getMoviesByGroupTypeByPage(page: Int, type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void)
}

class MovieRepositoryRealmImpl: BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryRealmImpl()
    
    let genreRepository = GenreRepositoryRealmImpl.shared
    
    private override init() {
        super.init()
    }
    
    func getDetail(_ id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        let movieObject = realDB.object(ofType: MovieObject.self, forPrimaryKey: id)
        completion(movieObject?.toMovieDetail())
    }
    
    func saveMovieDetail(data: MovieDetailResponse) {
        do{
            try realDB.write{
                realDB.add(data.toMovieObject(), update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveSeriesDetail(data: TVSeriesDetailResponse) {
        do{
            try realDB.write{
                realDB.add(data.toMovieObject(), update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveList(type: MovieSeriesGroupType, data: [MovieResult]?) {
        do{
            try realDB.write {
                // Build Movie Objects
                let movieObjs =  data?.map{ mov -> MovieObject in
                    if let movieObject = realDB.object(ofType: MovieObject.self, forPrimaryKey: mov.id){
                        return movieObject
                    } else {
                        let genres = mov.genreIDS?.map{ genreId -> GenreObject in
                            // Build Genre Object
                            var genreObj = realDB.object(ofType: GenreObject.self, forPrimaryKey: genreId)
                            if genreObj == nil {
                                genreObj = GenreObject()
                                genreObj?.id = 0
                                genreObj?.name = ""
                            }
                            return genreObj!
                        }
                        return mov.toMovieObject(genres: genres ?? [])
                    }
                }
                
                // Build Belong To Type Object
                if let belongToType = realDB.object(ofType: BelongToTypeObject.self, forPrimaryKey: type.rawValue){
                    belongToType.movies.append(objectsIn: movieObjs ?? [])
                    realDB.add(belongToType, update: .modified)
                } else {
                    let object = BelongToTypeObject()
                    object.name = type.rawValue
                    object.movies.append(objectsIn: movieObjs ?? [])
                    realDB.add(object, update: .modified)
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func saveSimilarContent(_ id: Int, data: [MovieResult]) {
        let movieObject = realDB.object(ofType: MovieObject.self, forPrimaryKey: id)
        do{
            try realDB.write{
                if let obj = movieObject {
                    let similarMovieObjects = data.map { movie -> MovieObject in
                        if let theMovie = realDB.object(ofType: MovieObject.self, forPrimaryKey: movie.id) {
                            return theMovie
                        } else {
                            let genres = movie.genreIDS?.map{ genreId -> GenreObject in
                                return realDB.object(ofType: GenreObject.self, forPrimaryKey: genreId)!
                            }
                            return movie.toMovieObject(genres: genres ?? [])
                        }
                    }
                    obj.similarMovies.append(objectsIn: similarMovieObjects)
                    realDB.add(obj, update: .modified)
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getSimilarContent(_ id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let movieObject = realDB.object(ofType: MovieObject.self, forPrimaryKey: id)
        completion(movieObject?.similarMovies.map{ $0.toMovieResult() } ?? [])
    }
    
    func saveCasts(_ id: Int, data: [MovieCast]) {
        do {
            try realDB.write{
                if let movie = realDB.object(ofType: MovieObject.self, forPrimaryKey: id){
                    movie.actors.append(objectsIn: data.map{ act -> ActorObject in
                        if let actorObj = realDB.object(ofType: ActorObject.self, forPrimaryKey: act.id){
                            return actorObj
                        } else {
                            return act.toActorObject()
                        }
                    })
                    realDB.add(movie, update: .modified)
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getCasts(_ id: Int, completion: @escaping ([ActorInfoResponse]) -> Void) {
        let movieObject = realDB.object(ofType: MovieObject.self, forPrimaryKey: id)
        completion(movieObject?.actors.map{ $0.toActorInfoResponse() } ?? [])
    }
    
    func getMoviesByGroupType(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let object = realDB.object(ofType: BelongToTypeObject.self, forPrimaryKey: type.rawValue)
        completion(object?.movies.map{ $0.toMovieResult() } ?? [])
    }
    
    func getMoviesByGroupTypeByPage(page: Int, type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let pageSize = 20
        let object = realDB.object(ofType: BelongToTypeObject.self, forPrimaryKey: type.rawValue)
        completion(object?.movies
            .suffix(from: (page * pageSize) - pageSize)
            .suffix(pageSize)
            .map{ $0.toMovieResult() } ?? [])
    }
    
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
                data.map{ $0.toMovieEntity(context: self.coreData.context, groupType: self.contentTypeRepository.getBelongToTypeEntity(type: .similarMovies))
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
    
    func getMoviesByGroupType(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        contentTypeRepository.getMoviesOrSeries(type: type, completion: completion)
    }
    
    func getMoviesByGroupTypeByPage(page: Int, type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
    }
}
