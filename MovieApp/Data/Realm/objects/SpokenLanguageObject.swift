//
//  SpokenLanguageObject.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 18/04/2022.
//

import Foundation
import RealmSwift

class SpokenLanguageObject: Object {
    @Persisted(primaryKey: true)
    var englishName : String
    @Persisted
    var iso639_1: String?
    @Persisted
    var name: String
    @Persisted(originProperty: "spokenLanguages")
    var movies: LinkingObjects<MovieObject>
    
    func toSpokenLanguage() -> SpokenLanguage {
        return SpokenLanguage(englishName: englishName, iso639_1: iso639_1, name: name)
    }
}
