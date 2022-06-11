//
//  RxSeriesDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 07/06/2022.
//

import Foundation
import RxSwift

protocol RxSeriesDetailModel {
    func fetchSeriesDetailById(_ id: Int) -> Observable<MovieDetailResponse>
    func fetchSeriesTrailerVideo(_ id: Int) -> Observable<TrailerResponse>
}

class RxSeriesDetailModelImpl: BaseModel, RxSeriesDetailModel {
    
    static let shared: RxSeriesDetailModel = RxSeriesDetailModelImpl()
    private override init() {}
    
    let disposeBag = DisposeBag()
    
    private let movieRepo: MovieRepository = MovieRepositoryImpl.shared
    private let rxMovieRepo: RxMovieRepository = RxMovieRepositoryImpl.shared
    
    func fetchSeriesDetailById(_ id: Int) -> Observable<MovieDetailResponse> {
        rxNetworkAgent.getTVSeriesDetailById(id)
            .subscribe(onNext: {[weak self] response in
                self?.movieRepo.saveSeriesDetail(data: response)
            })
            .disposed(by: disposeBag)
        return rxMovieRepo.getDetail(id)
    }
    
    func fetchSeriesTrailerVideo(_ id: Int) -> Observable<TrailerResponse> {
        return rxNetworkAgent.getTVTrailerVideo(id)
    }
}
