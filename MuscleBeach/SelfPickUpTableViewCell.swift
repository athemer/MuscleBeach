//
//  SelfPickUpTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SelfPickUpTableViewCell: UITableViewCell {

    @IBOutlet weak var selfPickUpImage: UIImageView!
    @IBOutlet weak var selfPickUpName: UILabel!
    @IBOutlet weak var selfPickUpAddress: UILabel!
    @IBOutlet weak var selfPickUpNumber: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func mapButtonTapped(_ sender: Any) {
    }

}
