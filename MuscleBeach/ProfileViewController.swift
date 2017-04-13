//
//  ProfileViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var orderAddress: UITextField!

    var addressArray: [String] = ["中山區"]

    var addressArrFromDatabase: [String] = []
    var addressDetailArrFromDatabase: [String] = []

    let arr: [String] = ["台北市中山區", "台北市大同區", "台北市南港區", "台北市信義區", "台北市大安區", "台北市文山區", "台北市北投區", "台北市士林區", "台北市萬華區", "台北市內湖區"]

    var areaTextField: UITextField?
    var addressTextField: UITextField?

    enum Content {
        case addressCell
        case addCell
    }

    var contentArr: [Content] = [.addCell, .addressCell]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
        profileImageView.isUserInteractionEnabled = true

        registerCell()
        fetchAddressFromDatabase()
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
            return addressArrFromDatabase.count
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
            cell.addressLabel.text = addressArrFromDatabase[indexPath.row]
            cell.addressDetailLabel.text = addressDetailArrFromDatabase[indexPath.row]

            return cell

        case .addCell:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePageAddCell") as! ProfilePageAddCell
            // swiftlint:disable:previous force_cast

            cell.addAddressButton.addTarget(self, action: #selector(setUpAlert), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentArr[indexPath.section] {
        case .addressCell:
            let uid = FIRAuth.auth()?.currentUser?.uid
            orderAddress.text = addressArrFromDatabase[indexPath.row] + addressDetailArrFromDatabase[indexPath.row]

            FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainAdd": addressArrFromDatabase[indexPath.row]])
            FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainDetail": addressDetailArrFromDatabase[indexPath.row]])
        case .addCell:
//            setUpAlert()
            print ("do nothing")

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch contentArr[indexPath.section] {
        case .addressCell:
            return 60
        case .addCell:
            return 60
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

        areaTextField?.text = arr[row]

        print ("\(arr[row])")
    }

    func registerCell() {
        let addressNib = UINib(nibName: "ProfilePageAddressCell", bundle: nil)
        let addNib = UINib(nibName: "ProfilePageAddCell", bundle: nil)
        tableView.register(addressNib, forCellReuseIdentifier: "ProfilePageAddressCell")
        tableView.register(addNib, forCellReuseIdentifier: "ProfilePageAddCell")
    }

    func setUpAlert() {

        let alert = UIAlertController(title: "新增外送地址",
                                      message: "請輸入外地址\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        // Picker
        let frame = CGRect(x: 30, y: 50, width: 200, height: 120)
        let picker: UIPickerView = UIPickerView(frame: frame)
        picker.dataSource = self
        picker.delegate = self
        alert.view.addSubview(picker)

        alert.addTextField { (textField: UITextField) in
            self.areaTextField = textField
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "行政區"
            textField.clearButtonMode = .whileEditing
        }

        alert.addTextField { (textField: UITextField) in
            self.addressTextField = textField
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "地址"
            textField.clearButtonMode = .whileEditing
        }

        let submitAction = UIAlertAction(title: "確定", style: .default, handler: { (_) -> Void in
            // Get 1st TextField's text
            //let textField = self.alert.textFields![0]
            //print(textField.text!)

            guard
                let textFields = alert.textFields,
                textFields.count >= 2
                else {

                    // todo: error handling

                    return

                }

            guard
                let street = textFields[0].text
                else {

                    // todo: error handling

                    return

                }

            guard
                let address = textFields[1].text
                else {

                    // todo: error handling

                    return

                }

            let finalAddress = "\(street) \(address)"
            let uid = FIRAuth.auth()?.currentUser?.uid
            let x = self.addressArrFromDatabase.count + 1
            FIRDatabase.database().reference().child("users").child(uid!).child("address").child("add\(x)").setValue(street)
            FIRDatabase.database().reference().child("users").child(uid!).child("address").child("detail\(x)").setValue(address)

            self.addressArrFromDatabase.append(street)
            self.addressDetailArrFromDatabase.append(address)
            self.tableView.reloadData()

//            if alert.textFields?[0] != nil && alert.textFields?[1] != nil {
//                let address = "\((alert.textFields?[0].text)!) \((alert.textFields?[1].text)!)"
//                print(address)
//                self.addressArray.append(address)
//                self.tableView.reloadData()
//            } else {
//                print ("please insert value")
//            }
        })
        let cancel = UIAlertAction(title: "取消", style: .destructive, handler: { (_) -> Void in })

        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func fetchAddressFromDatabase() {

        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in
            if let addressDict = snapshot.value as? [String: AnyObject] {

                print("hoho \(addressDict )")

                for x in 1...(addressDict.count / 2) - 1 {

                    // swiftlint:disable:next force_cast
                    let street = addressDict["add\(x)"] as! String
                    // swiftlint:disable:previous force_cast

                    // swiftlint:disable:next force_cast
                    let address = addressDict["detail\(x)"] as! String
                    // swiftlint:disable:previous force_cast

                    self.addressArrFromDatabase.append(street)
                    self.addressDetailArrFromDatabase.append(address)
                }
                print (self.addressArrFromDatabase)

            }
            self.tableView.reloadData()
        })

    }

}
