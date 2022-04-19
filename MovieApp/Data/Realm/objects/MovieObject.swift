//
//  MovieObject.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 08/04/2022.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @Persisted
    var adult: Bool?
    @Persisted
    var backdropPath: String?
    @Persisted
    var genreIDS: String?
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var originalLanguage: String
    @Persisted
    var originalTitle: String?
    @Persisted
    var originalName: String?
    @Persisted
    var overview: String?
    @Persisted
    var popularity: Double?
    @Persisted
    var posterPath: String
    @Persisted
    var releaseDate: String?
    @Persisted
    var firstAirDate: String?
    @Persisted
    var title: String?
    @Persisted
    var video: Bool?
    @Persisted
    var voteAverage: Double?
    @Persisted
    var voteCount: Int?
    @Persisted(originProperty: "movies")
    var belongToType: LinkingObjects<BelongToTypeObject>
    @Persisted
    var productionCompanies: List<ProductionCompanyObject>
    @Persisted
    var genres: List<GenreObject>
    @Persisted
    var actors: List<ActorObject>
    @Persisted
    var productionCountries: List<ProductionCountryObject>
    @Persisted
    var budget: Int?
    @Persisted
    var homepage: String?
    @Persisted
    var imdbID: String?
    @Persisted
    var revenue: Int?
    @Persisted
    var runtime: Int?
    @Persisted
    var spokenLanguages: List<SpokenLanguageObject>
    @Persisted
    var status: String?
    @Persisted
    var tagline: String?
    @Persisted
    var similarMovies: List<MovieObject>
    @Persisted(originProperty: "similarMovies")
    var movies: LinkingObjects<MovieObject>
    
    func toMovieResult() -> MovieResult {
        return MovieResult(adult: adult,
                           backdropPath: backdropPath,
                           genreIDS: genreIDS?.split(separator: ",").map{ Int($0) ?? 0},
                           id: id,
                           originalLanguage: originalLanguage,
                           originalTitle: originalTitle,
                           originalName: originalName,
                           overview: overview,
                           popularity: popularity,
                           posterPath: posterPath,
                           releaseDate: releaseDate,
                           firstAirDate: firstAirDate,
                           title: title,
                           video: video,
                           voteAverage: voteAverage,
                           voteCount: voteCount)
    }
    
    func toMovieDetail() -> MovieDetailResponse {
        MovieDetailResponse(adult: adult,
                            backdropPath: backdropPath,
                            belongsToCollection: nil,
                            budget: budget,
                            genres: genres.map{ $0.toMovieGenre() },
                            homepage: homepage,
                            id: id,
                            imdbID: imdbID,
                            originalLanguage: originalLanguage,
                            originalTitle: originalTitle,
                            overview: overview,
                            popularity: popularity,
                            posterPath: posterPath,
                            productionCompanies: productionCompanies.map{ $0.toProductionCompany() },
                            productionCountries: productionCountries.map{ $0.toProductionCountry() },
                            releaseDate: releaseDate,
                            revenue: revenue,
                            runtime: runtime,
                            spokenLanguages: spokenLanguages.map{ $0.toSpokenLanguage() },
                            status: status,
                            tagline: tagline,
                            title: title,
                            video: video,
                            voteAverage: voteAverage,
                            voteCount: voteCount)
    }
}
