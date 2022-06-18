//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 18/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    
    let filmDetailPublishSubject: PublishSubject<FilmDetailVo> = PublishSubject()
    let actorsBehaviorSubject: BehaviorRelay<[ActorInfoResponse]> = BehaviorRelay(value: [])
    let similarMovieBehaviorSubject: BehaviorRelay<[MovieResult]> = BehaviorRelay(value: [])
    let movieTrailers: BehaviorRelay<[Trailer]> = BehaviorRelay(value: [])
    
    private let rxMovieDetailModel = RxMovieDetailModelImpl.shared
    private let rxTVSeriesDetailModel = RxSeriesDetailModelImpl.shared
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(filmId: Int, isTVSeries: Bool){
        fetchMovieById(filmId, isTVSeries: isTVSeries)
        fetchSimilarMovies(filmId)
        fetchActorsByMovies(filmId)
        fetchTrailers(filmId, isTVSeries: isTVSeries)
    }
    
    private func fetchMovieById(_ filmId: Int, isTVSeries: Bool){
        let observable = (isTVSeries ? rxTVSeriesDetailModel.fetchSeriesDetailById(filmId) : rxMovieDetailModel.fetchMovieDetailById(filmId))
        observable
            .map{ $0.toFilmDetailVo() }
            .subscribe(onNext: { vo in
                print("Film Detail Vo \(vo.productions?.count ?? 0)")
                self.filmDetailPublishSubject.onNext(vo)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchSimilarMovies(_ filmId: Int){
        rxMovieDetailModel.fetchMovieSimilar(filmId)
            .subscribe(onNext: similarMovieBehaviorSubject.accept)
            .disposed(by: disposeBag)
    }
    
    private func fetchActorsByMovies(_ filmId: Int){
        rxMovieDetailModel.fetchMovieCreditByMovieId(filmId)
            .subscribe(onNext: actorsBehaviorSubject.accept)
            .disposed(by: disposeBag)
    }
    
    private func fetchTrailers(_ filmId: Int, isTVSeries: Bool){
        let observable = isTVSeries ? rxTVSeriesDetailModel.fetchSeriesTrailerVideo(filmId) :rxMovieDetailModel.fetchMovieTrailerVideo(filmId)
        observable
            .map{ $0.results }
            .compactMap{ $0 }
            .subscribe(onNext: movieTrailers.accept)
            .disposed(by: disposeBag)
    }
}
