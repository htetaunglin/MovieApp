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
    
    func subscribeActors(){
        rxActorModel.subscribeAllPopularActor()
        .subscribe(onNext: {[weak self] values in
            self?.actorResults.accept(values)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchActors(page: Int){
        rxActorModel.getPopularActor(page: page)
    }
    
    func handlePagination(indexPath: IndexPath){
        let totalItems = self.actorResults.value.count
        let isAtLastRow = indexPath.row == (totalItems - 1)
        if isAtLastRow {
            let page = (totalItems / 20) + 1
            self.fetchActors(page: page)
        }
    }
}
