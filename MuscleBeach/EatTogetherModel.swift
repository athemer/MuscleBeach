//
//  EatTogetherModel.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/4.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation

class EatTogetherModel {

    var name: String
    var distance: Double
    var amount: Int
    var key: String

    init (name: String, distance: Double, amount: Int, key: String) {

        self.name = name
        self.distance = distance
        self.amount = amount
        self.key = key

    }
}
