//
//  DigitINfoViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/1.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class DigitINfoViewController: UIViewController {

    var mealPriceofTotal: Int = 0
    var finalDeliverFee: Int = 0

    var keysArray: [String] = []

    @IBOutlet weak var digitTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirmTapped(_ sender: Any) {

        let price = self.finalDeliverFee + self.mealPriceofTotal
        let uid = FIRAuth.auth()?.currentUser?.uid

        var keyDict: [String: Any] = [:]
        let userUIDToAppend: [String: String] = ["userUID": uid!]
        let priceToAppend: [String: Int] = ["price": price]

        var userName: String = "wrong"
        var number: String = "worng"

        for key in keysArray {
            FIRDatabase.database().reference().child("order").child(key).updateChildValues(["paymentClaim": "true"])

            //做成一個 [key:true] 的array
            let index = keysArray.index(of: key)!
            keyDict["\(index)"] = key

        }

        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                guard
                    let theUserName = dict["name"] as? String,
                    let theNumber = dict["number"] as? String else { return }

                userName = theUserName
                number = theNumber

                keyDict["userData"] = ["userName": userName, "number": number]
                keyDict["userUID"] = uid
                keyDict["price"] = price
                keyDict["last5Digit"] = self.digitTextField.text

                FIRDatabase.database().reference().child("shoppingCart").childByAutoId().setValue(keyDict)

                FIRDatabase.database().reference().child("shoppingCart").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        for dict in dictionary {

                            let valueInDict = dict.value as? [String: Any]

                            let keyforShoppingCartId = dict.key
                            let userUID = valueInDict?["userUID"] as? String

                            if userUID == uid {

                                for key in self.keysArray {
                                    FIRDatabase.database().reference().child("order").child(key).child("shoppingCartId").setValue(keyforShoppingCartId)
                                }

                                self.willMove(toParentViewController: nil)

                                self.view.removeFromSuperview()

                                self.removeFromParentViewController()

                            } else {
                                return
                            }

                        }
                    }
                })
            }
        })

    }

    @IBAction func cancelTapped(_ sender: Any) {

        self.willMove(toParentViewController: nil)

        self.view.removeFromSuperview()

        self.removeFromParentViewController()
    }
}
