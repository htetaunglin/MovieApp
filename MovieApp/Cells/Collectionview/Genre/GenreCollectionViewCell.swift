//
//  GenreCollectionViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewForOverlay: UIView!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var onTapItem: ((Int)->Void) = {_ in}
    var data: GenreVo?=nil{
        didSet{
            if let genre = data{
                lblGenre.text = genre.name.uppercased()
                viewForOverlay.isHidden = !genre.isSelected
                lblGenre.textColor = genre.isSelected ? .white : .darkGray
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGestureForContainer)
    }
    
    @objc func didTapItem(){
        onTapItem(data?.id ?? 0)
    }
    
}
