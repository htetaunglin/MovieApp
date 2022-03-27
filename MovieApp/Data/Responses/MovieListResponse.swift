// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieListResponse = try? newJSONDecoder().decode(MovieListResponse.self, from: jsonData)

import Foundation

// MARK: - UpcomingMovieList
struct MovieListResponse: Codable {
    let dates: Dates?
    let page: Int
    let results: [MovieResult]?
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}
//
//{
//            "backdrop_path": "/4g5gK5eGWZg8swIZl6eX2AoJp8S.jpg",
//            "first_air_date": "2003-10-21",
//            "genre_ids": [
//                18
//            ],
//            "id": 11250,
//            "name": "Pasión de gavilanes",
//            "origin_country": [
//                "CO"
//            ],
//            "original_language": "es",
//            "original_name": "Pasión de gavilanes",
//            "overview": "The Reyes-Elizondo's idyllic lives are shattered by a murder charge against Eric and León.",
//            "popularity": 2224.706,
//            "poster_path": "/lWlsZIsrGVWHtBeoOeLxIKDd9uy.jpg",
//            "vote_average": 7.7,
//            "vote_count": 1743
//        }

// MARK: - Result
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, originalName, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
