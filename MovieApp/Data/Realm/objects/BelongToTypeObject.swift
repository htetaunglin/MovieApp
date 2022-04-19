//
//  BelongToTypeObject.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 08/04/2022.
//

import Foundation
import RealmSwift

class BelongToTypeObject: Object {
    @Persisted(primaryKey: true)
    var name: String?
    @Persisted
    var movies: List<MovieObject>
}
