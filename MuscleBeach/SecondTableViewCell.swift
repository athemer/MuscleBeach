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
    
    
    
    func addCollectionView(view: UICollectionView){
        
        contentView.addSubview(view)
        
    }
    
}
