//
//  OrderDetailTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/25.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var deliverInfo: UILabel!
    
    @IBOutlet weak var timeInfo: UILabel!
    
    @IBOutlet weak var locationInfo: UILabel!
    
    @IBOutlet weak var typeAAmount: UILabel!
    
    @IBOutlet weak var typeBAmount: UILabel!
    
    @IBOutlet weak var typeCAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
