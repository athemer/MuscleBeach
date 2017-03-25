//
//  MealVariTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/24.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class MealVariTableViewCell: UITableViewCell {

    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var mealNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
