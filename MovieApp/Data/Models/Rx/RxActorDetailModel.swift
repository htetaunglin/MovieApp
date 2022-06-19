//
//  RxActorDetailMode.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 11/06/2022.
//

import Foundation
import RxSwift
protocol RxActorDetailModel {
    func getActorDetail(_ id: Int) -> Observable<ActorDetailResponse>
    func getActorMovieCredit(_ id: Int) -> Observable<[MovieResult]>
    func getActorTVCredit(_ id: Int) -> Observable<[MovieResult]>
}


class RxActorDetailModelImpl: BaseModel, RxActorDetailModel {
    
    static let shared: RxActorDetailModel = RxActorDetailModelImpl()
    private override init(){}
    
    let disposeBag = DisposeBag()
    
    private let actorRepo: ActorRepository = ActorRepositoryImpl.shared
    private let rxActorRepo: RxActorRepository = RxActorRepositoryImpl.shared
    
    func getActorDetail(_ id: Int) -> Observable<ActorDetailResponse> {
        rxNetworkAgent.getActorDetail(id)
            .do(onNext: { value in
                debugPrint(value.name ?? "-- no name --")
            })
            .subscribe(onNext: {[weak self] response in
                debugPrint("Save \(response.id ?? -1) \(response.name ?? "-- no name --")")
                self?.actorRepo.saveDetails(data: response)
            })
            .disposed(by: disposeBag)
        return rxActorRepo.getDetails(id: id).compactMap{ $0 }
    }
    
    func getActorMovieCredit(_ id: Int) -> Observable<[MovieResult]> {
        rxNetworkAgent.getActorMovieCredit(id)
            .do(onNext: { value in
                debugPrint(value.cast ?? [])
            })
            .subscribe(onNext: {[weak self] response in
                self?.actorRepo.saveMoviesByActor(id, list: response.cast?.map{ $0.toMovieResult() } ?? [])
            })
            .disposed(by: disposeBag)
        return rxActorRepo.getMovieCredit(id: id, isTVSeries: false)
    }
    
    func getActorTVCredit(_ id: Int) -> Observable<[MovieResult]> {
        rxNetworkAgent.getActorTVCredit(id)
            .subscribe(onNext: {[weak self] response in
                self?.actorRepo.saveMoviesByActor(id, list: response.cast?.map{ $0.toMovieResult() } ?? [])
            })
            .disposed(by: disposeBag)
        return rxActorRepo.getMovieCredit(id: id, isTVSeries: true)
    }
    
}
