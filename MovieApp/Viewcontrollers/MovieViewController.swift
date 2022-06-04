//
//  ViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 09/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MovieViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableViewMovie: UITableView!
    
    // MARK: - Property
    private let movieModel = MovieModelImpl.shared
    private let seriesModel = SeriesModelImpl.shared
    private let actorModel = ActorModelImpl.shared
    private let genreModel = GenreModelImpl.shared
    
    // MARK: - Rx Property
    private let rxMovieModel = RxMovieModelImpl.shared
    
    
    private var upComingMovieList: [MovieResult]?
    private var popularMovieList: [MovieResult]?
    private var popularSeriesList: [MovieResult]?
    private var topRelatedMovieList: MovieListResponse?
    private var movieGenreList: [MovieGenre]?
    private var popularPeople: ActorListResponse?
    
    let disposeBag = DisposeBag()
    
    let observableUpcomingMovies = RxMovieModelImpl.shared.getUpcomingMovieList()
    let observablePopularMovies = RxMovieModelImpl.shared.getPopularMovieList()
    let observablePopularSeries = RxSeriesModelImpl.shared.getPopularSeriesList()
    let observableTopRelateMovies = RxMovieModelImpl.shared.getTopRelatedMovieList(page: 1)
    let observablePopularActors = RxActorModelImpl.shared.getPopularActor(page: 1)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        //        fetchUpcomingMovieList() ✅
        //        fetchPopularMovieList() ✅
        //        fetchPopularSeriesList() ✅
        //        fetchMovieGenreList()
        //        fetchTopRelatedMovieList() <- Show case ✅
        //        fetchPopularPeople() ✅
        navigationItem.backButtonTitle = ""
        
        let dataSource = initDataSource()
        Observable.combineLatest(observableUpcomingMovies, observablePopularMovies,observablePopularSeries,observableTopRelateMovies, observablePopularActors)
            .flatMap{ (upComingMovies, popularMovies, popularSeries, topRelatedMovies, popularActors) -> Observable<[HomeMovieSectionModel]> in
                    .just([
                        HomeMovieSectionModel.movieResult(items: [.upComingMovieSection(items: upComingMovies)]),
                        HomeMovieSectionModel.movieResult(items: [.popularMovieSection(items: popularMovies)]),
                        HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: popularSeries)]),
                        HomeMovieSectionModel.movieResult(items: [.movieShowTimeSection]),
                        HomeMovieSectionModel.movieResult(items: [.showcaseMovieSection(items: topRelatedMovies)]),
                        HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: popularActors)])
                    ])
            }.bind(to: tableViewMovie.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        navigateToSearchViewController()
    }
    
    // MARK: - Init View
    private func registerTableViewCell(){
        //        tableViewMovie.dataSource = self
        tableViewMovie.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    // MARK: - DataSource
    private func initDataSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>{
        return RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init { dataSource, tableView, indexPath, item in
            switch item {
            case .upComingMovieSection(let items):
                let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
                cell.data = items
                return cell
            case .popularMovieSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.labelTitle.text = "popular movies".uppercased()
                cell.isTVSeries = false
                cell.delegate = self
                cell.data = items
                return cell
            case .popularSeriesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.labelTitle.text = "popular series".uppercased()
                cell.isTVSeries = true
                cell.delegate = self
                cell.data = items
                return cell
            case .movieShowTimeSection:
                return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
//            case .movieGenreSection(let items):
//                let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
//                var list : [MovieResult] = [MovieResult]()
//                list += upComingMovieList ?? []
//                list += popularMovieList ?? []
//                list += popularSeriesList ?? []
//                list += topRelatedMovieList?.results ?? []
//                cell.allMovieAndSeries = list
//                let genreVos = items?.map{ $0.convertToGenreVo() }
//                genreVos?.first?.isSelected = true
//                cell.genreList = genreVos
//                cell.delegate = self
//                return cell
            case .showcaseMovieSection(let items):
                let cell =  tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
                cell.data = items
                cell.moreShowCaseDelegate = self
                cell.movieItemDelegate = self
                return cell
            case .bestActorSection(let items):
                let cell =  tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
                cell.data = items
                cell.actorDelegate = self
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case MoveType.MOVIE_SLIDER.rawValue :
            let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
            cell.delegate = self
            cell.data = upComingMovieList
            return cell
        case MoveType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.labelTitle.text = "popular movies".uppercased()
            cell.isTVSeries = false
            cell.delegate = self
            cell.data = popularMovieList
            return cell
        case MoveType.SERIES_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.labelTitle.text = "popular series".uppercased()
            cell.isTVSeries = true
            cell.delegate = self
            cell.data = popularSeriesList
            return cell
        case MoveType.MOVIE_SHOWTIME.rawValue:
            return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
        case MoveType.MOVIE_GNERE.rawValue:
            let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
            var list : [MovieResult] = [MovieResult]()
            list += upComingMovieList ?? []
            list += popularMovieList ?? []
            list += popularSeriesList ?? []
            list += topRelatedMovieList?.results ?? []
            cell.allMovieAndSeries = list
            let genreVos = movieGenreList?.map{ $0.convertToGenreVo() }
            genreVos?.first?.isSelected = true
            cell.genreList = genreVos
            cell.delegate = self
            return cell
        case MoveType.MOVIE_SHOWCASE.rawValue:
            let cell =  tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
            cell.data = topRelatedMovieList?.results ?? []
            cell.moreShowCaseDelegate = self
            cell.movieItemDelegate = self
            return cell
        case MoveType.MOVIE_BESTACTOR.rawValue:
            let cell =  tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
            cell.data = popularPeople
            cell.actorDelegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Delegates
extension MovieViewController: MovieItemDelegate {
    func onTapMovie(id: Int) {
        navigateToFilmDetailViewController(movieId: id, isTVSeries: false)
    }
    
    func onTapTVSeries(id: Int) {
        navigateToFilmDetailViewController(movieId: id, isTVSeries: true)
    }
}

extension MovieViewController: ActorDelegate {
    func onTapMoreActors() {
        navigateToMoreActorsViewController(initData: popularPeople)
    }
    
    func onTapActor(_ id: Int) {
        navigateToActorDetail(actorId: id)
    }
}

extension MovieViewController: MoreShowCaseDelegate{
    func onTapMoreShowCase() {
        navigateToMoreShowCaseViewController(initData: topRelatedMovieList)
    }
}

