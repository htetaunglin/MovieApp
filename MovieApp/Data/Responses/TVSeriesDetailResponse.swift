// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tVSeriesDetailResponse = try? newJSONDecoder().decode(TVSeriesDetailResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - TVSeriesDetailResponse
struct TVSeriesDetailResponse: Codable {
    let adult: Bool?
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: TEpisodeToAir?
    let name: String?
    let nextEpisodeToAir: TEpisodeToAir?
    let networks: [Network]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, type: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toFilmDetailVo() -> FilmDetailVo {
           return FilmDetailVo(
               id: id,
               isTVSeries: true,
               title: name,
               originalTitle: originalName,
               releaseDate: firstAirDate,
               releaseYear: firstAirDate?.split(separator: "-")[0].uppercased(),
               storyLines: overview,
               description: overview,
               backdropPath: backdropPath,
               voteCount: voteCount,
               duration: episodeRunTime?.reduce(0){$0+$1},
               voteAverage: voteAverage,
               genres: genres,
               productions: productionCompanies)
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genres?.map{ String($0.id) }.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.originalTitle = originalName
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = firstAirDate ?? ""
        entity.title = name
        entity.video = true
        entity.runTime = Int64(episodeRunTime?.reduce(0){$0+$1} ?? 0)
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        // Relationship
        productionCompanies?.forEach{
            entity.addToProductionCompanies($0.toProductionCompanyEntity(context: context))
        }
        productionCountries?.forEach{
            entity.addToProductionCountries($0.toProductionCountryEntity(context: context))
        }
        spokenLanguages?.forEach{
            entity.addToSpokenLanguages($0.toSpokenLanguageEntity(context: context))
        }
        return entity
    }
    
    func toMovieObject() -> MovieObject {
        let object = MovieObject()
        object.id = id
        object.adult = adult
        object.backdropPath = backdropPath
        object.genreIDS = genres?.map{ "\($0.id)" }.joined(separator: ",")
        object.genres.append(objectsIn: genres?.map{ $0.toGenreObject() } ?? [])
        object.originalLanguage = originalLanguage ?? ""
        object.originalTitle = name
        object.originalName = name
        object.overview = overview
        object.popularity = popularity ?? 0
        object.posterPath = posterPath ?? ""
        object.releaseDate = firstAirDate
        object.firstAirDate = firstAirDate
        object.title = name
        object.video = true
        object.voteAverage = voteAverage
        object.voteCount = voteCount
        object.productionCompanies.append(objectsIn: productionCompanies?.map{ $0.toProductionCompanyObject() } ?? [])
        object.productionCountries.append(objectsIn: productionCountries?.map{ $0.toProductionCountryObject() } ?? [])
        object.runtime = episodeRunTime?.reduce(0){$0+$1} ?? 0
        object.spokenLanguages.append(objectsIn: spokenLanguages?.map{ $0.toSpokenLanguageObject() } ?? [])
        object.status = status
        object.tagline = tagline
        return object
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int?
    let creditID, name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}

// MARK: - TEpisodeToAir
struct TEpisodeToAir: Codable {
    let airDate: String?
    let episodeNumber, id: Int?
    let name, overview, productionCode: String?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id, name, overview
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Network
struct Network: Codable {
    let name: String?
    let id: Int?
    let logoPath, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case name, id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int?
    let name, overview, posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}
