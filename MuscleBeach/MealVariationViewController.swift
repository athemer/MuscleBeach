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
            
            deliverFee.text = "\(singleDayDeliverFee * dateToDB.count)"
            totalPrice.text = "\((Int(cell0.stepper.value) * 120 + Int(cell1.stepper.value) * 120 + Int(cell2.stepper.value) * 150 + singleDayDeliverFee) * dateToDB.count)"
            
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
    @IBAction func confirmTapped(_ sender: Any) {
        
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
        
        if timeSegment.selectedSegmentIndex == 0 {
            timeToDB = "午餐"
        } else if timeSegment.selectedSegmentIndex == 1 {
            timeToDB = "晚餐"
        }
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let meal: [String: Int] = ["typeA": Int(cell0.stepper.value) ,"typeB": Int(cell1.stepper.value), "typeC": Int(cell2.stepper.value)]
        
        for date in dateToDB {
            let orderData: [String: AnyObject] = ["date": date as AnyObject, "deliver": deliverToDB as AnyObject, "locationArea": locationAreaToDB as AnyObject, "locationDetail": locationDetailToDB as AnyObject, "userUID": uid as AnyObject, "time": timeToDB as AnyObject, "meal" : meal as AnyObject]
            FIRDatabase.database().reference().child("order").childByAutoId().setValue(orderData)
        }
        
    }
}
