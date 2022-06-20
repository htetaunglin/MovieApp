//
//  MoreShowCaseViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 23/03/2022.
//

import UIKit
import RxSwift

class MoreShowCaseViewController: UIViewController {

    @IBOutlet weak var collectionViewMoreShowCase: UICollectionView!
    
    var initData: MovieListResponse? {
        didSet {
            if let results = initData?.results {
                viewModel.obserableMovies.accept(results)
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    private let viewModel = MoreShowcaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        subscribeMovies()
        addCollectionViewPagingObserver()
    }
    
    private func registerCollectionView(){
        collectionViewMoreShowCase.delegate = self
        collectionViewMoreShowCase.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
    private func subscribeMovies(){
        viewModel.obserableMovies
            .bind(to: collectionViewMoreShowCase.rx.items(cellIdentifier: ShowCaseCollectionViewCell.identifier, cellType: ShowCaseCollectionViewCell.self)){ row, element, cell in
                cell.data = element
            }.disposed(by: disposeBag)
    }
    
    private func addCollectionViewPagingObserver(){
        collectionViewMoreShowCase.rx.willDisplayCell
            .subscribe(onNext: {[weak self] value in
                self?.viewModel.handlePagination(indexPath: value.at)
            }).disposed(by: disposeBag)
    }
}

extension MoreShowCaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - 16
        let itemHeight = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
