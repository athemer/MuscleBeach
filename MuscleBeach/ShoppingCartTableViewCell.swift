//
//  ShoppingCartTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/28.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateOrderedLabel: UILabel!

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var paymentStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
