//
//  RxMovieModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 31/05/2022.
//

import Foundation
import RxSwift

protocol RxMovieModel {
    // Showcase
    //    func getTopRelatedMoveiList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    //    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    //    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    
    func getPopularMovieList() -> Observable<[MovieResult]>
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared = RxMovieModelImpl()
    private override init(){}
    
    private let movieRepo: MovieRepository = MovieRepositoryRealmImpl.shared
    private let movieRxRepo: RxMovieRepository = RxMovieRepositoryImpl.shared
    
    let disposeBag = DisposeBag()
    
    func getPopularMovieList() -> Observable<[MovieResult]> {
        let contentType : MovieSeriesGroupType = .popularMovies
        let observableRemoteMovieList = RxNetworkingAgent.shared.getPopularMovieList()
        observableRemoteMovieList.subscribe { response in
            self.movieRepo.saveList(type: contentType, data: response.results)
        }.disposed(by: disposeBag)
        
        let observableLocalMovieList = movieRxRepo.getMoviesByGroupType(type: contentType)
        return observableLocalMovieList
        //        return RxNetworkingAgent.shared.getPopularMovieList()
        //            .do { response in
        //                self.movieRepo.saveList(type: contentType, data: response.results)
        //            }
        //            .catchAndReturn(MovieListResponse.empty())
        //            .flatMap{ _ -> Observable<[MovieResult]> in
        //                return Observable.create{ (observer) -> Disposable in
        //                    let observableMovieList = self.movieRxRepo.getMoviesByGroupType(type: contentType)
        ////                    self.movieRepo.getMoviesByGroupType(type: contentType){
        ////                        observer.onNext($0)
        ////                        observer.onCompleted()
        ////                    }
        //                    return Disposables.create()
        //                }
        
    }
}
