//
//  EatTogetherTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/4.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class EatTogetherTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
