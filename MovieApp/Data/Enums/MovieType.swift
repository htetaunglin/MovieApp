//
//  MovieType.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 13/02/2022.
//

import Foundation

enum MoveType : Int {
    case MOVIE_SLIDER = 0
    case MOVIE_POPULAR = 1
    case SERIES_POPULAR = 2
    case MOVIE_SHOWTIME = 3
    case MOVIE_GNERE = 4
    case MOVIE_SHOWCASE = 5
    case MOVIE_BESTACTOR = 6
}

enum MovieSeriesGroupType: String, CaseIterable {
    case upcomingMovies = "Upcoming Movies"
    case popularMovies = "Popular Movies"
    case topRatedMovies = "Top Rated Movies"
    case popularSeries = "Popular Series"
    case upcomingSeries = "Upcoming Series"
    case actorMovieCredits = "Actor Movie Credits"
    case actorSeriesCredits = "Actor Series Credits"
}
