//
//  SelfPickUpViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SelfPickUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let nameArr: [String] = ["城市草倉 C-tea loft", "肌肉海灘工作室"]
    let addressArr: [String] = ["台北市大安區羅斯福路三段283巷19弄4號", "信義區和平東路三段391巷8弄30號1樓"]
    let numberArr: [String] = ["02 2366 0381","02 2366 0381"]
    
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
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelfPickUpTableViewCell", for: indexPath) as! SelfPickUpTableViewCell
        // swiftlint:disable:previous force_cast
        cell.selfPickUpName.text = nameArr[indexPath.row]
        cell.selfPickUpAddress.text = addressArr[indexPath.row]
        cell.selfPickUpNumber.text = numberArr[indexPath.row]
        
        return cell
    }
    
    
}
