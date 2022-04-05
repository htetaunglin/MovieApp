//
//  MovieEntityX.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData

extension MovieEntity {
    func toMovieResult() -> MovieResult {
        return MovieResult(
            adult: self.adult,
            backdropPath: self.backdropPath,
            genreIDS: self.genreIDs?.components(separatedBy: ",").compactMap{ Int($0.trimmingCharacters(in: .whitespaces)) } ?? [],
            id: Int(self.id),
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            originalName: self.originalName,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            firstAirDate: self.firstAirDate,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: Int(self.voteCount)
        )
    }
    
    func toMovieDetailResponse() -> MovieDetailResponse? {
        let genreEntities = (self.genres?.allObjects as? [GenreEntity]) ?? [GenreEntity]()
        let companyEntities = (self.productionCompanies?.allObjects as? [ProductionCompanyEntity]) ?? [ProductionCompanyEntity]()
        let countryEntities = (self.productionCountries?.allObjects as? [ProductionCountryEntity]) ?? [ProductionCountryEntity]()
        let languageEntities = (self.spokenLanguages?.allObjects as? [SpokenLanguageEntity]) ?? [SpokenLanguageEntity]()
        
        return MovieDetailResponse(
            adult: self.adult,
            backdropPath: self.backdropPath,
            belongsToCollection:  nil,
            budget: Int(self.budget),
            genres: genreEntities.map{ $0.toMovieGenre() },
            homepage: self.homePage,
            id: Int(self.id),
            imdbID: self.imdbID,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            productionCompanies: companyEntities.map{ $0.toProductionCompany() },
            productionCountries: countryEntities.map{ $0.toProductionCountry() },
            releaseDate: self.releaseDate,
            revenue: Int(self.revenu),
            runtime: Int(self.runTime),
            spokenLanguages: languageEntities.map{ $0.toSpokenLanguage() },
            status: self.status,
            tagline: self.tagline,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: Int(voteCount)
        )
    }
}


extension MovieDetailResponse {
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genres?.map{ String($0.id) }.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalTitle
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.runTime = Int64(runtime ?? 0)
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
}
