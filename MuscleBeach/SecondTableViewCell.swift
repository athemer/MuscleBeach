//
//  SecondTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    var vc: UICollectionViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
//    func setup() {
//        
//       
//        
//        
//        let but = UIButton(type: .system)
//        but.translatesAutoresizingMaskIntoConstraints = false
//        but.backgroundColor = .green
//        but.tintColor = .black
//        but.setTitle("開始", for: .normal)
//        
//        but.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
//        but.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10).isActive = true
//        but.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        but.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        
//        self.contentView.addSubview(but)
//    }
}
