//
//  ShowCaseTableViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblShowcase: UILabel!
    @IBOutlet weak var lblMoreShowcase: UILabel!
    @IBOutlet weak var collectionViewShowCase: UICollectionView!
    @IBOutlet weak var heightCollectionViewShowCase: NSLayoutConstraint!

    var data: [MovieResult] = [] {
        didSet{
            collectionViewShowCase.reloadData()
        }
    }
    weak var moreShowCaseDelegate: MoreShowCaseDelegate?
    weak var movieItemDelegate: MovieItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreShowcase.underlineText()
        registerCollectionView()
        heightCollectionViewShowCase.constant = (((collectionViewShowCase.frame.width - 100) / 16 ) * 9) + 20
        addGestureRecognizer()
    }
    
    private func registerCollectionView(){
        collectionViewShowCase.dataSource = self
        collectionViewShowCase.delegate = self
        collectionViewShowCase.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
    
    func addGestureRecognizer(){
        let moreShowcaseGR = UITapGestureRecognizer(target: self, action: #selector(onTapMoreShowCase))
        lblMoreShowcase.isUserInteractionEnabled = true
        lblMoreShowcase.addGestureRecognizer(moreShowcaseGR)
    }
    
    @objc func onTapMoreShowCase(){
        self.moreShowCaseDelegate?.onTapMoreShowCase()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ShowCaseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as ShowCaseCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - 100
        let itemHeight = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = data[indexPath.row].id {
            self.movieItemDelegate?.onTapMovie(id: movieId)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ((scrollView.subviews[(scrollView.subviews.count)-1]).subviews[0]).backgroundColor = UIColor(named: "color_yellow")
    }
}

