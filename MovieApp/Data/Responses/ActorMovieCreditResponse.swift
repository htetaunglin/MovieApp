// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let castMovieCreditResponse = try? newJSONDecoder().decode(CastMovieCreditResponse.self, from: jsonData)

import Foundation

// MARK: - CastMovieCreditResponse
struct ActorMovieCreditResponse: Codable {
    let cast, crew: [ActorMovieCredit]?
    let id: Int?
}

// MARK: - Cast
struct ActorMovieCredit: Codable {
    let originalLanguage, originalTitle: String?
    let posterPath: String?
    let video: Bool?
    let id: Int?
    let overview, releaseDate: String?
    let voteCount: Int?
    let voteAverage: Double?
    let adult: Bool?
    let backdropPath: String?
    let title: String?
    let genreIDS: [Int]?
    let popularity: Double?
    let character, creditID: String?
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case video, id, overview
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case adult
        case backdropPath = "backdrop_path"
        case title
        case genreIDS = "genre_ids"
        case popularity, character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func toMovieResult() -> MovieResult {
        return MovieResult(adult: adult, backdropPath: backdropPath, genreIDS: genreIDS, id: id, originalLanguage: originalLanguage, originalTitle: originalTitle, originalName: title, overview: overview, popularity: popularity, posterPath: posterPath, releaseDate: releaseDate, title: title, video: video, voteAverage: voteAverage, voteCount: voteCount)
    }
}
