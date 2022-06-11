//
//  RxMovieDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 07/06/2022.
//

import Foundation
import RxSwift
import SwiftUI

protocol RxMovieDetailModel {
    func fetchMovieDetailById(_ id: Int) -> Observable<MovieDetailResponse>
    func fetchMovieCreditByMovieId(_ id: Int) -> Observable<[ActorInfoResponse]>
    func fetchMovieSimilar(_ id: Int) -> Observable<[MovieResult]>
    func fetchMovieTrailerVideo(_ id: Int) -> Observable<TrailerResponse>
}

class RxMovieDetailModelImpl: BaseModel, RxMovieDetailModel {
    static let shared: RxMovieDetailModel = RxMovieDetailModelImpl()
    private override init() {}
    
    let disposeBag = DisposeBag()
    
    private let movieRepo: MovieRepository = MovieRepositoryImpl.shared
    private let rxMovieRepo: RxMovieRepository = RxMovieRepositoryImpl.shared
    
    
    func fetchMovieDetailById(_ id: Int) -> Observable<MovieDetailResponse> {
        rxNetworkAgent.getMovieDetailById(id)
            .subscribe(onNext: { result in
                self.movieRepo.saveMovieDetail(data: result)
            }).disposed(by: disposeBag)
        return rxMovieRepo.getDetail(id)
    }
    
    func fetchMovieCreditByMovieId(_ id: Int) -> Observable<[ActorInfoResponse]>  {
        rxNetworkAgent.getMovieCreditByMovieId(id)
            .subscribe(onNext: { response in
                self.movieRepo.saveCasts(id, data: response.cast ?? [])
            }).disposed(by: disposeBag)
        return rxMovieRepo.getCasts(id)
            .do(onNext: {value in
                debugPrint("Subscribe \(value.count)")
            }, onError:{ error in
                debugPrint("Error \(error.localizedDescription)")
            })
    }
    
    func fetchMovieSimilar(_ id: Int) -> Observable<[MovieResult]>{
        rxNetworkAgent.getMovieSimilar(id)
            .subscribe(onNext: { movies in
                self.movieRepo.saveSimilarContent(id, data: movies.results ?? [])
            }).disposed(by: disposeBag)
        return rxMovieRepo.getSimilarMovies(id)
    }
    
    func fetchMovieTrailerVideo(_ id: Int) -> Observable<TrailerResponse> {
        return rxNetworkAgent.getMovieTrailerVideo(id)
    }
}
