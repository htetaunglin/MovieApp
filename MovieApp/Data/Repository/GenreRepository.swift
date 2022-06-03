//
//  GenreRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData

protocol GenreRepository {
    func get(completion: @escaping ([MovieGenre]) -> Void)
    func save(data: MovieGenreList)
    func getById(id: Int) -> MovieGenre?
}

class GenreRepositoryRealmImpl: BaseRepository, GenreRepository {
    
    static let shared : GenreRepository = GenreRepositoryRealmImpl()
    
    private override init() {}
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        let genres: [MovieGenre] = realDB.objects(GenreObject.self)
            .sorted(byKeyPath: "name", ascending: true)
            .map{ $0.toMovieGenre() }
        completion(genres)
    }
    
    func save(data: MovieGenreList) {
        do{
            try realDB.write{
                data.genres.forEach{
                    let genre = realDB.object(ofType: GenreObject.self, forPrimaryKey: $0.id)
                    if genre != nil {
                        realDB.add(genre!, update: .modified)
                    } else {
                        realDB.add($0.toGenreObject(), update: .modified)
                    }
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getById(id: Int) -> MovieGenre? {
        let object = realDB.object(ofType: GenreObject.self, forPrimaryKey: id)
        return object?.toMovieGenre()
    }
}

class GenreRepositoryImpl: BaseRepository, GenreRepository {
    static let shared : GenreRepository = GenreRepositoryImpl()
    
    private override init() {}
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
            do {
                let results : [GenreEntity] = try self.coreData.context.fetch(fetchRequest)
                let items = results.map{ $0.toMovieGenre() }
                completion(items)
            } catch {
                completion([MovieGenre]())
                debugPrint("\(#function) \(error.localizedDescription)")
            }
        }
        
    }
    
    func save(data: MovieGenreList) {
        coreData.context.perform {
            let _ = data.genres.map{
                let entity = GenreEntity(context: self.coreData.context)
                entity.id = Int32($0.id)
                entity.name = $0.name
            }
            self.coreData.saveContext()
        }
    }
    
    func getById(id: Int) -> MovieGenre? {
//        let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        //TODO with coreData
        return MovieGenre(id: 0, name: "")
//        do {
//            let results : [GenreEntity] = try self.coreData.context.fetch(fetchRequest)
//            let items = results.map{ $0.toMovieGenre() }
//            completion(items)
//        } catch {
//            completion([MovieGenre]())
//            debugPrint("\(#function) \(error.localizedDescription)")
//        }
    }
}
