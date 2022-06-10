//
//  RxSeriesDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 07/06/2022.
//

import Foundation
import RxSwift

protocol RxSeriesDetailModel {
    func subscribeMovieDetailById(_ id: Int) -> Observable<MovieDetailResponse>
    func fetchMovieDetailById(_ id: Int)
    func subscribeMovieCreditById(_ id: Int) -> Observable<[ActorInfoResponse]>
    func fetchMovieCreditByMovieId(_ id: Int)
}
