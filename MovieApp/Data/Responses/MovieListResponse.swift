// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieListResponse = try? newJSONDecoder().decode(MovieListResponse.self, from: jsonData)

import Foundation
import CoreData
import RealmSwift

// MARK: - UpcomingMovieList
struct MovieListResponse: Codable {
    let dates: Dates?
    let page: Int
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

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

// MARK: - Result
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, originalName, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, firstAirDate, title: String?
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
        case firstAirDate = "first_air_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext, groupType: BelongsToTypeEntity) -> MovieEntity{
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genreIDS?.map{ String($0) }.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? firstAirDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.addToBelongToType(groupType)
        return entity
    }
    
    func toMovieObject(genres: [GenreObject]) -> MovieObject {
        let object = MovieObject()
        object.id = id
        object.adult = adult
        object.backdropPath = backdropPath
        object.genreIDS = genreIDS?.map{ String($0) }.joined(separator: ",")
        object.genres.append(objectsIn: genres)
        object.originalLanguage = originalLanguage ?? ""
        object.originalName = originalName
        object.originalTitle = originalTitle
        object.overview = overview
        object.popularity = popularity ?? 0
        object.posterPath = posterPath ?? ""
        object.releaseDate = releaseDate ?? firstAirDate ?? ""
        object.firstAirDate = firstAirDate ?? ""
        object.title = title
        object.video = video ?? true
        object.voteAverage = voteAverage
        object.voteCount = voteCount
        return object
    }
}
