//
//  BestActorTableViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class BestActorTableViewCell: UITableViewCell, ActorActionDelegate {
    

    @IBOutlet weak var lblMoreActors: UILabel!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    
    var data : ActorListResponse? {
        didSet{
            if let _ = data {
                collectionViewActors.reloadData()
            }
        }
    }
    
    weak var actorDelegate: ActorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreActors.underlineText()
        registerCollectionView()
        addGestureRecognizer()
    }
    
    private func registerCollectionView(){
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: BestActorCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTapFavorite(isFavorite: Bool) {
        debugPrint("is Favoriate => \(isFavorite)")
    }
    
    func addGestureRecognizer(){
        let moreActorTestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapMoreActors))
        lblMoreActors.isUserInteractionEnabled = true
        lblMoreActors.addGestureRecognizer(moreActorTestureRecognizer)
    }
    
    @objc func onTapMoreActors(){
        self.actorDelegate?.onTapMoreActors()
    }
    
}


extension BestActorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: BestActorCollectionViewCell.identifier, indexPath: indexPath) as BestActorCollectionViewCell
        cell.delegate = self
        cell.data = data?.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = 120
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = data?.results?[indexPath.row].id {
            actorDelegate?.onTapActor(id)
        }
    }
}
