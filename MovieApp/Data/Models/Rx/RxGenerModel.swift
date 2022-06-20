//
//  RxGenerModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 20/06/2022.
//

import Foundation
import RxSwift

protocol RxGenreModel {
    func getGenreList() -> Observable<[MovieGenre]>
}

class RxGenreModelImpl: BaseModel, RxGenreModel {
    
    static let shared: RxGenreModel = RxGenreModelImpl()
    private override init(){}
    
    let disposeBag = DisposeBag()
    
    private let genreRepo: GenreRepository = GenreRepositoryImpl.shared
    private let rxGenreRepo: RxGenreRepository = RxGenreRepositoryImpl.shared
    
    func getGenreList() -> Observable<[MovieGenre]> {
        rxNetworkAgent.getGenreList()
            .subscribe(onNext: genreRepo.save)
            .disposed(by: disposeBag)
        return rxGenreRepo.getAll()
    }
    
}
