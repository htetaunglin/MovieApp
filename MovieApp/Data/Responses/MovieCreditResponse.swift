// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieCreditResponse = try? newJSONDecoder().decode(MovieCreditResponse.self, from: jsonData)

import Foundation

// MARK: - MovieCreditResponse
struct MovieCreditResponse: Codable {
    let id: Int?
    let cast, crew: [MovieCast]?
}

// MARK: - Cast
struct MovieCast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func toActorInfoResponse() -> ActorInfoResponse{
        return ActorInfoResponse(adult: adult, gendre: gender, id: id, knownFor: nil, knownForDepartment: knownForDepartment, name: name, popularity: popularity, profilePath: profilePath)
    }
    
    func toActorObject() -> ActorObject {
        let object = ActorObject()
        object.adult = adult ?? false
        object.gender = gender
        object.id = id ?? 0
        object.knownForDepartment = knownForDepartment
        object.name = name
        object.popularity = popularity ?? 0.0
        object.profilePath = profilePath
        return object
    }
}
