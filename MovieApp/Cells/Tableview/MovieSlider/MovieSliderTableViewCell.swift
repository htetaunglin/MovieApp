//
//  MovieSliderTableViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 11/02/2022.
//

import UIKit

class MovieSliderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    weak var delegate: MovieItemDelegate?=nil
    
    var data: [MovieResult]? {
        didSet{
            if let _ = data {
                pageControl.numberOfPages = data?.count ?? 0
                collectionViewMovie.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionView()
    }
    
    private func registerCollectionView(){
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(identifier: MovieSliderCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension MovieSliderTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: MovieSliderCollectionViewCell.identifier, indexPath: indexPath) as MovieSliderCollectionViewCell
        /// -> data
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(240))
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    //OnClick
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onTapMovie(id: data?[indexPath.row].id ?? -1)
    }
    
}
