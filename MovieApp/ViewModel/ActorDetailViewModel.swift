//
//  ActorDetailViewMode.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 19/06/2022.
//

import Foundation
import RxCocoa
import RxSwift

class ActorDetailViewModel {
    private let rxActorDetailModel = RxActorDetailModelImpl.shared
    
    let actor: BehaviorRelay<ActorDetailResponse?> = BehaviorRelay(value: nil)
    let movieBehaviorSubject: BehaviorRelay<[MovieResult]> = BehaviorRelay(value: [])
    let tvBehaviorSubject: BehaviorRelay<[MovieResult]> = BehaviorRelay(value: [])
    
    final let disposeBag = DisposeBag()
    
    init(_ actorId: Int){
        fetchDetailById(actorId)
        fetchMoviesByActorId(actorId)
        fetchSeriesByActorId(actorId)
    }
    
    private func fetchDetailById(_ actorId: Int){
        rxActorDetailModel.getActorDetail(actorId)
            .subscribe(onNext: actor.accept)
            .disposed(by: disposeBag)
    }
    
    private func fetchMoviesByActorId(_ actorId: Int){
        rxActorDetailModel.getActorMovieCredit(actorId)
            .subscribe(onNext: movieBehaviorSubject.accept)
            .disposed(by: disposeBag)
    }
    
    private func fetchSeriesByActorId(_ actorId: Int){
        rxActorDetailModel.getActorTVCredit(actorId)
            .subscribe(onNext: tvBehaviorSubject.accept)
            .disposed(by: disposeBag)
    }
}
