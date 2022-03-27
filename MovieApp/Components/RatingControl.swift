//
//  RatingControl.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 11/02/2022.
//

import UIKit

//To show in storyboard
@IBDesignable
class RatingControl: UIStackView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBInspectable var starSize: CGSize = CGSize(width: 50, height: 50){
        didSet{
            setUpButton()
            updateButtonRating()
        }
    }
    @IBInspectable var startCount: Int = 5{
        didSet{
            setUpButton()
            updateButtonRating()
        }
    }
    @IBInspectable var rating: Int = 3{
        didSet{
            updateButtonRating()
        }
    }
    var ratingButtons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
        updateButtonRating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
        updateButtonRating()
    }
    
    private func setUpButton(){
        clearExistingButton()
        for _ in 0..<startCount {
            let button = UIButton()
            //button.backgroundColor =
            //Set image in button programmically
            button.setImage(UIImage(named: "filledStar"), for: .selected)
            button.setImage(UIImage(named: "emptyStar"), for: .normal)
            //Disable constraint in Stack View
            button.translatesAutoresizingMaskIntoConstraints = false
            //Define width & height of button programmically
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            addArrangedSubview(button)
            //Disable onclick
            button.isUserInteractionEnabled = false
            ratingButtons.append(button)
        }
        
    }
    
    private func updateButtonRating(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
        }
    }
    
    private func clearExistingButton(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
}
