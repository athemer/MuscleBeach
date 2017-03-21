//
//  ProfileViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var orderAddress: UITextField!
    var addressArray: [String] = ["中山區"]
    
    enum Content {
        case addressCell
        case addCell
    }
    
    var contentArr: [Content] = [.addressCell, .addCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentArr[section] {
        case .addressCell:
            return addressArray.count
        case .addCell:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentArr[indexPath.section] {
        case .addressCell:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePageAddressCell") as! ProfilePageAddressCell
            // swiftlint:disable:previous force_cast
            cell.addressLabel.text = addressArray[indexPath.row]
            
            return cell
            
        case .addCell:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePageAddCell") as! ProfilePageAddCell
            // swiftlint:disable:previous force_cast

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentArr[indexPath.section] {
        case .addressCell:
            
            orderAddress.text = addressArray[indexPath.row]
            
        case .addCell:
            print ("add")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch contentArr[indexPath.section] {
        case .addressCell:
            return 100
        case .addCell:
            return 100
        }
    }
    
    func registerCell() {
        let addressNib = UINib(nibName: "ProfilePageAddressCell", bundle: nil)
        let addNib = UINib(nibName: "ProfilePageAddCell", bundle: nil)
        tableView.register(addressNib, forCellReuseIdentifier: "ProfilePageAddressCell")
        tableView.register(addNib, forCellReuseIdentifier: "ProfilePageAddCell")
    }
}

