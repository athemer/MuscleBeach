//
//  ProfileViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var orderAddress: UITextField!
    var addressArray: [String] = ["中山區"]
    let arr: [String] = ["中山區" ,"大同區", "南港區", "信義區", "大安區"]
    let alert = UIAlertController(title: "新增外送地址",
                                  message: "請輸入外地址\n\n\n\n\n\n台北市",
                                  preferredStyle: .alert)
    
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
            setUpAlert()
            
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        alert.textFields?[0].text = arr[row]
        
        
        print ("\(arr[row])")
    }
    
    
    func registerCell() {
        let addressNib = UINib(nibName: "ProfilePageAddressCell", bundle: nil)
        let addNib = UINib(nibName: "ProfilePageAddCell", bundle: nil)
        tableView.register(addressNib, forCellReuseIdentifier: "ProfilePageAddressCell")
        tableView.register(addNib, forCellReuseIdentifier: "ProfilePageAddCell")
    }
    
    func setUpAlert() {

        // Picker
        let frame = CGRect(x: 40, y: 40, width: 100, height: 100)
        let picker: UIPickerView = UIPickerView(frame: frame)
        picker.dataSource = self
        picker.delegate = self
        alert.view.addSubview(picker)
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "行政區"
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "地址"
            textField.clearButtonMode = .whileEditing
        }

        let submitAction = UIAlertAction(title: "確定", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = self.alert.textFields![0]
            print(textField.text!)
        })
        let cancel = UIAlertAction(title: "取消", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }

}

