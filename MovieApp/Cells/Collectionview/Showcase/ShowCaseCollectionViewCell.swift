//
//  ShowCaseCollectionViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var imageBackdrop: UIImageView!
    
    var data: MovieResult? {
        didSet{
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                let backdropPath = "\(baseImageUrl)/\(data.backdropPath ?? "")"
                let releaseDate = data.releaseDate ?? "Unknown"
                
                lblMovieTitle.text = title
                lblReleaseDate.text = releaseDate
                imageBackdrop.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
