//
//  DataService.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/20.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation
import Firebase

class DataService {

    static let ds = DataService()

    func createFirbaseDBUser(uid: String, userData: [String: String], email: [String: String], password: [String: String], name: [String: String], number: [String: String]) {

        let mealPref: [String: Any] = ["mealPreference": ["deliver": "自取","typeA": 0, "typeB": 0, "typeC": 0]]
        let img: [String: String] = ["prfileImgURL": " "]
        let add: [String: Any] = ["address": ["mainAdd": "自取地點一", "mainDetail": "城市草倉"]]

        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(userData)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(email)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(password)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(name)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(number)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(mealPref)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(img)
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(add)
    }
}
