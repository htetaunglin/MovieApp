//
//  RxGenreRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 20/06/2022.
//

import Foundation
import RxSwift
import CoreData
import RxCoreData

protocol RxGenreRepository {
    func getAll() -> Observable<[MovieGenre]>
}

class RxGenreRepositoryImpl: BaseRepository, RxGenreRepository {
    
    static let shared : RxGenreRepository = RxGenreRepositoryImpl()
    private override init() {}
    
    func getAll() -> Observable<[MovieGenre]> {
        let fetchRequest : NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map{ $0.map{ $0.toMovieGenre()}}
    }

}
