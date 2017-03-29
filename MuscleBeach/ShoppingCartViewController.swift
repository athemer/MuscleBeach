//
//  ShoppingCartViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/28.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class ShoppingCartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var orderDataToCart: [OrderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchDataFromFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell") as! ShoppingCartTableViewCell
        // swiftlint:disable:previous force_cast

        return cell
    }
    
    func fetchDataFromFirebase () {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("order").queryOrdered(byChild: "userUID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapData = snapshot.value as? [String: AnyObject] {
                    for snap in snapData {
                        if let data = snap.value as? [String: AnyObject] {
                            print ("CD \(data)")
 
        
                                let deliverType = data["deliver"]
                                let deliverTime = data["time"]
                                let deliverLocationArea = data["locationArea"]
                                let delvierLocationDetail = data["locationDetail"]
                            
                            guard
                                let paymentStatus = data["paymentStatus"] as? String,
                                let meal = data["meal"] as? AnyObject
                                else { return }
                            
                            // swiftlint:disable:next force_cast
                                let typeBAmount = meal["typeB"] as! Int
                            // swiftlint:disable:previous force_cast
                            // swiftlint:disable:next force_cast
                                let typeCAmount = meal["typeC"] as! Int
                            // swiftlint:disable:previous force_cast
                            // swiftlint:disable:next force_cast
                                let typeAAmount = meal["typeA"] as! Int
                            // swiftlint:disable:previous force_cast
                            
//                            let filteredData = data.filter({ (key, value) -> Bool in
//                                
//                                guard let stringValue = value as? String else { return false }
//                                
//                                return key == "paymentStatus" && stringValue == "uppaid"
//                                
//                            })
                            
                            let price: Int = typeAAmount * 120 + typeBAmount * 120 + typeCAmount * 150
                            var deliverFee: Int = 0
                            let totalAmount: Int = typeAAmount + typeBAmount + typeCAmount
                            
                            if totalAmount > 1 && totalAmount < 5{
                                deliverFee = 60
                            } else if totalAmount >= 5  {
                                deliverFee = 0
                            } else {
                                print ("overload")
                            }
                            
                            

                            if paymentStatus == "unpaid" {
                                print ("cool")
                                
                                
                                
                                
                            } else {
                                print ("not cool")
                            }
                            
                            
                            
                            
//                            for (key, value) in data {
//                                if key == "paymentStatus" && value as! String == paymentStatus {
//                                    
//                                } else {
//                                    
//                                }
//                            }
                            
//                            data.forEach({ (key, value) in
//                                
//                            })
                            
                        
                        }
                    }

                }

        })
        
        
    }
    
    
}
