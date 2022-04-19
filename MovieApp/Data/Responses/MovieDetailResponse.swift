// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailResponse = try? newJSONDecoder().decode(MovieDetailResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - MovieDetailResponse
struct MovieDetailResponse : Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toFilmDetailVo() -> FilmDetailVo {
        return FilmDetailVo(
            id: id,
            isTVSeries: false,
            title: title,
            originalTitle: originalTitle,
            releaseDate: releaseDate,
            releaseYear: releaseDate?.split(separator: "-")[0].uppercased(),
            storyLines: overview,
            description: overview,
            backdropPath: backdropPath,
            voteCount: voteCount,
            duration: runtime,
            voteAverage: voteAverage,
            genres: genres,
            productions: productionCompanies)
    }
    
    func toMovieObject() -> MovieObject {
        let object = MovieObject()
        object.id = id
        object.adult = adult
        object.backdropPath = backdropPath
        object.genreIDS = genres?.map{ "\($0.id)" }.joined(separator: ",")
        object.genres.append(objectsIn: genres?.map{ $0.toGenreObject() } ?? [])
        object.originalLanguage = originalLanguage ?? ""
        object.originalTitle = originalTitle
        object.originalName = originalTitle
        object.overview = overview
        object.popularity = popularity ?? 0
        object.posterPath = posterPath ?? ""
        object.releaseDate = releaseDate
        object.title = title
        object.video = video ?? false
        object.voteAverage = voteAverage
        object.voteCount = voteCount
        object.video = false
        object.budget = budget
        object.productionCompanies.append(objectsIn: productionCompanies?.map{ $0.toProductionCompanyObject() } ?? [])
        object.productionCountries.append(objectsIn: productionCountries?.map{ $0.toProductionCountryObject() } ?? [])
        object.revenue = revenue
        object.runtime = runtime
        object.spokenLanguages.append(objectsIn: spokenLanguages?.map{ $0.toSpokenLanguageObject() } ?? [])
        object.status = status
        object.tagline = tagline
        object.voteAverage = voteAverage
        object.voteCount = voteCount
        return object
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    @discardableResult
    func toProductionCompanyEntity(context: NSManagedObjectContext) -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity(context: context)
        entity.id = Int32(id!)
        entity.logoPath = logoPath
        entity.name = name
        entity.originalCountry = originCountry
        return entity
    }
    
    @discardableResult
    func toProductionCompanyObject() -> ProductionCompanyObject {
        let object = ProductionCompanyObject()
        object.id = id ?? 0
        object.logoPath = logoPath ?? ""
        object.name = name ?? ""
        object.originalCountry = originCountry ?? ""
        return object;
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    @discardableResult
    func toProductionCountryEntity(context: NSManagedObjectContext) -> ProductionCountryEntity {
        let entity = ProductionCountryEntity(context: context)
        entity.iso3166_1 = iso3166_1
        entity.name = name
        return entity
    }
    
    @discardableResult
    func toProductionCountryObject() -> ProductionCountryObject {
        let object = ProductionCountryObject()
        object.iso3166_1 = iso3166_1
        object.name = name ?? ""
        return object;
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
    
    @discardableResult
    func toSpokenLanguageEntity(context: NSManagedObjectContext) -> SpokenLanguageEntity {
        let entity = SpokenLanguageEntity(context: context)
        entity.englishName = englishName
        entity.iso639_1 = iso639_1
        entity.name = name
        return entity
    }
    
    @discardableResult
    func toSpokenLanguageObject() -> SpokenLanguageObject {
        let object = SpokenLanguageObject()
        object.englishName = englishName ?? ""
        object.iso639_1 = iso639_1 ?? ""
        object.name = name ?? ""
        return object
    }
}

struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
