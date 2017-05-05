//
//  SecondTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    
    

//    story
    
//    var contentVC: MainCollectionViewController {
//        contentVC = MainCollectionViewController()
//        self.contentVC = contentVC
//        return contentVC
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func addCollectionView(view: UIView){
        
        contentView.addSubview(view)
        view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        
    }
    
}
