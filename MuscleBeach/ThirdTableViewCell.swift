//
//  ThirdTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Spring

class ThirdTableViewCell: UITableViewCell {

    @IBOutlet weak var lunchButton: UIButton!

    @IBOutlet weak var dinnerButton: UIButton!

    @IBOutlet weak var timeView: UIView!

    @IBOutlet weak var date: UILabel!

    @IBOutlet weak var mealName: UILabel!

    @IBOutlet weak var addToCartButton: UIButton!

    @IBOutlet weak var mealImage: SpringImageView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var gradientLayer: CAGradientLayer!
    
    var dateLabelonLayer: UILabel!
    var mealLabelonLayer: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        timeView.isHidden = true
        addGradientLayer()
        addLabel()
        animation()
        // Initialization code
        
        
        addBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        addBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        addBtn.layer.shadowOpacity = 1.0
        addBtn.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func addGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 5, y: self.bounds.height / 2, width: self.bounds.width - 10, height: self.bounds.height / 2)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.contentView.layer.addSublayer(gradientLayer)
    }
    
    func addLabel() {
        dateLabelonLayer = UILabel()
        dateLabelonLayer.frame = CGRect(x: self.bounds.width - 5 - self.bounds.width / 4, y: self.bounds.height / 4 * 3, width:  self.bounds.width / 4, height: self.bounds.height / 4)
        dateLabelonLayer.textColor = .white
        dateLabelonLayer.text = "TEST LABEL"
        dateLabelonLayer.font = UIFont(name: "AvenirNext-Bold", size: 14)
        dateLabelonLayer.adjustsFontSizeToFitWidth = true
        
        mealLabelonLayer = UILabel()
        mealLabelonLayer.frame = CGRect(x: 15, y: self.bounds.height / 3 * 2, width:  self.bounds.width / 3, height: self.bounds.height / 3)
        mealLabelonLayer.textColor = .white
        mealLabelonLayer.text = "好吃餐"
        mealLabelonLayer.adjustsFontSizeToFitWidth = true
    
        
        
        self.contentView.addSubview(dateLabelonLayer)
        self.contentView.addSubview(mealLabelonLayer)

    }
    
    func animation() {
        let layer = self.mealImage!
        layer.animation = "fadeInLeft"
        layer.curve = "easeInOutQuad"
        layer.duration = 1.0
        layer.scaleX = 1.5
        layer.scaleY = 1.5
        layer.damping = 0.9
        layer.velocity = 0.5
        layer.animate()
        
    }
}
