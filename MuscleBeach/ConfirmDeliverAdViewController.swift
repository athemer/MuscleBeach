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
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var addressArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.isHidden = true
        
        fetchAddress()
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
        mainAddressLabel.text = addressArr[row]
        pickerView.isHidden = true
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["main": mainAddressLabel.text])

        
    }
    
    func fetchAddress() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let main = dict["main"] as? String
                
                for x in 1...dict.count - 1 {
                    
                    let address = dict["add\(x)"] as? String
                    self.addressArr.append(address!)
                    
                }

                self.mainAddressLabel.text = main
            }
            self.pickerView.reloadAllComponents()
        })
    }
    
    @IBAction func changeMainAd(_ sender: Any) {
        pickerView.isHidden = false
    }

    @IBAction func confirmTapped(_ sender: Any) {
    }
}
