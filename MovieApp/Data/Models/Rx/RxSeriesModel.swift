//
//  RxSeriesModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 04/06/2022.
//

import Foundation
import RxSwift

protocol RxSeriesModel {
    func getPopularSeriesList() -> Observable<[MovieResult]>
}

class RxSeriesModelImpl: BaseModel, RxSeriesModel {
    
    static let shared: RxSeriesModel = RxSeriesModelImpl()
    private override init() {}
    
    private let movieRepo: MovieRepository = MovieRepositoryRealmImpl.shared
    private let movieRxRepo: RxMovieRepository = RxMovieRepositoryRealmImpl.shared
    
    let disposeBag = DisposeBag()
    
    func getPopularSeriesList() -> Observable<[MovieResult]> {
        let contentType : MovieSeriesGroupType = .popularSeries
        let observableRemoteSeriesList = rxNetworkAgent.getPopularSeriesList()
        observableRemoteSeriesList.subscribe { response in
            self.movieRepo.saveList(type: contentType, data: response.results)
        }.disposed(by: disposeBag)
        let observableLocalSeriesList = movieRxRepo.getMoviesByGroupType(type: contentType)
        return observableLocalSeriesList
    }
}
