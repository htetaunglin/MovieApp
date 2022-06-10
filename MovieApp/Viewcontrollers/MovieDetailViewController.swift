//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 13/02/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController, MovieItemDelegate{
    
    // For test memory leak
    // private var objects = Array.init(repeating: "Hello", count: 10000000)
    
    // MARK: - @IBOutlet
    @IBOutlet weak var collectionViewProduction: UICollectionView!
    
    @IBOutlet weak var collectionViewSimilarMovie: UICollectionView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblShowMore: UILabel!
    
    @IBOutlet weak var ivMoviePoster: UIImageView!
    @IBOutlet weak var lblReleaseYear: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var lblVoteAverage: UILabel!
    @IBOutlet weak var ratingStars: RatingControl!
    
    @IBOutlet weak var lblStoryLineOverview: UILabel!
    
    @IBOutlet weak var lblOriginalTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblProduction: UILabel!
    @IBOutlet weak var lblPremiere: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var buttonPlayTrailer: UIButton!
    
    @IBOutlet weak var viewProduction: UIView!
    @IBOutlet weak var viewActor: UIView!
    @IBOutlet weak var viewSimilarMovie: UIView!
    
    final let disposeBag = DisposeBag()
    
    // MARK: - Properties
    private let movieDetailModel = MovieDetailModelImpl.shared
    private let seriesDetailModel = SeriesDetailModelImpl.shared
    
    private let rxMovieDetailModel = RxMovieDetailModelImpl.shared
        
    let filmDetailPublishSubject: PublishSubject<FilmDetailVo> = PublishSubject()
    
    var isTVSeries: Bool = false
    var filmId: Int = -1
    
    private var productionCompanies: [ProductionCompany]?
    private var movieCasts: [ActorInfoResponse]?
    private var similarMovies: [MovieResult]?
    private var movieTrailers: [Trailer]?
    
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        registerCollectionViewCells()
        // Subscribe
        subscribeFilmVo()
        subscribeMovie()
        subscribeMovieCredit()
        if isTVSeries {
            fetchTVSeriesDetail(id: filmId)
        } else {
            rxMovieDetailModel.fetchMovieDetailById(filmId)
        }
        rxMovieDetailModel.fetchMovieCreditByMovieId(filmId)
        fetchSimilarMovie(id: filmId)
        if isTVSeries {
            fetchTVTrailers(id: filmId)
        } else {
            fetchMovieTrailers(id: filmId)
        }
    }
    
    private func subscribeMovie(){
        if isTVSeries {
            //TODO TVSeries
        } else {
            RxMovieDetailModelImpl.shared.subscribeMovieDetailById(filmId)
                .map{ $0.toFilmDetailVo() }
                .subscribe(onNext: filmDetailPublishSubject.onNext)
                .disposed(by: disposeBag)
        }
    }
    
    private func subscribeMovieCredit() {
        RxMovieDetailModelImpl.shared.subscribeMovieCreditById(filmId)
            .do(onNext: { actors in self.viewActor.isHidden = actors.isEmpty })
            .bind(to: collectionViewActors.rx.items(cellIdentifier: BestActorCollectionViewCell.identifier, cellType: BestActorCollectionViewCell.self)){ row, elements, cell in cell.data = elements }
            .disposed(by: disposeBag)
    }
    
    
    private func subscribeFilmVo(){
        filmDetailPublishSubject
            .subscribe(onNext: bindData)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Init View
    private func initView(){
        btnRateMovie.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 255)
        btnRateMovie.layer.borderWidth = 2
        viewProduction.isHidden = true
        viewActor.isHidden = true
        viewSimilarMovie.isHidden = true
        lblShowMore.underlineText()
        addGesture()
    }
    
    private func addGesture(){
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(onTapShowMore))
        lblShowMore.isUserInteractionEnabled = true
        lblShowMore.addGestureRecognizer(tapGest)
    }
    
    @objc func onTapShowMore(){
        if lblStoryLineOverview.numberOfLines == 2 {
            lblStoryLineOverview.numberOfLines = 0
            lblShowMore.text = "show less"
        } else {
            lblStoryLineOverview.numberOfLines = 2
            lblShowMore.text = "show more"
        }
    }
    
    
    // MARK: - Register Collection View
    private func registerCollectionViewCells(){
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: BestActorCollectionViewCell.identifier)
        
        collectionViewProduction.dataSource = self
        collectionViewProduction.delegate = self
        collectionViewProduction.registerForCell(identifier: ProductionCollectionViewCell.identifier)
        
        collectionViewSimilarMovie.dataSource = self
        collectionViewSimilarMovie.delegate = self
        collectionViewSimilarMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    func onTapMovie(id: Int) {
        navigateToFilmDetailViewController(movieId: id, isTVSeries: false)
    }
    
    func onTapTVSeries(id: Int) {
        navigateToFilmDetailViewController(movieId: id, isTVSeries: true)
    }
    
    // MARK: - @IBAction
    @IBAction func onClickPlayTrailer(_ sender: Any) {
        let youtubeId = movieTrailers?.first?.key
        print(youtubeId ?? "NO KEY")
        //        let ytURL = "https://www.youtube.com/watch?v=\(youtubeVideoKey)"
        let playerVC = YoutubePlayerViewController()
        playerVC.youtubeId = youtubeId
        self.present(playerVC, animated: true, completion: nil)
    }
    
    private func bindData(_ data: FilmDetailVo){
        let profilePath = "\(originalImageUrl)/\(data.backdropPath ?? "")"
        ivMoviePoster.sd_setImage(with: URL(string: profilePath))
        lblReleaseYear.text = data.releaseYear
        lblTitle.text = data.title
        self.navigationItem.title = data.title
        
        let runTimeHour = Int(data.duration ?? 0) / 60
        let runTimeMinutes = (data.duration ?? 0) % 60
        lblDuration.text = "\(runTimeHour) hr \(runTimeMinutes) min"
        
        lblVoteCount.text = "\(data.voteCount ?? 0) votes".uppercased()
        lblVoteAverage.text = "\(data.voteAverage ?? 0)"
        ratingStars.rating = Int((data.voteAverage ?? 0) * 0.5)
        
        lblStoryLineOverview.text = data.storyLines
        
        lblOriginalTitle.text = data.originalTitle
        lblGenre.text = data.genres?.map { $0.name }.joined(separator: ", ")
        lblProduction.text = data.productions?.map{ $0.name ?? "" }.joined(separator: ", ")
        lblPremiere.text = data.releaseDate
        lblDescription.text = data.description
    }
    
    // MARK: - API Methods
    private func fetchTVSeriesDetail(id: Int){
        seriesDetailModel.getTVSeriesDetailById(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.bindData(data.toFilmDetailVo())
                self.viewProduction.isHidden = data.productionCompanies?.isEmpty ?? true
                self.productionCompanies = data.productionCompanies
                self.collectionViewProduction.reloadData()
            case .failure(let error):
                debugPrint("TV Series \(id) Detail Error  > \(error.description)")
            }
        }
    }
    
    private func fetchMovieCredit(id: Int){
        rxMovieDetailModel.fetchMovieCreditByMovieId(id)
//        movieDetailModel.getMovieCreditByMovieId(id) { [weak self] result in
//            guard let self = self else { return }
//            switch result{
//            case .success(let list):
//                debugPrint(list.count)
//                self.viewActor.isHidden = list.isEmpty
//                self.movieCasts = list
//                self.collectionViewActors.reloadData()
//            case .failure(let error):
//                debugPrint("Movie \(id) Credit Error  > \(error.description)")
//            }
//        }
    }
    
    private func fetchSimilarMovie(id: Int){
        movieDetailModel.getMovieSimilar(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.viewSimilarMovie.isHidden = data.isEmpty
                self.similarMovies = data
                self.collectionViewSimilarMovie.reloadData()
            case .failure(let error):
                debugPrint("Similar Movie \(id) Error  > \(error.description)")
            }
        }
    }
    
    private func fetchMovieTrailers(id: Int){
        movieDetailModel.getMovieTrailerVideo(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.movieTrailers = data.results
                self.buttonPlayTrailer.isHidden = data.results?.isEmpty ?? true
            case .failure(let error):
                debugPrint("Movie Trailer \(id) Error  > \(error.description)")
            }
        }
    }
    
    private func fetchTVTrailers(id: Int){
        seriesDetailModel.getTVTrailerVideo(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.movieTrailers = data.results
                self.buttonPlayTrailer.isHidden = data.results?.isEmpty ?? true
            case .failure(let error):
                debugPrint("Movie Trailer \(id) Error  > \(error.description)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewProduction {
            return productionCompanies?.count ?? 0
        } else if collectionView == collectionViewActors {
            return movieCasts?.count ?? 0
        } else if collectionView == collectionViewSimilarMovie {
            return similarMovies?.count ?? 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewActors:
            let cell = collectionView.dequeueCell(identifier: BestActorCollectionViewCell.identifier, indexPath: indexPath) as BestActorCollectionViewCell
            cell.data = movieCasts?[indexPath.row]
            return cell
        case collectionViewProduction:
            let cell = collectionView.dequeueCell(identifier: ProductionCollectionViewCell.identifier, indexPath: indexPath) as ProductionCollectionViewCell
            cell.data = productionCompanies?[indexPath.row]
            return cell
        case collectionViewSimilarMovie:
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = similarMovies?[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProduction {
            let itemWidth : CGFloat = collectionView.frame.height
            let itemHeight : CGFloat = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
        }else if collectionView == collectionViewActors {
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        }else if collectionView == collectionViewSimilarMovie {
            return CGSize(width: 120, height: collectionView.frame.height)
        }
        return CGSize(width: CGFloat(collectionView.frame.width/2.5), height: CGFloat(200))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSimilarMovie {
            if let movieId = similarMovies?[indexPath.row].id {
                onTapMovie(id: movieId)
            }
        } else if collectionView == collectionViewActors {
            if let actorId = movieCasts?[indexPath.row].id {
                navigateToActorDetail(actorId: actorId)
            }
        }
    }
}
