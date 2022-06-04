//
//  RxMovieModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 31/05/2022.
//

import Foundation
import RxSwift

protocol RxMovieModel {
    func getPopularMovieList() -> Observable<[MovieResult]>
    func getTopRelatedMovieList(page: Int) -> Observable<[MovieResult]>
    func getUpcomingMovieList() -> Observable<[MovieResult]>
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared = RxMovieModelImpl()
    private override init(){}
    
    private let movieRepo: MovieRepository = MovieRepositoryRealmImpl.shared
    private let movieRxRepo: RxMovieRepository = RxMovieRepositoryImpl.shared
    
    let disposeBag = DisposeBag()
    

    func getPopularMovieList() -> Observable<[MovieResult]> {
        let contentType : MovieSeriesGroupType = .popularMovies
        let observableRemoteMovieList = rxNetworkAgent.getPopularMovieList()
        observableRemoteMovieList.subscribe { response in
            self.movieRepo.saveList(type: contentType, data: response.results)
        }.disposed(by: disposeBag)
        let observableLocalMovieList = movieRxRepo.getMoviesByGroupType(type: contentType)
        return observableLocalMovieList
    }
    
    func getTopRelatedMovieList(page: Int) -> Observable<[MovieResult]> {
        let contentType : MovieSeriesGroupType = .topRatedMovies
        let observableRemoteMovieList = rxNetworkAgent.getTopRelatedMovieList(page: page)
        observableRemoteMovieList.subscribe { response in
            self.movieRepo.saveList(type: contentType, data: response.results)
        }.disposed(by: disposeBag)
        //TODO Pagination
        let observableLocalMovieList = movieRxRepo.getMoviesByGroupType(type: contentType)
        return observableLocalMovieList
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]> {
        let contentType : MovieSeriesGroupType = .upcomingMovies
        let observableRemoteMovieList = rxNetworkAgent.getUpcomingMovieList()
        observableRemoteMovieList.subscribe { response in
            self.movieRepo.saveList(type: contentType, data: response.results)
        }.disposed(by: disposeBag)
        let observableLocalMovieList = movieRxRepo.getMoviesByGroupType(type: contentType)
        return observableLocalMovieList
    }
    
}
