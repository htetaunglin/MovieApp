//
//  MoreActorsViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 23/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MoreActorsViewController: UIViewController {
    
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    var initData : [ActorInfoResponse]? {
        didSet {
            if let results = initData {
                actorResults.onNext(results)
            }
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    let actorResults: BehaviorSubject<[ActorInfoResponse]> = BehaviorSubject(value: [])
    
    private let actorModel = ActorModelImpl.shared
    private let rxActorModel = RxActorModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        loadSubscription()
    }
    
    private func loadSubscription(){
        subscribeActors()
        addCollectionViewBindingObserver()
        addCollectionViewPagingObserver()
    }
    
    private func subscribeActors(){
        RxActorModelImpl.shared.subscribePopularActor()
            .subscribe(onNext: self.actorResults.onNext)
            .disposed(by: disposeBag)
    }
    
    private func registerCollectionView(){
        actorCollectionView.delegate = self
        actorCollectionView.registerForCell(identifier: BestActorCollectionViewCell.identifier)
    }
    
    
    private func addCollectionViewBindingObserver() {
        self.actorResults.bind(to: actorCollectionView.rx.items(cellIdentifier: BestActorCollectionViewCell.identifier, cellType: BestActorCollectionViewCell.self)) { (row, element, cell) in
            cell.data = element
        }.disposed(by: disposeBag)
    }
    
    
    private func addCollectionViewPagingObserver(){
        actorCollectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] value in
                let itemCount = (try! self?.actorResults.value().count ?? 1)
                let isAtLastRow = value.at.row == (itemCount - 1)
                if(isAtLastRow) {
                    self?.fetchActors(page: (itemCount / 20) + 1)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchActors(page: Int){
        rxActorModel.getPopularActor(page: page)
    }
}

extension MoreActorsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = (collectionView.frame.width / 3) - 9
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
