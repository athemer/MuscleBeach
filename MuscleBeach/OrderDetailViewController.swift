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
    
    
    var reorderDataPassed: [ReoderModel] = []
    
    
    var arr: [[String: AnyObject]] = []
    
    var deliverArr: [AnyObject] = []
    var timeArr: [AnyObject] = []
    var locationAreaArr: [AnyObject ] = []
    var locationDetailArr: [AnyObject] = []
    var mealArr: [String: Int] = [:]
    var typeAAmount: [AnyObject] = []
    var typeBAmount: [AnyObject] = []
    var typeCAmount: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateLabel.text = date
        
        print ("isssss \(reorderDataPassed.count)")

        
        
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
        return reorderDataPassed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
        // swiftlint:disable:previous force_cast
        
        cell.deliverInfo.text = reorderDataPassed[indexPath.row].delvier
        cell.timeInfo.text = reorderDataPassed[indexPath.row].time
        cell.locationInfo.text = reorderDataPassed[indexPath.row].locationArea
        cell.locationDetail.text = reorderDataPassed[indexPath.row].locationDetail
        cell.typeAAmount.text = "\(reorderDataPassed[indexPath.row].mealTypeAAmount)"
        cell.typeBAmount.text = "\(reorderDataPassed[indexPath.row].mealTypeBAmount)"
        cell.typeCAmount.text = "\(reorderDataPassed[indexPath.row].mealTypeCAmount)"
        cell.reorderButton.addTarget(self, action: #selector(reorderAction), for: .touchUpInside)
        
        return cell
    }

    func reorderAction (sender: UIButton) {

        // swiftlint:disable:next force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpReorderCalendarViewController") as! PopUpReorderCalendarViewController
        // swiftlint:disable:previous force_cast
        
        guard let cell = sender.superview?.superview?.superview as? OrderDetailTableViewCell else {
            print ("bababa")
            return }
        let indexPath = self.tableView.indexPath(for: cell)!
        
        let navigation = self.navigationController
        
        vc.key = reorderDataPassed[indexPath.row].key
        
        
        navigation?.addChildViewController(vc)
        navigation?.view.addSubview(vc.view)
        vc.didMove(toParentViewController: navigation)
        
        
    }

}
