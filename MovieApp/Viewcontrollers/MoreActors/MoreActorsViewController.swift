//
//  MoreActorsViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 23/03/2022.
//

import UIKit

class MoreActorsViewController: UIViewController {

    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    var initData : ActorListResponse? {
        didSet {
            if let results = initData?.results {
                data.append(contentsOf: results)
            }
        }
    }
    private var data : [ActorInfoResponse] = []
    
    private var totalpage: Int = 1
    private var currentPage: Int = 1
    
    private let actorModel = ActorModelImpl.shared
//    private let netWorkAgent: MovieDBNetworkAgent = MovieDBNetworkAgent.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        totalpage = initData?.totalPages ?? 1
        currentPage = initData?.page ?? 1
        registerCollectionView()
        
    }
    
    private func registerCollectionView(){
        actorCollectionView.dataSource = self
        actorCollectionView.delegate = self
        actorCollectionView.registerForCell(identifier: BestActorCollectionViewCell.identifier)
    }
    
    private func fetchActors(page: Int){
        actorModel.getPopularPeople(page: page){ result in
            switch result {
            case .success(let response):
                self.currentPage = response.page
                self.totalpage = response.totalPages
                self.data.append(contentsOf: response.results ?? [])
                self.actorCollectionView.reloadData()
            case .failure(let error):
                debugPrint("Actor Error  > \(error.description)")
            }
        }
    }
}

extension MoreActorsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: BestActorCollectionViewCell.identifier, indexPath: indexPath) as BestActorCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = (collectionView.frame.width / 3) - 9
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let hasMoreActors = currentPage < totalpage
        if isAtLastRow && hasMoreActors {
            fetchActors(page: currentPage + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let actorId = data[indexPath.row].id {
            navigateToActorDetail(actorId: actorId)
        }
    }
}
