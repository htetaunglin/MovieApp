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
}
