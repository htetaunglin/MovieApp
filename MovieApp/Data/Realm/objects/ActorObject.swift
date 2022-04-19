//
//  ActorObject.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 08/04/2022.
//

import Foundation
import RealmSwift

class ActorObject : Object {
    @Persisted(primaryKey: true)
    var id : Int
    @Persisted
    var adult : Bool
    @Persisted
    var profilePath : String?
    @Persisted
    var popularity : Double
    @Persisted
    var knownForDepartment : String?
    @Persisted
    var alsoKnownAs : String?
    @Persisted
    var gender : Int?
    @Persisted
    var homePage : String?
    @Persisted
    var name : String?
    @Persisted
    var birthday : String?
    @Persisted
    var placeOfBirth : String?
    @Persisted
    var imdbID : String?
    @Persisted
    var deathday : String?
    @Persisted
    var biography : String?
    @Persisted(originProperty: "actors")
    var movies: LinkingObjects<MovieObject>
    
    func toActorInfoResponse() -> ActorInfoResponse {
        return ActorInfoResponse(adult: adult,
                                 gendre: gender,
                                 id: id,
                                 knownFor: movies.map{ $0.toMovieResult() },
                                 knownForDepartment: knownForDepartment,
                                 name: name,
                                 popularity: popularity,
                                 profilePath: profilePath)
    }
    
    func toActorDetailResponse() -> ActorDetailResponse {
        return ActorDetailResponse(adult: adult,
                                   alsoKnownAs: alsoKnownAs?.split(separator: ",").map{ $0.base },
                                   biography: biography,
                                   birthday: birthday,
                                   deathday: deathday,
                                   gender: gender,
                                   homepage: homePage,
                                   id: id,
                                   imdbID: imdbID,
                                   knownForDepartment: knownForDepartment,
                                   name: name,
                                   placeOfBirth: placeOfBirth,
                                   popularity: popularity,
                                   profilePath: profilePath)
    }
}
