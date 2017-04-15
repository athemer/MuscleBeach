//
//  MealVariationViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/24.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class MealVariationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timeSegment: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var mealPrice: UILabel!

    @IBOutlet weak var numberOfDaysOrdered: UILabel!

    @IBOutlet weak var deliverFee: UILabel!

    @IBOutlet weak var totalPrice: UILabel!

    var testData: [NewOrderTest] = []

    var dateToDB: [String] = []
    var deliverToDB: String = ""
    var locationAreaToDB: String = ""
    var locationDetailToDB: String = ""
    var mealToDB: [String: AnyObject] = [:]
    var timeToDB: String = ""

    var mealArr: [String] = ["仙女餐", "享瘦餐", "猛男餐"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        numberOfDaysOrdered.text = "\(dateToDB.count)"

        //MARK
        fetchTestData()

        print("ahha \(deliverToDB) \(locationDetailToDB) \(dateToDB)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealVariTableViewCell") as! MealVariTableViewCell
        // swiftlint:disable:previous force_cast

        cell.mealNameLabel.text = mealArr[indexPath.row]
        cell.stepper.addTarget(self, action: #selector(showStepperValue), for: .touchUpInside)

        return cell
    }

    func showStepperValue(_ sender: UIStepper) {

        var numberOfMeal: Int = 0

        guard let cell = sender.superview?.superview as? MealVariTableViewCell else { return }

        cell.amountLabel.text = "\(Int(cell.stepper.value))"

        let indexPath0 = IndexPath(row: 0, section: 0)
        let indexPath1 = IndexPath(row: 1, section: 0)
        let indexPath2 = IndexPath(row: 2, section: 0)
        // swiftlint:disable:next force_cast
        let cell0 = tableView.cellForRow(at: indexPath0) as! MealVariTableViewCell
        // swiftlint:disable:previous force_cast

        // swiftlint:disable:next force_cast
        let cell1 = tableView.cellForRow(at: indexPath1) as! MealVariTableViewCell
        // swiftlint:disable:previous force_cast

        // swiftlint:disable:next force_cast
        let cell2 = tableView.cellForRow(at: indexPath2) as! MealVariTableViewCell
        // swiftlint:disable:previous force_cast

        numberOfMeal = Int(cell0.stepper.value) + Int(cell1.stepper.value) + Int(cell2.stepper.value)
        mealPrice.text = "\(Int(cell0.stepper.value) * 120 + Int(cell1.stepper.value) * 120 + Int(cell2.stepper.value) * 150)"
        var singleDayDeliverFee: Int = 0

        if numberOfMeal >= 2 && numberOfMeal < 5 {

            switch dateToDB.count {

            case 1:
                singleDayDeliverFee = 60
            case 5, 10:
                singleDayDeliverFee = 48
            case 15 :
                singleDayDeliverFee = 42
            case 20 :
                singleDayDeliverFee = 36
            default:
                break
            }

            switch deliverToDB {
            case "自取":
                deliverFee.text = "0"
                totalPrice.text = "\((Int(cell0.stepper.value) * 120 + Int(cell1.stepper.value) * 120 + Int(cell2.stepper.value) * 150) * dateToDB.count)"

            case "外送" :
                deliverFee.text = "\(singleDayDeliverFee * dateToDB.count)"
                totalPrice.text = "\((Int(cell0.stepper.value) * 120 + Int(cell1.stepper.value) * 120 + Int(cell2.stepper.value) * 150 + singleDayDeliverFee) * dateToDB.count)"
            default:
                break
            }
        } else if numberOfMeal >= 5 {

            deliverFee.text = "0"
            totalPrice.text = "\((Int(cell0.stepper.value) * 120 + Int(cell1.stepper.value) * 120 + Int(cell2.stepper.value) * 150) * dateToDB.count )"

        } else {
            print ("unable to deliver")
        }

    }

    @IBAction func segmentChange(_ sender: Any) {

        if timeSegment.selectedSegmentIndex == 1 {
            backgroundView.backgroundColor = UIColor.brown
        } else {
            backgroundView.backgroundColor = UIColor.darkGray
        }
    }

    // MARK: need to be fixed
    @IBAction func confirmTapped(_ sender: Any) {

                let indexPath0 = IndexPath(row: 0, section: 0)
                let indexPath1 = IndexPath(row: 1, section: 0)
                let indexPath2 = IndexPath(row: 2, section: 0)
                // swiftlint:disable:next force_cast
                let cell0 = self.tableView.cellForRow(at: indexPath0) as! MealVariTableViewCell
                // swiftlint:disable:previous force_cast

                // swiftlint:disable:next force_cast
                let cell1 = self.tableView.cellForRow(at: indexPath1) as! MealVariTableViewCell
                // swiftlint:disable:previous force_cast

                // swiftlint:disable:next force_cast
                let cell2 = self.tableView.cellForRow(at: indexPath2) as! MealVariTableViewCell
                // swiftlint:disable:previous force_cast
                var numberOfMeal: Int = 0
                numberOfMeal = Int(cell0.stepper.value) + Int(cell1.stepper.value) + Int(cell2.stepper.value)

                if numberOfMeal <= 1 && self.deliverToDB != "自取" {
                    let alert = UIAlertController(title: "外送數量",
                                                  message: "餐點數量需要滿兩個以上才有外送唷",
                                                  preferredStyle: .alert)

                    let cancel = UIAlertAction(title: "更新數量", style: .destructive, handler: { (_) -> Void in })
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)

                    return

                } else {
                    print (" meal number passed ")
                }

                if self.timeSegment.selectedSegmentIndex == 0 {
                    self.timeToDB = "午餐"
                } else if self.timeSegment.selectedSegmentIndex == 1 {
                    self.timeToDB = "晚餐"
                }

                let meal: [String: Int] = ["typeA": Int(cell0.stepper.value), "typeB": Int(cell1.stepper.value), "typeC": Int(cell2.stepper.value)]

                // Mark: todo
                let userData: [String: String] = ["userName": "Kuan Hua", "number": "0963322300"]

                for date in self.dateToDB {

                    let uid = FIRAuth.auth()!.currentUser!.uid

//                    for x in 0...testData.count - 1 {
//                        let testDate = testData[x].testDate
//                        let testDeliver = testData[x].testDeliver
//                        let testTime = testData[x].testTime
//                        let testLocDetail = testData[x].testLocDetail
//                        let testUID = testData[x].testUID
//
//                        if date == testDate && testUID == uid {
//                            print ("the user is order the repeating date and ....")
//
//                            if timeToDB == testTime && locationDetailToDB == testLocDetail {
//                                print ("lol youre not gonna proceeding")
//
//                                let alert = UIAlertController(title: "重複訂購",
//                                                              message: "\(date)\(timeToDB)訂單已在購物車內\n為避免運費重複計算\n請至購物車內更改數量",
//                                                              preferredStyle: .alert)
//
//                                let cancel = UIAlertAction(title: "瞭解", style: .destructive, handler: { (_) -> Void in })
//                                alert.addAction(cancel)
//                                self.present(alert, animated: true, completion: nil)
//
//                                return
//
//                            }
//
//                        } else {
//                            print ("the order shall pass")
//                        }
//
//                    }

                    let orderData: [String: AnyObject] = ["date": date as AnyObject, "deliver": self.deliverToDB as AnyObject, "locationArea": self.locationAreaToDB as AnyObject, "locationDetail": self.locationDetailToDB as AnyObject, "userUID": uid as AnyObject, "time": self.timeToDB as AnyObject, "meal": meal as AnyObject, "userData": userData as AnyObject, "paymentStatus": "unpaid" as AnyObject, "paymentClaim": "false" as AnyObject ]
                    FIRDatabase.database().reference().child("order").childByAutoId().setValue(orderData)
                    navigationController?.popToRootViewController(animated: true)
                }

    }

    @IBAction func testTapped(_ sender: Any) {

    }

    func addDataToShoppingCart() {

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)
        let totalPriceValue = totalPrice.text
        let dataToCart: [String: AnyObject] = ["paymentStatus": "unpaid" as AnyObject, "totalPrice": totalPriceValue as AnyObject]
        let userUid = FIRAuth.auth()?.currentUser?.uid

        FIRDatabase.database().reference().child("shoppingCart").child(userUid!).observeSingleEvent(of: .value, with: { (snapshot) in

            var keyArr: [String] = []
            if let snaps = snapshot.value as? [String: AnyObject] {
                for snap in snaps {
                    // swiftlint:disable:next force_cast
                    let key = snap.key as! String
                    // swiftlint:disable:previous force_cast
                    keyArr.append(key)
                }

                if keyArr.contains(localDate) {
                    print ("QOO")

                    FIRDatabase.database().reference().child("shoppingCart").child(userUid!).child(localDate).observeSingleEvent(of: .value, with: { (snap) in
                        if let dict = snap.value as? [String: AnyObject] {

                            print (dict)
                            // swiftlint:disable:next force_cast
                            let value = dict["totalPrice"] as! Int
                            // swiftlint:disable:previous force_cast

                            let newTotal = value + Int(self.totalPrice.text!)!
                            FIRDatabase.database().reference().child("shoppingCart").child(userUid!).child(localDate).child("totalPrice").setValue(newTotal)
                        }
                    })

                } else {
                    FIRDatabase.database().reference().child("shoppingCart").child(userUid!).child(localDate).setValue(dataToCart)
                }
            }

        })

    }

    func fetchTestData () {

        let uid = FIRAuth.auth()!.currentUser!.uid

        FIRDatabase.database().reference().child("order").observeSingleEvent(of: .value, with: { (snapshot) in

            if let snaps = snapshot.value as? [String: Any] {

                for snap in snaps {
                    print (snap)
                    guard
                        let dict = snap.value as? [String: Any],
                        let date = dict["date"] as? String,
                        let time = dict["time"] as? String,
                        let locationDetail = dict["locationDetail"] as? String,
                        let deliver = dict["deliver"] as? String,
                        let userUID = dict["userUID"] as? String else { return }

                    print ("bruh")

                    let dataAppendToTest: NewOrderTest = NewOrderTest(testDate: date, testTime: time, testDeliver: deliver, testLocDetail: locationDetail, testUID: userUID)
                    self.testData.append(dataAppendToTest)

                }
            }
        })

    }
}
