//
//  ViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 09/02/2022.
//

import UIKit
import RxSwift

class MovieViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableViewMovie: UITableView!
    
    // MARK: - Property
    private let movieModel = MovieModelImpl.shared
    private let seriesModel = SeriesModelImpl.shared
    private let actorModel = ActorModelImpl.shared
    private let genreModel = GenreModelImpl.shared
    
    // MARK: - Rx Property
    private let movieRxModel = RxMovieModelImpl.shared
    
    
    private var upComingMovieList: [MovieResult]?
    private var popularMovieList: [MovieResult]?
    private var popularSeriesList: [MovieResult]?
    private var topRelatedMovieList: MovieListResponse?
    private var movieGenreList: [MovieGenre]?
    private var popularPeople: ActorListResponse?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        fetchUpcomingMovieList()
        fetchPopularMovieList()
        fetchPopularSeriesList()
        fetchMovieGenreList()
        fetchTopRelatedMovieList()
        fetchPopularPeople()
        navigationItem.backButtonTitle = ""
    }

    @IBAction func onClickSearch(_ sender: Any) {
        navigateToSearchViewController()
    }
    
    // MARK: - Init View
    private func registerTableViewCell(){
        tableViewMovie.dataSource = self
        tableViewMovie.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovie.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    // MARK: - API Methods
    func fetchUpcomingMovieList(){
        movieModel.getUpcomingMovieList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.upComingMovieList = data
                self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.MOVIE_SLIDER.rawValue), with: .automatic)
            case .failure(let error):
                debugPrint("Upcoming Movie Error > \(error.description)")
            }   
        }
    }
    
    let disposeBag = DisposeBag()
    func fetchPopularMovieList(){
        movieRxModel.getPopularMovieList().subscribe { data in
            self.popularMovieList = data
            self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.MOVIE_POPULAR.rawValue), with: .automatic)
        } onError: { error in
            debugPrint("Pouplar Movie Error  > \(error)")
        }.disposed(by: disposeBag)

//        movieModel.getPopularMovieList { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let data):
//                self.popularMovieList = data
//                self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.MOVIE_POPULAR.rawValue), with: .automatic)
//            case .failure(let error):
//                debugPrint("Pouplar Movie Error  > \(error.description)")
//            }
//        }
    }
    
    func fetchPopularSeriesList(){
        seriesModel.getPopularSeriesList { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let data):
                self.popularSeriesList = data
                self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.SERIES_POPULAR.rawValue), with: .automatic)
            case .failure(let error):
                debugPrint("Pouplar Series Error  > \(error.description)")
            }
        }
    }
    
    func fetchMovieGenreList(){
        genreModel.getGenreList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data) :
                self.movieGenreList = data
                self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.MOVIE_GNERE.rawValue), with: .automatic)
            case .failure(let error) :
                debugPrint("Movie Genre Error  > \(error.description)")
            }
            
        }
    }
    
    func fetchTopRelatedMovieList(){
        movieModel.getTopRelatedMoveiList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.topRelatedMovieList = data
                self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.MOVIE_SHOWCASE.rawValue), with: .automatic)
            case .failure(let error):
                debugPrint("Movie ShowCase (Top Related) Error  > \(error.description)")
            }
        }
    }
    
    func fetchPopularPeople(){
        actorModel.getPopularPeople { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.popularPeople = data
                self.tableViewMovie.reloadSections(IndexSet(integer: MoveType.MOVIE_BESTACTOR.rawValue), with: .automatic)
            case .failure(let error):
                debugPrint("Movie Base Actor Error  > \(error.description)")
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
            cell.data = topRelatedMovieList
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

