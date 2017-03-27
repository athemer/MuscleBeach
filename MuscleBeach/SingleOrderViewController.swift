//
//  SingleOrderViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/27.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SingleOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dateArr: [String] = ["2017-03-20", "2017-03-21", "2017-03-22", "2017-03-23", "2017-03-24"]
    
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
        return dateArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleOrderTableViewCell") as! SingleOrderTableViewCell
        // swiftlint:disable:previous force_cast
        
        cell.dateLabel.text = dateArr[indexPath.row]
        
        return cell
    }
    
}
