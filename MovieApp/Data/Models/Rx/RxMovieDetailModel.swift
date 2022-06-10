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
    func subscribeMovieDetailById(_ id: Int) -> Observable<MovieDetailResponse>
    func fetchMovieDetailById(_ id: Int)
    func subscribeMovieCreditById(_ id: Int) -> Observable<[ActorInfoResponse]>
    func fetchMovieCreditByMovieId(_ id: Int)
}

class RxMovieDetailModelImpl: BaseModel, RxMovieDetailModel {
    static let shared: RxMovieDetailModel = RxMovieDetailModelImpl()
    private override init() {}
    
    private let movieRepo: MovieRepository = MovieRepositoryImpl.shared
    private let rxMovieRepo: RxMovieRepository = RxMovieRepositoryImpl.shared
    
    func subscribeMovieDetailById(_ id: Int) -> Observable<MovieDetailResponse> {
        return rxMovieRepo.getDetail(id)
    }
    
    func fetchMovieDetailById(_ id: Int) {
        networkAgent.getMovieDetailById(id){ result in
            switch result{
            case .success(let response):
                self.movieRepo.saveMovieDetail(data: response)
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
        }
    }
    
    func subscribeMovieCreditById(_ id: Int) -> Observable<[ActorInfoResponse]> {
        return rxMovieRepo.getCasts(id)
            .do(onNext: {value in
                debugPrint("Subscribe \(value.count)")
            }, onError:{ error in
                debugPrint("Error \(error.localizedDescription)")
            })
    }
    
    func fetchMovieCreditByMovieId(_ id: Int) {
        networkAgent.getMovieCreditByMovieId(id){ result in
            switch result {
            case .success(let response):
                debugPrint(response.cast?.count)
                self.movieRepo.saveCasts(id, data: response.cast ?? [])
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
        }
    }
}
