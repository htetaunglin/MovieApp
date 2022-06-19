//
//  MoreActorViewModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 19/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MoreActorViewModel{
    
    private let rxActorModel = RxActorModelImpl.shared
    
    private let disposeBag: DisposeBag = DisposeBag()
    let actorResults: BehaviorRelay<[ActorInfoResponse]> = BehaviorRelay(value: [])
    
    init() {
        subscribeActors()
    }
    
    private func subscribeActors(){
        rxActorModel.subscribePopularActor()
            .subscribe(onNext: actorResults.accept)
            .disposed(by: disposeBag)
    }
    
    func fetchActors(page: Int){
        rxActorModel.getPopularActor(page: page)
    }
}
