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
    
    var mealArr: [String] = ["仙女餐", "享瘦餐", "猛男餐"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        
        guard let cell = sender.superview?.superview as? MealVariTableViewCell else { return }
        
        cell.amountLabel.text = "\(Int(cell.stepper.value))"
    }

    @IBAction func segmentChange(_ sender: Any) {
        
        if timeSegment.selectedSegmentIndex == 1 {
            backgroundView.backgroundColor = UIColor.brown
        } else {
            backgroundView.backgroundColor = UIColor.darkGray
        }
    }
    @IBAction func confirmTapped(_ sender: Any) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let meal: [String: Int] = ["typeB": 2, "typeC": 6]
        let orderData: [String: AnyObject] = ["date": "2017-03-29" as AnyObject, "deliver": "deliver" as AnyObject, "locationArea": "台北市信義區" as AnyObject, "locationDetail": "基隆路一段" as AnyObject, "userUID": uid as AnyObject, "time": "dinner" as AnyObject, "meal" : meal as AnyObject]
        FIRDatabase.database().reference().child("order").childByAutoId().setValue(orderData)
        
        
    }
}
