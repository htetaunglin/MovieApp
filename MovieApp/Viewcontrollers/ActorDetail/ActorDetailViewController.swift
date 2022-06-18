//
//  ActorDetailViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 26/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ActorDetailViewController: UIViewController {
    
    // For test memory leak
    // private var objects = Array.init(repeating: "Hello", count: 10000000)

    // MARK: @IBOutlet
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBathDate: UILabel!
    @IBOutlet weak var lblBiography: UILabel!
    @IBOutlet weak var collectionViewMovieCredit: UICollectionView!
    @IBOutlet weak var collectionViewTVCredit: UICollectionView!
    @IBOutlet weak var movieCreditView: UIView!
    @IBOutlet weak var tvCreditView: UIView!
    @IBOutlet weak var viewBirthdate: UIView!
    @IBOutlet weak var lblShowMore: UILabel!
    
    // MARK: Property
    private var actorDetailModel = ActorDetailModelImpl.shared
    private let rxActorDetailModel = RxActorDetailModelImpl.shared
    
    var id: Int?
    
    private var movies: [MovieResult] = []
    private var tvSeries: [MovieResult] = []
    private var actorDetail: ActorDetailResponse?
    
    let movieBehaviorSubject: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    let tvBehaviorSubject: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    final let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addGesture()
        registerCollectionView()
        if let id = id {
//            fetchActorDetail(id)
            subscribeActorDetail(id)
            fetchActorMovieCredit(id)
            fetchActorTVCredit(id)
        }
    }
    
    private func initView(){
        viewBirthdate.isHidden = true
        movieCreditView.isHidden = true
        tvCreditView.isHidden = true
        lblShowMore.underlineText()
    }
    
    private func addGesture(){
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(onTapShowMore))
        lblShowMore.isUserInteractionEnabled = true
        lblShowMore.addGestureRecognizer(tapGest)
    }
    
    @objc func onTapShowMore(){
        if lblBiography.numberOfLines == 2 {
            lblBiography.numberOfLines = 0
            lblShowMore.text = "show less"
        } else {
            lblBiography.numberOfLines = 2
            lblShowMore.text = "show more"
        }
    }
    
    // MARK: Data Bind
    private func bindData(_ actor: ActorDetailResponse){
        let profilePath = "\(originalImageUrl)/\(actor.profilePath ?? "")"
        ivImage.sd_setImage(with: URL(string: profilePath))
        lblName.text = actor.name ?? ""
        lblBathDate.text = actor.birthday ?? ""
        lblBiography.text = actor.biography ?? ""
        viewBirthdate.isHidden = actor.birthday?.isEmpty ?? true
    }
    
    // MARK: Register Collection view
    private func registerCollectionView(){
        collectionViewMovieCredit.dataSource = self
        collectionViewMovieCredit.delegate = self
        collectionViewMovieCredit.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        
        collectionViewTVCredit.dataSource = self
        collectionViewTVCredit.delegate = self
        collectionViewTVCredit.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    // MARK: Read More
    @IBAction func btnReadMore(_ sender: Any) {
        let google = "https://www.google.com/search?q="
        let actorName: String = actorDetail?.name ?? ""
        if let url = URL(string: google + (actorName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    // MARK: Reactive Subscription
    private func subscribeActorDetail(_ id: Int){
        rxActorDetailModel.getActorDetail(id)
            .subscribe(onNext:{[weak self] detailResponse in
                self?.actorDetail = detailResponse
                self?.bindData(detailResponse)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeActorMovieCredit(_ id: Int){
        rxActorDetailModel.getActorMovieCredit(id)
            .subscribe(onNext: movieBehaviorSubject.onNext)
            .disposed(by: disposeBag)

        movieBehaviorSubject
            .do(onNext: {[weak self] movies in
                self?.movieCreditView.isHidden = movies.isEmpty
            })
            .bind(to: collectionViewMovieCredit.rx
                .items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self)){ row, element, cell in
                    cell.data = element
            }
            .disposed(by: disposeBag)

        collectionViewMovieCredit.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            if let actorId = (try! self.movieBehaviorSubject.value())[indexPath.row].id {
                self.navigateToActorDetail(actorId: actorId)
            }
        })
        .disposed(by: disposeBag)
    }
    
    
    private func subscribeActorTVCredit(_ id: Int){
        rxActorDetailModel.getActorTVCredit(id)
            .subscribe(onNext: tvBehaviorSubject.onNext)
            .disposed(by: disposeBag)

        tvBehaviorSubject
            .do(onNext: {[weak self] movies in
                self?.tvCreditView.isHidden = movies.isEmpty
            })
            .bind(to: collectionViewTVCredit.rx
                .items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self)){ row, element, cell in
                    cell.data = element
            }
            .disposed(by: disposeBag)

        collectionViewTVCredit.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            if let actorId = (try! self.tvBehaviorSubject.value())[indexPath.row].id {
                self.navigateToActorDetail(actorId: actorId)
            }
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: Request API
    private func fetchActorDetail(_ id: Int){
        actorDetailModel.getActorDetail(id){[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let detailResponse):
                self.actorDetail = detailResponse
                self.bindData(detailResponse)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func fetchActorMovieCredit(_ id: Int){
        actorDetailModel.getActorMovieCredit(id){[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let actorMovieCredits):
                self.movieCreditView.isHidden = actorMovieCredits.isEmpty
                self.movies = actorMovieCredits
                self.collectionViewMovieCredit.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func fetchActorTVCredit(_ id: Int){
        actorDetailModel.getActorTVCredit(id){[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let actorTVCredits):
                self.tvCreditView.isHidden = actorTVCredits.isEmpty
                self.tvSeries = actorTVCredits
                print(self.tvSeries.count)
                print(actorTVCredits.count)
                self.collectionViewTVCredit.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

// MARK: CollectionViewX
extension ActorDetailViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMovieCredit {
            return movies.count
        } else if collectionView == collectionViewTVCredit {
            return tvSeries.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMovieCredit {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = movies[indexPath.row]
            return cell
        } else if collectionView == collectionViewTVCredit {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = tvSeries[indexPath.row]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewMovieCredit {
            navigateToFilmDetailViewController(movieId: movies[indexPath.row].id ?? 0, isTVSeries: false)
        } else if collectionView == collectionViewTVCredit {
            navigateToFilmDetailViewController(movieId: tvSeries[indexPath.row].id ?? 0, isTVSeries: true)
        }
    }
}
