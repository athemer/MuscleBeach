//
//  ConfirmDeliverAdViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/27.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class ConfirmDeliverAdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var mainAddressLabel: UILabel!

    @IBOutlet weak var detailAddressLabel: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!

    var deliverToDB: String = ""

    var toWhichPage: String = ""

    var addressArr: [String] = []

    var mainAdd: [String] = []
    var detailAdd: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self

        pickerView.isHidden = true

        fetchAddress()

        print ("quickCHECK \(deliverToDB)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addressArr.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return addressArr[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mainAddressLabel.text = mainAdd[row]
        detailAddressLabel.text = detailAdd[row]

        pickerView.isHidden = true

        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainAdd": mainAddressLabel.text])
        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainDetail": detailAddressLabel.text])

    }

    func fetchAddress() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let mainAdd = dict["mainAdd"] as? String
                let mainDetail = dict["mainDetail"] as? String

                for x in 1...(dict.count / 2) - 1 {

                    let street = dict["add\(x)"] as? String
                    let address = dict["detail\(x)"] as? String
                    let finalAdd = street! + address!

                    self.mainAdd.append(street!)
                    self.detailAdd.append(address!)
                    self.addressArr.append(finalAdd)

                }

                self.mainAddressLabel.text = mainAdd!
                self.detailAddressLabel.text = mainDetail!
            }
            self.pickerView.reloadAllComponents()
        })
    }

    @IBAction func changeMainAd(_ sender: Any) {
        pickerView.isHidden = false
    }

    @IBAction func confirmTapped(_ sender: Any) {

        guard
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"SingleOrderViewController") as? SingleOrderViewController,
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"WeekMenuSelectionViewController") as? WeekMenuSelectionViewController else { return }

        if toWhichPage == "single" {
            vc1.deliverToDB = self.deliverToDB
            vc1.locationDetailToDB = detailAddressLabel.text!
            vc1.locationAreaToDB = mainAddressLabel.text!

            self.navigationController?.pushViewController(vc1, animated: true)

        } else if toWhichPage == "multiple" {

            vc2.deliverToDB = self.deliverToDB
            vc2.locationDetailToDB = detailAddressLabel.text!
            vc2.locationAreaToDB = mainAddressLabel.text!

            self.navigationController?.pushViewController(vc2, animated: true)
        }

    }
}
