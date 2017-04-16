//
//  ThirdTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {

    @IBOutlet weak var lunchButton: UIButton!
    
    @IBOutlet weak var dinnerButton: UIButton!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var mealName: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeView.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToCartTapped(_ sender: Any) {
        
        addToCartButton.isHidden = true
        timeView.isHidden = false
        
    }
    
    

}
