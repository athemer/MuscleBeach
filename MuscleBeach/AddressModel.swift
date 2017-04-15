//
//  AddressModel.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/14.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation

class AddressModel {

    var mainAdd: String
    var detailAdd: String
    var finalAdd: String

    init (mainAdd: String, detailAdd: String, finalAdd: String) {

        self.mainAdd = mainAdd
        self.detailAdd = detailAdd
        self.finalAdd = finalAdd
    }
}
