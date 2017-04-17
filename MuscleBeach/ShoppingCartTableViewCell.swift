//
//  ShoppingCartTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/28.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDateLabel: UILabel!

    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var deliverFee: UILabel!

    @IBOutlet weak var typeAAmount: UILabel!

    @IBOutlet weak var typeBAmount: UILabel!

    @IBOutlet weak var typeCAmount: UILabel!

    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
