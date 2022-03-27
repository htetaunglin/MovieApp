//
//  BestActorCollectionViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class BestActorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var ivHeartFill: UIImageView!
    @IBOutlet weak var ivActorImage: UIImageView!
    @IBOutlet weak var lblActorName: UILabel!
    @IBOutlet weak var lblKnownForDepartment: UILabel!

    weak var delegate : ActorActionDelegate?=nil
    var data : ActorInfoResponse? {
        didSet {
            if let _ = data {
                let profilePath = "\(baseImageUrl)/\(data?.profilePath ?? "")"
                ivActorImage.sd_setImage(with: URL(string: profilePath))
                lblActorName.text = data?.name ?? "Unknown"
                lblKnownForDepartment.text = data?.knownForDepartment
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGestureRecognizers()
        ivHeartFill.isHidden = true
        ivHeart.isHidden = false
    }
    
    private func initGestureRecognizers(){
        let tapGestForFavoriate = UITapGestureRecognizer(target: self, action: #selector(onTapFavoriate))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestForFavoriate)
        
        let tapGestForUnFavoriate = UITapGestureRecognizer(target: self, action: #selector(onTapUnFavoriate))
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestForUnFavoriate)
    }
    
    @objc func onTapFavoriate(){
        ivHeartFill.isHidden = true
        ivHeart.isHidden = false
        delegate?.onTapFavorite(isFavorite: true)
        
    }
    
    @objc func onTapUnFavoriate(){
        ivHeart.isHidden = true
        ivHeartFill.isHidden = false
        delegate?.onTapFavorite(isFavorite: false)
    }
}
