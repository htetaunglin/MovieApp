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
    
    var initData : [ActorInfoResponse]?
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        loadSubscription()
    }
    
    private func loadSubscription(){
        addCollectionViewBindingObserver()
        addCollectionViewPagingObserver()
        addItemSelectedObserver()
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
                self?.viewModel.handlePagination(indexPath: value.at)
            }).disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver(){
        actorCollectionView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            let items = self?.viewModel.actorResults.value
            if let actorId = items?[indexPath.row].id {
                self?.navigateToActorDetail(actorId: actorId)
            }
        }).disposed(by: disposeBag)
    }
}

extension MoreActorsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = (collectionView.frame.width / 3) - 9
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
