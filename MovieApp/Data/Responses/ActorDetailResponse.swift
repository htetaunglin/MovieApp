// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailResponse = try? newJSONDecoder().decode(ActorDetailResponse.self, from: jsonData)

import Foundation

// MARK: - ActorDetailResponse
struct ActorDetailResponse: Codable {
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, birthday, deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int?
    let imdbID, knownForDepartment, name, placeOfBirth: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    func toActorObject() -> ActorObject {
        let object = ActorObject()
        object.adult = adult ?? false
        object.alsoKnownAs = alsoKnownAs?.joined(separator: ",")
        object.biography = biography
        object.birthday = birthday
        object.deathday = deathday
        object.gender = gender
        object.id = id ?? 0
        object.imdbID = imdbID
        object.knownForDepartment = knownForDepartment
        object.name = name
        object.placeOfBirth = placeOfBirth
        object.popularity = popularity ?? 0.0
        object.profilePath = profilePath
        return object
    }
}
