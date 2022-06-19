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
    
    let viewModel: MoreActorViewModel = MoreActorViewModel()
    
    var initData : [ActorInfoResponse]? {
        didSet {
            if let results = initData {
                viewModel.actorResults.accept(results)
            }
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        loadSubscription()
    }
    
    private func loadSubscription(){
        addCollectionViewBindingObserver()
        addCollectionViewPagingObserver()
    }

    private func registerCollectionView(){
        actorCollectionView.delegate = self
        actorCollectionView.registerForCell(identifier: BestActorCollectionViewCell.identifier)
    }
    
    
    private func addCollectionViewBindingObserver() {
        viewModel.actorResults.bind(to: actorCollectionView.rx.items(cellIdentifier: BestActorCollectionViewCell.identifier, cellType: BestActorCollectionViewCell.self)) { (row, element, cell) in
            cell.data = element
        }.disposed(by: disposeBag)
    }
    
    
    private func addCollectionViewPagingObserver(){
        actorCollectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] value in
                let itemCount = self?.viewModel.actorResults.value.count ?? 0
                let isAtLastRow = value.at.row == (itemCount - 1)
                if(isAtLastRow) {
                    self?.fetchActors(page: (itemCount / 20) + 1)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchActors(page: Int){
        viewModel.fetchActors(page: page)
    }
}

extension MoreActorsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = (collectionView.frame.width / 3) - 9
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
