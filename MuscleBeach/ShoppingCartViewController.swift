//
//  ShoppingCartViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/28.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase




class ShoppingCartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ValueChangedDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var mealPrice: UILabel!
    
    
    @IBOutlet weak var deliverPrice: UILabel!
    
    var orderDataToCart: [OrderModel] = []
    
    var keysArray: [String] = []
    
    
    var mealPriceofTotal: Int = 0
    var finalDeliverFee: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchDataFromFirebase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
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
        cell.address.text = orderDataToCart[indexPath.row].locationArea
        cell.addressDetail.text = orderDataToCart[indexPath.row].locationDetail
        cell.deliver.text = orderDataToCart[indexPath.row].delvier
        cell.typeAAmount.text = "\(orderDataToCart[indexPath.row].mealTypeAAmount)"
        cell.typeBAmount.text = "\(orderDataToCart[indexPath.row].mealTypeBAmount)"
        cell.typeCAmount.text = "\(orderDataToCart[indexPath.row].mealTypeCAmount)"
        cell.price.text = "\(orderDataToCart[indexPath.row].price)"
        cell.time.text = orderDataToCart[indexPath.row].time
        cell.deliverFee.text = "\(orderDataToCart[indexPath.row].delvierFee)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            orderDataToCart.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "刪除") { action, index in
            self.orderDataToCart.remove(at: index.row)
            self.tableView.reloadData()
            
            let key = self.orderDataToCart[index.row].key
            FIRDatabase.database().reference().child("order").child(key).removeValue()

            
            
            print("more button tapped")
        }
        delete.backgroundColor = .red
        
        let revise = UITableViewRowAction(style: .normal, title: "更改") { action, index in
            
            let key = self.orderDataToCart[index.row].key
            
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
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
    
    func fetchDataFromFirebase () {
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
                                let key = snap.key as? String
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
                                
                                let toAppend: OrderModel = OrderModel(date: date, delvier: deliver, locationArea: deliverLocationArea, locationDetail: deliverLocationDetail , mealTypeAAmount: typeAAmount, mealTypeBAmount: typeBAmount, mealTypeCAmount: typeCAmount, time: deliverTime, price: price, deliverFee: deliverFee, key: key)
                                
                                self.orderDataToCart.append(toAppend)
                                
                                
                            } else {
                                print ("not cool")
                            }

                            
                        
                        }
                    }

                }
            self.tableView.reloadData()
            print ("ala \(self.orderDataToCart)")
        })
        
        
    }
    
    
    
    
    @IBAction func butTapped(_ sender: Any) {
        
        getPrice()
    }
    
    
    
    func getPrice () {
        
        let days = orderDataToCart.count
        
        var mealPrice: Int = 0
        
        
        
        var deliverDateNumber: Int = 0
        
        
        for x in 0...days - 1  {
            let singleDayPrice = orderDataToCart[x].price
            
            if orderDataToCart[x].delvier == "外送" {
                deliverDateNumber += 1
            }
            mealPrice += singleDayPrice
        }
        
        self.mealPrice.text = "\(mealPrice)"
        self.mealPriceofTotal = mealPrice
        countDeliverFee(deliverDateNumber: deliverDateNumber)
 
    }
    
    func countDeliverFee (deliverDateNumber: Int) {
        
        print ("CHECK HERE \(deliverDateNumber)")
        
        let days = orderDataToCart.count
        var totalDeliverFee: Int = 0
        var finalDeliverFee: Int = 0
        
        for x in 0...days - 1 {
            
            totalDeliverFee += orderDataToCart[x].delvierFee
            
        }
        
        if deliverDateNumber >= 2 && deliverDateNumber <= 10 {
            
            finalDeliverFee = (totalDeliverFee / 10 * 8)
            discountLabel.text = "20%"
            print ("80%")
        } else if deliverDateNumber > 11 && deliverDateNumber <= 15 {
            
            finalDeliverFee = (totalDeliverFee / 10 * 7)
            
            discountLabel.text = "30%"
            print ("70%")
        } else if deliverDateNumber > 15 {
            
            discountLabel.text = "40%"
            finalDeliverFee = (totalDeliverFee / 10 * 6)
            
            print ("60%")
        } else {
            print ("bang bang ")
        }
        
        deliverPrice.text = "\(finalDeliverFee)"
        
        self.finalDeliverFee = finalDeliverFee
    }
    

    @IBAction func informTapped(_ sender: Any) {
        
        let price = self.finalDeliverFee + self.mealPriceofTotal
        let uid = FIRAuth.auth()?.currentUser?.uid
        for key in keysArray {
            FIRDatabase.database().reference().child("order").child(key).updateChildValues(["paymentClaim" : "true"])
            
            FIRDatabase.database().reference().child("shoppingCart").childByAutoId().updateChildValues([key: "true", "userUID" : uid, "price": price])
            
        }
        
        
        
        
    }
    
    
    
}
