//
//  GenreObject.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 08/04/2022.
//

import Foundation
import RealmSwift

class GenreObject: Object {
    @Persisted(primaryKey: true)
    var id: Int
    @Persisted
    var name : String
    @Persisted(originProperty: "genres")
    var movies: LinkingObjects<MovieObject>
    
    func toMovieGenre() -> MovieGenre {
        return MovieGenre(id: id, name: name)
    }
}
