//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 18/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    var homeItemList = BehaviorRelay<[HomeMovieSectionModel]>(value: [])
    var observablePopularMovies = BehaviorRelay<[MovieResult]>(value: [])
    var observableUpcomingMovies = BehaviorRelay<[MovieResult]>(value: [])
    var observablePopularSeries = BehaviorRelay<[MovieResult]>(value: [])
    var observableTopRelatedMovie = BehaviorRelay<[MovieResult]>(value: [])
    var observablePopularActors = BehaviorRelay<[ActorInfoResponse]>(value: [])
    var observableGenres = BehaviorRelay<[MovieGenre]>(value: [])
    
    private let disposableBag = DisposeBag()
    
    private let rxMovieModel = RxMovieModelImpl.shared
    private let rxSeriesModel = RxSeriesModelImpl.shared
    private let rxActorModel = RxActorModelImpl.shared
    private let rxGenreModel = RxGenreModelImpl.shared
    
    
    init(){
        initObserver()
    }
    
    private func initObserver(){
        Observable.combineLatest(observablePopularMovies, observableUpcomingMovies, observablePopularSeries, observableTopRelatedMovie, observablePopularActors, observableGenres)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe{
                popularMovies, upcomingMovies, popularSeries, topRelatedMovies, popularActors, genres  in
                var items = [HomeMovieSectionModel]()
                
                items.append(HomeMovieSectionModel.movieResult(items: [.upComingMovieSection(items: upcomingMovies)]))
                items.append(HomeMovieSectionModel.movieResult(items: [.popularMovieSection(items: popularMovies)]))
                items.append(HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: popularSeries)]))
                items.append(HomeMovieSectionModel.movieResult(items: [.movieShowTimeSection]))
                items.append(HomeMovieSectionModel.movieResult(items: [.showcaseMovieSection(items: topRelatedMovies)]))
                items.append(HomeMovieSectionModel.genreResult(items: [.movieGenreSection(items: genres, movies: popularMovies + upcomingMovies + topRelatedMovies + popularSeries)]))
                items.append(HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: popularActors)]))
                self.homeItemList.accept(items)
            }
            .disposed(by: disposableBag)
    }
    
    func fetchAllData(){
        fetchUpcomingMovies()
        fetchPopularMovies()
        fetchPopularSeries()
        fetchTopRelatedMovies()
        fetchPopularActors()
        fetchGenres()
    }
    
    private func fetchUpcomingMovies(){
        rxMovieModel.getUpcomingMovieList()
            .subscribe(onNext: observableUpcomingMovies.accept)
            .disposed(by: disposableBag)
    }
    
    private func fetchPopularMovies(){
        rxMovieModel.getPopularMovieList()
            .subscribe(onNext: observablePopularMovies.accept)
            .disposed(by: disposableBag)
    }
    
    private func fetchPopularSeries(){
        rxSeriesModel.getPopularSeriesList()
            .subscribe(onNext: observablePopularSeries.accept)
            .disposed(by: disposableBag)
    }
    
    private func fetchTopRelatedMovies(){
        rxMovieModel.getTopRelatedMovieList(page: 1)
            .subscribe(onNext: observableTopRelatedMovie.accept)
            .disposed(by: disposableBag)
    }
    
    
    private func fetchPopularActors(){
        rxActorModel.getHomePopularActor(page: 1)
            .subscribe(onNext: observablePopularActors.accept)
            .disposed(by: disposableBag)
    }
    
    private func fetchGenres(){
        rxGenreModel.getGenreList()
            .subscribe(onNext: observableGenres.accept)
            .disposed(by: disposableBag)
    }
    
}
