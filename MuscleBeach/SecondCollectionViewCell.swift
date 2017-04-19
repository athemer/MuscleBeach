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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selfPickUpView.isHidden = false
        deliverView.isHidden = true
        pickerView.isHidden = true

        // Initialization code
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
