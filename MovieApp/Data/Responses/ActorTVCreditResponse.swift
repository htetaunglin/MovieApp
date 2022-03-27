// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let castTVCreditResponse = try? newJSONDecoder().decode(CastTVCreditResponse.self, from: jsonData)

import Foundation

// MARK: - CastTVCreditResponse
struct CastTVCreditResponse: Codable {
    let cast, crew: [ActorTVCredit]?
    let id: Int?
}

// MARK: - Cast
struct ActorTVCredit: Codable {
    let adult: Bool?
    let originCountry: [String]?
    let id: Int?
    let overview, originalName: String?
    let voteCount: Int?
    let backdropPath: String?
    let name: String?
    let genreIDS: [Int]?
    let firstAirDate: String?
    let originalLanguage: String?
    let voteAverage: Double?
    let posterPath: String?
    let popularity: Double?
    let character, creditID: String?
    let episodeCount: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case originCountry = "origin_country"
        case id, overview
        case originalName = "original_name"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
        case name
        case genreIDS = "genre_ids"
        case firstAirDate = "first_air_date"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case popularity, character
        case creditID = "credit_id"
        case episodeCount = "episode_count"
        case department, job
    }
    
    func toMovieResult() -> MovieResult {
        return MovieResult(adult: adult, backdropPath: backdropPath, genreIDS: genreIDS, id: id, originalLanguage: originalLanguage, originalTitle: originalName, originalName: originalName, overview: overview, popularity: popularity, posterPath: posterPath, releaseDate: firstAirDate, title: name, video: nil, voteAverage: voteAverage, voteCount: voteCount)
    }
}
