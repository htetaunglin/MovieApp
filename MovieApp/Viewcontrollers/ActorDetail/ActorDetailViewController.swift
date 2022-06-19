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
    var id: Int?
    
    final let disposeBag = DisposeBag()
    
    var viewModel: ActorDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addGesture()
        registerCollectionView()
        if let id = id {
            viewModel = ActorDetailViewModel(id)
            subscribeActor()
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
        collectionViewMovieCredit.delegate = self
        collectionViewMovieCredit.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        
        collectionViewTVCredit.delegate = self
        collectionViewTVCredit.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    // MARK: Read More
    @IBAction func btnReadMore(_ sender: Any) {
        let google = "https://www.google.com/search?q="
        let actorName: String = viewModel?.actor.value?.name ?? ""
        if let url = URL(string: google + (actorName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    // MARK: Reactive Subscription
    private func subscribeActor(){
        viewModel?.actor
            .compactMap{ $0 }
            .subscribe(onNext: {[weak self] detailResponse in
                self?.bindData(detailResponse)
            })
            .disposed(by: disposeBag)
      
        
        // Movie
        viewModel?.movieBehaviorSubject
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
            if let movieId = self.viewModel?.movieBehaviorSubject.value[indexPath.row].id {
                self.navigateToFilmDetailViewController(movieId: movieId, isTVSeries: false)
            }
        })
        .disposed(by: disposeBag)
        
        // Series
        viewModel?.tvBehaviorSubject
            .do(onNext: {[weak self] series in
                self?.tvCreditView.isHidden = series.isEmpty
            })
            .bind(to: collectionViewTVCredit.rx
                .items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self)){ row, element, cell in
                    cell.data = element
            }
            .disposed(by: disposeBag)
        
        collectionViewTVCredit.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            if let movieId = self.viewModel?.tvBehaviorSubject.value[indexPath.row].id {
                self.navigateToFilmDetailViewController(movieId: movieId, isTVSeries: true)
            }
        })
        .disposed(by: disposeBag)
    }
}

// MARK: CollectionViewX
extension ActorDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.frame.height)
    }
}
