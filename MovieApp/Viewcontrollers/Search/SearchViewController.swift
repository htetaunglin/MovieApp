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
    
    private let rxSearchModel = RxSearchModelImpl.shared
    
    private var data: [MovieResult] = []
    private var currentPage: Int = 1
    private var totalPage: Int = 2
    
    let disposeBag: DisposeBag = DisposeBag()
    
    let searchResultItems: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    
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
        rxSearchModel.searchMovie(searchText ?? "", page: page)
            .do (onNext: { response in
                self.totalPage = response.totalPages ?? self.totalPage
            })
            .compactMap{ $0.results }
            .subscribe(onNext: { item in
                if page == 1 {
                    self.searchResultItems.onNext(item)
                } else {
                    self.searchResultItems.onNext(try! self.searchResultItems.value() + item)
                }
            })
            .disposed(by: disposeBag)

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
//            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { print($0) })
            .subscribe (onNext: { value in
                if value.isEmpty {
                    self.totalPage = 1
                    self.currentPage = 1
                    self.searchResultItems.onNext([])
                } else {
                    self.rxSearchMovie(searchText: value, page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addCollectionViewBindingObserver() {
        searchResultItems.bind(to: collectionViewMovies.rx
                .items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self)){ (row, element, cell) in
                    cell.data = element
                }.disposed(by: disposeBag)
    }
    
    private func addPaginationObserver(){
        Observable.combineLatest(collectionViewMovies.rx
            .willDisplayCell, searchBar.rx.text.orEmpty)
        .subscribe(onNext:{ (cellTuple, searchText) in
            let totalItems = try! self.searchResultItems.value().count
            let isAtLastRow = cellTuple.at.row == (totalItems - 1)
            let hasMoreMovie = self.currentPage < self.totalPage
            if isAtLastRow && hasMoreMovie {
                self.rxSearchMovie(searchText: searchText, page: self.currentPage + 1)
            }
        }).disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver(){
        collectionViewMovies.rx.itemSelected.subscribe(onNext: { indexPath in
            let items = try! self.searchResultItems.value()
            if let movieId = items[indexPath.row].id {
                self.navigateToFilmDetailViewController(movieId: movieId, isTVSeries: false)
            }
        }).disposed(by: disposeBag)
    }
}
