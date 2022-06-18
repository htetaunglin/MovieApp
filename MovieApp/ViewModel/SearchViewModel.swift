//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 18/06/2022.
//

import Foundation
import RxSwift

class SearchViewModel {
    
    private let rxSearchModel = RxSearchModelImpl.shared
    
    let searchResultItems: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    private var currentPage: Int = 1
    private var totalPage: Int = 2
    
    let disposeBag: DisposeBag = DisposeBag()
    
    init(){
        
    }
    
    func handlePagination(indexPath: IndexPath, searchText: String){
        let totalItems = try! self.searchResultItems.value().count
        let isAtLastRow = indexPath.row == (totalItems - 1)
        let hasMoreMovie = self.currentPage < self.totalPage
        if isAtLastRow && hasMoreMovie {
            self.searchMovies(searchText: searchText, page: self.currentPage + 1)
        }
    }
    
    func handleSearchInput(text: String) {
        if text.isEmpty {
            self.totalPage = 1
            self.currentPage = 1
            self.searchResultItems.onNext([])
        } else {
            self.searchMovies(searchText: text, page: self.currentPage)
        }
    }
    
    func searchMovies(searchText: String, page: Int){
        rxSearchModel.searchMovie(searchText, page: page)
            .do (onNext: { response in
                self.totalPage = response.totalPages ?? 1
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
