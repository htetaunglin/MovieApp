//
//  RxMoreMovieModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 19/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MoreShowcaseViewModel {
    
    private let rxMovieModel = RxMovieModelImpl.shared
    private var disposeBag = DisposeBag()
    
    let obserableMovies: BehaviorRelay<[MovieResult]> = BehaviorRelay(value: [])
    
//    private var currentPage: Int = 1
//    private var totalPage: Int = 1
    
    init(){
        subscribeTopRelatedMovies()
    }
    
    func subscribeTopRelatedMovies(){
        rxMovieModel.subscribeTopRelatedMovies()
            .subscribe(onNext: obserableMovies.accept)
            .disposed(by: disposeBag)
    }
    
    func fetchTopRelatedMovie(page: Int){
        rxMovieModel.getTopRelatedMovieList(page: page)
    }
    
    func handlePagination(indexPath: IndexPath){
        let totalItems = obserableMovies.value.count
        let isAtLastRow = indexPath.row == (totalItems - 1)
//        let isAtLastRow = indexPath.row == (obserableMovies.value.count - 1)
//        let hasMoreMovie = currentPage < totalPage
        if isAtLastRow {
            let page = (totalItems / 20) + 1
            fetchTopRelatedMovie(page: page)
        }
    }
}
