//
//  MovieViewSectionItem.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 04/06/2022.
//

import Foundation
import RxDataSources

enum SectionItem {
    case upComingMovieSection(items: [MovieResult])
    case popularMovieSection(items: [MovieResult])
    case popularSeriesSection(items: [MovieResult])
    case movieShowTimeSection
    case movieGenreSection(items: [MovieGenre])
    case showcaseMovieSection(items: [MovieResult])
    case bestActorSection(items: ActorListResponse)
}

enum HomeMovieSectionModel: SectionModelType {
    init(original: HomeMovieSectionModel, items: [Item]) {
        switch original {
        case .movieResult(let results):
            self = .movieResult(items: results)
        case .actorResult(let results):
            self = .actorResult(items: results)
        case .genreResult(let results):
            self = .genreResult(items: results)
        }
    }
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .movieResult(let items):
            return items
        case .actorResult(let items):
            return items
        case .genreResult(let items):
            return items
        }
    }
    
    case movieResult(items: [SectionItem])
    case actorResult(items: [SectionItem])
    case genreResult(items: [SectionItem])
}
