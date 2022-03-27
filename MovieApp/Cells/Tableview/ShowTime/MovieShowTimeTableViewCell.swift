//
//  MovieShowTimeTableViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class MovieShowTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var lblSeeMore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // viewForBackground.layer.cornerRadius = 4
        // Underline extension
        lblSeeMore.underlineText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
