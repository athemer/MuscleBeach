//
//  OrderDetailViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/25.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var date: String = ""
    
    var arr: [[String: AnyObject]] = []
    
    var deliverArr: [AnyObject] = []
    var timeArr: [AnyObject] = []
    var locationAreaArr: [AnyObject ] = []
    var locationDetailArr: [AnyObject] = []
    var mealArr: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateLabel.text = date
        
        

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
        return deliverArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
        // swiftlint:disable:previous force_cast
        
        // swiftlint:disable:next force_cast
        cell.deliverInfo.text = deliverArr[indexPath.row] as! String
        // swiftlint:disable:previous force_cast
        
        // swiftlint:disable:next force_cast
        cell.timeInfo.text = timeArr[indexPath.row] as! String
        // swiftlint:disable:previous force_cast
        
        // swiftlint:disable:next force_cast
        cell.locationInfo.text = locationAreaArr[indexPath.row] as! String
        // swiftlint:disable:previous force_cast

        return cell
    }

/*    func fetchData() {

        arr.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("order").queryOrdered(byChild: "userUID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapData = snapshot.value as? [String: AnyObject] {
                for snap in snapData {
                    if let data = snap.value as? [String: AnyObject] {
                        self.arr.append(data)
                    }
                }
            }
            
            let datePredicate = NSPredicate(format: "date == %@", self.date)
            let filtered = (self.arr as NSArray).filtered(using: datePredicate)
            print ("check \(filtered)")
            
            for x in 0...filtered.count - 1 {
            guard
                let dict: [String : AnyObject] = filtered[x] as? [String : AnyObject],
                let deliverType = dict["deliver"] as? String,
                let deliverTime = dict["time"] as? String,
                let deliverLocationArea = dict["locationArea"] as? String,
                let delvierLocationDetail = dict["locationDetail"] as? String
            else { return }
                
                
                self.deliverArr.append(deliverType)
                self.timeArr.append(deliverTime)
                self.locationAreaArr.append(deliverLocationArea)
                self.locationDetailArr.append(delvierLocationDetail)
                
                
            }
            print(" lol \(self.deliverArr)")
            self.tableView.reloadData()
        })
        
        
    }
 */

}
