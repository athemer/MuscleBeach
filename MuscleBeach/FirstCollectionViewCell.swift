//
//  FirstCollectionViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var detailLAbel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 3
        
        startButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        startButton.layer.shadowOpacity = 1.0
        startButton.layer.masksToBounds = false
    }

}
