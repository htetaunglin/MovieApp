//
//  ActorDetailViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 26/03/2022.
//

import UIKit

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
    
    var id: Int?
    
    private var movies: [ActorMovieCredit] = []
    private var tvSeries: [ActorTVCredit] = []
    private var actorDetail: ActorDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addGesture()
        registerCollectionView()
        if let id = id {
            fetchActorDetail(id)
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
                self.movieCreditView.isHidden = actorMovieCredits.cast?.isEmpty ?? true
                self.movies = actorMovieCredits.cast ?? []
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
                self.tvCreditView.isHidden = actorTVCredits.cast?.isEmpty ?? true
                self.tvSeries = actorTVCredits.cast ?? []
                print(self.tvSeries.count)
                print(actorTVCredits.cast?.count ?? 0)
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
            cell.data = movies[indexPath.row].toMovieResult()
            return cell
        } else if collectionView == collectionViewTVCredit {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = tvSeries[indexPath.row].toMovieResult()
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
