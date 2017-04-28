//
//  SecondCollectionViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var segmentControl: UISegmentedControl!

    @IBOutlet weak var selfPickUpView: UIView!

    @IBOutlet weak var deliverView: UIView!

    @IBOutlet weak var firstButton: UIButton!

    @IBOutlet weak var secondButton: UIButton!

    @IBOutlet weak var deliverAddButton: UIButton!

    @IBOutlet weak var pickerView: UIPickerView!

    @IBOutlet weak var firstInfoButton: UIButton!

    @IBOutlet weak var secondInfoButton: UIButton!

    
    @IBOutlet weak var viewOne: UIView!
    
    
    @IBOutlet weak var viewTwo: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        selfPickUpView.isHidden = false
        deliverView.isHidden = true
        pickerView.isHidden = true

        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 3
        // Initialization code
        
        
        viewOne.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        viewOne.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewOne.layer.shadowOpacity = 1.0
        viewOne.layer.masksToBounds = false
        
        viewTwo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        viewTwo.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewTwo.layer.shadowOpacity = 1.0
        viewTwo.layer.masksToBounds = false
        
    }

    @IBAction func segmentValueChanged(_ sender: Any) {

        if segmentControl.selectedSegmentIndex == 0 {
            selfPickUpView.isHidden = false
            deliverView.isHidden = true

        } else if segmentControl.selectedSegmentIndex == 1 {
            selfPickUpView.isHidden = true
            deliverView.isHidden = false

        }
    }

    @IBAction func firstButtonTapped(_ sender: Any) {

    }

}
