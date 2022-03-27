//
//  ProductionCollectionViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 21/03/2022.
//

import UIKit

class ProductionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivProduction: UIImageView!
    @IBOutlet weak var lblProductionName: UILabel!
    
    var data: ProductionCompany? {
        didSet{
            if let _ = data {
                let profilePath = "\(baseImageUrl)/\(data?.logoPath ?? "")"
                ivProduction.sd_setImage(with: URL(string: profilePath))
                if data?.logoPath == nil || (data?.logoPath?.isEmpty ?? true){
                    lblProductionName.text = data?.name // No Text for now
                } else {
                    lblProductionName.text = "" // No Text for now
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
