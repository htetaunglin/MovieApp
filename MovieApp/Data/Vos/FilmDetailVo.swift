//
//  FilmDetailVo.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 22/03/2022.
//

import Foundation

public struct FilmDetailVo{
    var id: Int?
    var isTVSeries: Bool
    var title, originalTitle, releaseDate, releaseYear, storyLines, description, backdropPath : String?
    var voteCount, duration: Int?
    var voteAverage: Double?
    var genres: [MovieGenre]?
    var productions: [ProductionCompany]?
}
