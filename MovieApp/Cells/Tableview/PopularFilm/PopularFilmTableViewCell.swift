//
//  PopularFilmTableViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionViewPopularMovie: UICollectionView!
    
    weak var delegate: MovieItemDelegate?=nil
    var isTVSeries: Bool? = nil
    
    var data: MovieListResponse? {
        didSet{
            if let _ = data {
                collectionViewPopularMovie.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionView()
    }
    
    private func registerCollectionView(){
        collectionViewPopularMovie.dataSource = self
        collectionViewPopularMovie.delegate = self
        collectionViewPopularMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension PopularFilmTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
        cell.data = data?.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isTVSeries ?? false {
            delegate?.onTapTVSeries(id: data?.results?[indexPath.row].id ?? -1)
        } else {
            delegate?.onTapMovie(id: data?.results?[indexPath.row].id ?? -1)
        }
        
    }
}
