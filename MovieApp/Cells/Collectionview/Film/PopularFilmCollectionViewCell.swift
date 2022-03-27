//
//  PopularFilmCollectionViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var starRating: RatingControl!
    
    var data: MovieResult? {
        didSet{
            if let data = data {
                let title = data.originalName ?? data.originalTitle
                let backdropPath = "\(baseImageUrl)/\(data.posterPath ?? "")"
                let voteAverage = data.voteAverage ?? 0
                
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
                labelRating.text = "\(voteAverage)"
                starRating.startCount = 5
                starRating.rating = Int(voteAverage * 0.5)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
