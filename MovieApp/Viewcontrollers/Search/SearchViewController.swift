//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 24/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var collectionViewMovies: UICollectionView!
    
    private let searchBar: UISearchBar = UISearchBar()
    
    private let searchViewModel: SearchViewModel = SearchViewModel()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        initSearchBar()
        initObserver()
    }
    
    private func initObserver(){
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addPaginationObserver()
        addItemSelectedObserver()
    }
    
    private func initSearchBar(){
        searchBar.placeholder = "Search..."
        searchBar.searchTextField.textColor = UIColor.white
        navigationItem.titleView = searchBar
    }
    
    private func registerCollectionView(){
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    private func rxSearchMovie(searchText: String?, page: Int = 1) {
        searchViewModel.searchMovies(searchText: searchText ?? "", page: page)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = (collectionView.frame.width / 3) - 9
        let itemHeight : CGFloat = itemWidth * 1.8
        return CGSize(width: itemWidth, height: itemHeight)
    }
}


extension SearchViewController {
    private func addSearchBarObserver() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { print($0) })
            .subscribe (onNext: searchViewModel.handleSearchInput)
            .disposed(by: disposeBag)
    }
    
    private func addCollectionViewBindingObserver() {
        searchViewModel.searchResultItems.bind(to: collectionViewMovies.rx
                .items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self)){ (row, element, cell) in
                    cell.data = element
                }.disposed(by: disposeBag)
    }
    
    private func addPaginationObserver(){
        Observable.combineLatest(collectionViewMovies.rx
            .willDisplayCell, searchBar.rx.text.orEmpty)
        .subscribe(onNext:{[weak self] (cellTuple, searchText) in
            self?.searchViewModel.handlePagination(indexPath: cellTuple.at, searchText: searchText)
        }).disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver(){
        collectionViewMovies.rx.itemSelected.subscribe(onNext: { indexPath in
            let items = try! self.searchViewModel.searchResultItems.value()
            if let movieId = items[indexPath.row].id {
                self.navigateToFilmDetailViewController(movieId: movieId, isTVSeries: false)
            }
        }).disposed(by: disposeBag)
    }
}
