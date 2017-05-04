//
//  Constants.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/5/3.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation

class Constants {

    let dateArr: [String] = ["2017-01-02", "2017-01-03", "2017-01-04", "2017-01-05", "2017-01-06", "2017-01-09", "2017-01-10"]

    let mealNameArr: [String] = ["快樂分享餐", "肯德基全家餐", "泰國好吃餐", "居家旅行餐", "必備涼拌餐", "八方雲集餐", "四海遊龍餐"]

    let imageNameArr: [String] = ["one", "two", "three", "one", "two", "three", "one" ]

    var mealName: String = ""

    var date: String = ""

    var imageName: String = ""

    init(mealName: String, date: String, imageName: String) {

        self.mealName = mealName

        self.date = date

        self.imageName = imageName
    }

    static func createDataInCell() -> [Constants] {

        return [

        Constants(mealName: "快樂分享餐", date: "2017-01-02", imageName: "one"),
        Constants(mealName: "肯德基全家餐", date: "2017-01-03", imageName: "two"),
        Constants(mealName: "泰國好吃餐", date: "2017-01-04", imageName: "three"),
        Constants(mealName: "居家旅行餐", date: "2017-01-05", imageName: "one"),
        Constants(mealName: "必備涼拌餐", date: "2017-01-06", imageName: "two"),
        Constants(mealName: "八方雲集餐", date: "2017-01-07", imageName: "three"),
        Constants(mealName: "四海遊龍餐", date: "2017-01-08", imageName: "one"),

        ]
    }
}
