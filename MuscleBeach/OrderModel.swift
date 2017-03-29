//
//  OrderModel.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/29.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation


class OrderModel {
    
    var date: String
    var delvier: String
    var locationArea: String
    var locationDetail: String
    var mealTypeAAmount: Int
    var mealTypeBAmount: Int
    var mealTypeCAmount: Int
    var time: String
    var price: Int
    var delvierFee: Int
    
    init (date: String, delvier: String, locationArea: String, locationDetail: String, mealTypeAAmount: Int, mealTypeBAmount: Int, mealTypeCAmount: Int, time: String, price: Int, deliverFee: Int) {
        self.date = date
        self.delvier = delvier
        self.locationArea = locationArea
        self.locationDetail = locationDetail
        self.mealTypeAAmount = mealTypeAAmount
        self.mealTypeBAmount = mealTypeBAmount
        self.mealTypeCAmount = mealTypeCAmount
        self.time = time
        self.delvierFee = deliverFee
        self.price = price
    }

}
