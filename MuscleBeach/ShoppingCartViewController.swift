//
//  ShoppingCartViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/28.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ValueChangedDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var discountLabel: UILabel!

    @IBOutlet weak var mealPrice: UILabel!

    @IBOutlet weak var deliverPrice: UILabel!

    @IBOutlet weak var totalPRice: UILabel!

    var orderDataToCart: [OrderModel] = []

    var keysArray: [String] = []

    var mealPriceofTotal: Int = 0
    var finalDeliverFee: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchDataFromFirebase()
        navigationItem.title = "購物車"

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        print ("haha")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didChangeMealAmount(_ manager: PopoverViewController, didGet newAmount: [String : Any]) {
        guard
            let indexRow = newAmount["index"] as? Int,
            let typeA = newAmount["typeA"] as? Int,
            let typeB = newAmount["typeB"] as? Int,
            let typeC = newAmount["typeC"] as? Int,
            let deliverWay = newAmount["deliverWay"] as? String else { return }

        var deliverFee = 60
        let price = typeA * 120 + typeB * 120 + typeC * 150
        let amount = typeA + typeB + typeC
        if amount >= 5 || deliverWay == "自取" {
            deliverFee = 0
        }

        self.orderDataToCart[indexRow].mealTypeAAmount = typeA
        self.orderDataToCart[indexRow].mealTypeBAmount = typeB
        self.orderDataToCart[indexRow].mealTypeCAmount = typeC
        self.orderDataToCart[indexRow].price = price
        self.orderDataToCart[indexRow].delvierFee = deliverFee

        print ("LALALAND \(newAmount)")
        fetchDataFromFirebase()
        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDataToCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell") as! ShoppingCartTableViewCell
        // swiftlint:disable:previous force_cast

        cell.orderDateLabel.text = orderDataToCart[indexPath.row].date
//        cell.address.text = orderDataToCart[indexPath.row].locationArea
//        cell.addressDetail.text = orderDataToCart[indexPath.row].locationDetail
//        cell.deliver.text = orderDataToCart[indexPath.row].delvier
        cell.typeAAmount.text = "\(orderDataToCart[indexPath.row].mealTypeAAmount)"
        cell.typeBAmount.text = "\(orderDataToCart[indexPath.row].mealTypeBAmount)"
        cell.typeCAmount.text = "\(orderDataToCart[indexPath.row].mealTypeCAmount)"
        cell.price.text = "\(orderDataToCart[indexPath.row].price)"
        cell.time.text = orderDataToCart[indexPath.row].time
        cell.deliverFee.text = "\(orderDataToCart[indexPath.row].delvierFee)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // swiftlint:disable:next force_cast
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartDetailViewController") as! ShoppingCartDetailViewController
        // swiftlint:disable:previous force_cast

        vc.orderDataToCart = orderDataToCart[indexPath.row]

        navigationController?.pushViewController(vc, animated: true)

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            orderDataToCart.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

    }

     func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .normal, title: "刪除") { _, index in

            if self.orderDataToCart[index.row].paymentClaim == "true" {
                let alertController = UIAlertController(title: "注意", message:
                    "肌肉海灘確認訂單金額中，無法刪除！", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))

                self.present(alertController, animated: true, completion: nil)
                return
            }

            let key = self.orderDataToCart[index.row].key

            self.orderDataToCart.remove(at: index.row)

            self.fetchDataFromFirebasewith {
                self.tableView.reloadData()
            }

            FIRDatabase.database().reference().child("order").child(key).removeValue()

            print("more button tapped")
        }
        delete.backgroundColor = .red

        let revise = UITableViewRowAction(style: .normal, title: "更改") { _, index in

            if self.orderDataToCart[index.row].paymentClaim == "true" {
                let alertController = UIAlertController(title: "注意", message:
                    "肌肉海灘確認訂單金額中，無法更改數量！", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))

                self.present(alertController, animated: true, completion: nil)
                return
            }

            let key = self.orderDataToCart[index.row].key

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // swiftlint:disable:next force_cast
            let vc = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
            // swiftlint:disable:previous force_cast

            vc.delegate = self

            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            let navigation = self.navigationController

            vc.index = index.row
            vc.amountA = self.orderDataToCart[index.row].mealTypeAAmount
            vc.amountB = self.orderDataToCart[index.row].mealTypeBAmount
            vc.amountC = self.orderDataToCart[index.row].mealTypeCAmount
            vc.key = self.orderDataToCart[index.row].key
            vc.deliver = self.orderDataToCart[index.row].delvier

            navigation?.addChildViewController(vc)
            navigation?.view.addSubview(vc.view)
            vc.didMove(toParentViewController: navigation)

            print("favorite button tapped")
        }
        revise.backgroundColor = .yellow

        return [delete, revise]
    }

     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func fetchDataFromFirebasewith(completion: @escaping () -> Void) {

        orderDataToCart.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("order").queryOrdered(byChild: "userUID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapData = snapshot.value as? [String: AnyObject] {
                for snap in snapData {
                    if let data = snap.value as? [String: AnyObject] {
                        print ("CD \(data)")

                        guard
                            let date = data["date"] as? String,
                            let deliverTime = data["time"] as? String,
                            let deliverLocationArea = data["locationArea"] as? String,
                            let deliverLocationDetail = data["locationDetail"] as? String,
                            let deliver = data["deliver"] as? String,
                            let paymentStatus = data["paymentStatus"] as? String,
                            let meal = data["meal"] as? AnyObject,
                            let key = snap.key as? String,
                            let paymentClaim = data["paymentClaim"] as? String
                            else { return }

                        self.keysArray.append(key)

                        // swiftlint:disable:next force_cast
                        let typeBAmount = meal["typeB"] as! Int
                        // swiftlint:disable:previous force_cast
                        // swiftlint:disable:next force_cast
                        let typeCAmount = meal["typeC"] as! Int
                        // swiftlint:disable:previous force_cast
                        // swiftlint:disable:next force_cast
                        let typeAAmount = meal["typeA"] as! Int
                        // swiftlint:disable:previous force_cast

                        let price: Int = typeAAmount * 120 + typeBAmount * 120 + typeCAmount * 150
                        var deliverFee: Int = 0
                        let totalAmount: Int = typeAAmount + typeBAmount + typeCAmount

                        if totalAmount >= 5 || deliver == "自取" {
                            deliverFee = 0
                        } else if totalAmount > 1 && totalAmount < 5 {
                            deliverFee = 60
                        } else {
                            print ("overload")
                        }

                        if paymentStatus == "unpaid" {
                            print ("cool")

                            let toAppend: OrderModel = OrderModel(date: date, delvier: deliver, locationArea: deliverLocationArea, locationDetail: deliverLocationDetail, mealTypeAAmount: typeAAmount, mealTypeBAmount: typeBAmount, mealTypeCAmount: typeCAmount, time: deliverTime, price: price, deliverFee: deliverFee, key: key, paymentClaim: paymentClaim)

                            self.orderDataToCart.append(toAppend)

                        } else {
                            print ("not cool")
                        }

                    }
                }

            }

            self.tableView.reloadData()
            print ("ala \(self.orderDataToCart)")
            self.getPrice()
            completion()
        })

    }

    func fetchDataFromFirebase () {

        orderDataToCart.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("order").queryOrdered(byChild: "userUID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapData = snapshot.value as? [String: AnyObject] {
                    for snap in snapData {
                        if let data = snap.value as? [String: AnyObject] {
                            print ("CD \(data)")

                            guard
                                let date = data["date"] as? String,
                                let deliverTime = data["time"] as? String,
                                let deliverLocationArea = data["locationArea"] as? String,
                                let deliverLocationDetail = data["locationDetail"] as? String,
                                let deliver = data["deliver"] as? String,
                                let paymentStatus = data["paymentStatus"] as? String,
                                let meal = data["meal"] as? AnyObject,
                                let key = snap.key as? String,
                                let paymentClaim = data["paymentClaim"] as? String
                                else { return }

                            self.keysArray.append(key)

                            // swiftlint:disable:next force_cast
                                let typeBAmount = meal["typeB"] as! Int
                            // swiftlint:disable:previous force_cast
                            // swiftlint:disable:next force_cast
                                let typeCAmount = meal["typeC"] as! Int
                            // swiftlint:disable:previous force_cast
                            // swiftlint:disable:next force_cast
                                let typeAAmount = meal["typeA"] as! Int
                            // swiftlint:disable:previous force_cast

                            let price: Int = typeAAmount * 120 + typeBAmount * 120 + typeCAmount * 150
                            var deliverFee: Int = 0
                            let totalAmount: Int = typeAAmount + typeBAmount + typeCAmount

                            if totalAmount >= 5 || deliver == "自取" {
                                deliverFee = 0
                            } else if totalAmount > 1 && totalAmount < 5 {
                                deliverFee = 60
                            } else {
                                print ("overload")
                            }

                            if paymentStatus == "unpaid" {
                                print ("cool")

                                let toAppend: OrderModel = OrderModel(date: date, delvier: deliver, locationArea: deliverLocationArea, locationDetail: deliverLocationDetail, mealTypeAAmount: typeAAmount, mealTypeBAmount: typeBAmount, mealTypeCAmount: typeCAmount, time: deliverTime, price: price, deliverFee: deliverFee, key: key, paymentClaim: paymentClaim)

                                self.orderDataToCart.append(toAppend)

                            } else {
                                print ("not cool")
                            }

                        }
                    }

                }

            self.tableView.reloadData()
            print ("ala \(self.orderDataToCart)")
            self.getPrice()
        })

    }

    @IBAction func butTapped(_ sender: Any) {

        getPrice()
    }

    func getPrice () {

        let days = orderDataToCart.count

        var mealPrice: Int = 0

        var deliverDateNumber: Int = 0

        for x in 0...days - 1 {
            let singleDayPrice = orderDataToCart[x].price

            if orderDataToCart[x].delvier == "外送" {
                deliverDateNumber += 1
            }
            mealPrice += singleDayPrice
        }

        self.mealPrice.text = "\(mealPrice)"
        self.mealPriceofTotal = mealPrice
        countDeliverFee(deliverDateNumber: deliverDateNumber)

        let totalprice: Int = mealPriceofTotal + self.finalDeliverFee
        self.totalPRice.text = "\(totalprice)"
    }

    func countDeliverFee (deliverDateNumber: Int) {

        print ("CHECK HERE \(deliverDateNumber)")

        let days = orderDataToCart.count
        var totalDeliverFee: Int = 0
        var finalDeliverFee: Int = 0

        for x in 0...days - 1 {

            totalDeliverFee += orderDataToCart[x].delvierFee

        }

        if deliverDateNumber >= 1 && deliverDateNumber < 5 {

            finalDeliverFee = totalDeliverFee
            discountLabel.text = "0%"
            print ("0%")

        } else if deliverDateNumber >= 5 && deliverDateNumber < 15 {

            finalDeliverFee = (totalDeliverFee / 10 * 8)
            discountLabel.text = "20%"
            print ("80%")
        } else if deliverDateNumber >= 15 && deliverDateNumber < 20 {

            finalDeliverFee = (totalDeliverFee / 10 * 7)

            discountLabel.text = "30%"
            print ("70%")

        } else if deliverDateNumber >= 20 {

            discountLabel.text = "40%"
            finalDeliverFee = (totalDeliverFee / 10 * 6)

            print ("60%")
        } else {
            print ("bang bang ")
        }

        deliverPrice.text = "\(finalDeliverFee)"

        self.finalDeliverFee = finalDeliverFee
    }

//        let price = self.finalDeliverFee + self.mealPriceofTotal
//        let uid = FIRAuth.auth()?.currentUser?.uid
//        
//        var keyDict: [String: Any] = [:]
//        let userUIDToAppend: [String: String] = ["userUID": uid!]
//        let priceToAppend: [String: Int] = ["price": price]
//        
//        var userName: String = "wrong"
//        var number: String = "worng"
//        
//        for key in keysArray {
//            FIRDatabase.database().reference().child("order").child(key).updateChildValues(["paymentClaim" : "true"])
//
//            
//            //做成一個 [key:true] 的array
//            let index = keysArray.index(of: key)!
//            keyDict["\(index)"] = key
//            
//            
//        }
//        
//        
//        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: Any] {
//                guard
//                    let theUserName = dict["name"] as? String,
//                    let theNumber = dict["number"] as? String else { return }
//                
//                userName = theUserName
//                number = theNumber
//                
//                keyDict["userData"] = ["userName" : userName, "number": number]
//                keyDict["userUID"] = uid
//                keyDict["price"] = price
//                
//                FIRDatabase.database().reference().child("shoppingCart").childByAutoId().setValue(keyDict)
//                
//                FIRDatabase.database().reference().child("shoppingCart").observeSingleEvent(of: .value, with: { (snapshot) in
//                    if let dictionary = snapshot.value as? [String: Any] {
//                        for dict in dictionary {
//                            
//                            let valueInDict = dict.value as? [String: Any]
//                            
//                            let keyforShoppingCartId = dict.key
//                            var userUID = valueInDict?["userUID"] as? String
//                            
//                            if userUID == uid {
//                                
//                                for key in self.keysArray {
//                                    FIRDatabase.database().reference().child("order").child(key).child("shoppingCartId").setValue(keyforShoppingCartId)
//                                }
//                                
//                            } else {
//                                return
//                            }
//                            
//                            
//                            
//                        }
//                    }
//                })
//            }
//        })

    @IBAction func informMBTapped(_ sender: Any) {
        // swiftlint:disable:next force_cast
        let digitVC = self.storyboard?.instantiateViewController(withIdentifier: "DigitINfoViewController") as! DigitINfoViewController
        // swiftlint:disable:previous force_cast

        let navigation = self.navigationController

        digitVC.keysArray = keysArray
        digitVC.finalDeliverFee = finalDeliverFee
        digitVC.mealPriceofTotal = mealPriceofTotal

        navigation?.addChildViewController(digitVC)
        navigation?.view.addSubview(digitVC.view)
        digitVC.didMove(toParentViewController: navigation)

        print("favorite button tapped")

    }

}
