//
//  EatTogetherViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/4.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import AddressBookUI
import CoreLocation

class EatTogetherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var rangePicker: UIPickerView!
    
    var distanceArr: [Int] = [50, 100, 150, 200, 250, 300, 400, 500]
    var amountArr: [Int] = [1, 2, 3, 4]
    var addressArr: [String] = []
    
    @IBOutlet weak var addressPicker: UIPickerView!
    
    @IBOutlet weak var amountButton: UIButton!
    
    @IBOutlet weak var addressButton: UIButton!
    
    @IBOutlet weak var rangeButton: UIButton!
    
    @IBOutlet weak var amountPicker: UIPickerView!
    
    var name:String = ""
    
    var distanceLimitation: Double = 50.0
    var distanceInMeters: Double = 0.0
    
    var wishAmount: Int = 1
    var amount: Int = 0
    
    
    var dataArray: [EatTogetherModel] = []
    
    var latCurrent: Double = 0
    var longiCurrent: Double = 0
    var latDestination: Double = 0
    var longiDestination:Double = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var addressInput: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAddress()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        rangePicker.delegate = self
        rangePicker.dataSource = self
        amountPicker.delegate = self
        amountPicker.dataSource = self
        addressPicker.delegate = self
        addressPicker.dataSource = self
        
        
        
        rangePicker.isHidden = true
        addressPicker.isHidden = true
        amountPicker.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "EatTogetherTableViewCell") as! EatTogetherTableViewCell
        // swiftlint:disable:previous force_cast
        
        cell.amountLabel.text = "\(dataArray[indexPath.row].amount)"
        cell.distanceLabel.text = "\(dataArray[indexPath.row].distance)"
        cell.nameLabel.text = dataArray[indexPath.row].name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ChatRoomViewController(collectionViewLayout: UICollectionViewLayout())
        
        vc.toID = dataArray[indexPath.row].key
        vc.toName = dataArray[indexPath.row].name
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case rangePicker :
            return 1
        case amountPicker:
            return 1
        case addressPicker:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case rangePicker :
            return self.distanceArr.count
        case amountPicker:
            return self.amountArr.count
        case addressPicker:
             return addressArr.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case rangePicker :
            return "\(self.distanceArr[row])"
        case amountPicker:
            return "\(self.amountArr[row])"
        case addressPicker:
            return addressArr[row]
        default:
            return ""
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case rangePicker :
            
            rangeButton.setTitle("\(distanceArr[row])", for: .normal)
            rangePicker.isHidden = true
            rangeButton.isHidden = false
            distanceLimitation = Double(distanceArr[row])
            
        case amountPicker:
            
            amountButton.setTitle("\(amountArr[row])", for: .normal)
            amountPicker.isHidden = true
            amountButton.isHidden = false
            wishAmount = amountArr[row]

        case addressPicker:
            
            addressButton.setTitle(addressArr[row], for: .normal)
            addressPicker.isHidden = true
            addressButton.isHidden = false
            addressInput = addressArr[row]
            
            forwardGeocoding2(address: addressInput)
            
        default:
            break
            
        }
    }
    
    func forwardGeocoding(address: String, completion: @escaping () -> Void ) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                print ("first error")
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print ("\(address)")
                print(" for DB address lat: \(coordinate!.latitude), long: \(coordinate!.longitude)")

                
                self.latDestination = coordinate!.latitude
                self.longiDestination = coordinate!.longitude
            }
         
            completion()
        })
        
    }
    
    
    func forwardGeocoding2(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                print ("second error")
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                print("\(address)")
                print("For Input lat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                self.latCurrent = coordinate!.latitude
                self.longiCurrent = coordinate!.longitude
            }
        })
    }

    @IBAction func findButtonTapped(_ sender: Any) {
        dataArray.removeAll()
        FIRDatabase.database().reference().child("eatTogether").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snaps = snapshot.value as? [String: Any] {
                
                for snap in snaps {
                    
                    if let dict = snap.value as? [String: Any] {
                        guard
                            let location = dict["wishLocation"] as? String,
                            let amount = dict["wishAmount"] as? Int,
                            let name = dict["userName"] as? String,
                            let key = snap.key as? String
                        else
                        { return }
                        
                        self.forwardGeocoding(address: location, completion:
                            {
                                
                                self.name = name
//                                self.amount = amount
                                
                                let coordinate1 = CLLocation(latitude: self.latCurrent, longitude: self.longiCurrent)
                                let coordinate2 = CLLocation(latitude: self.latDestination, longitude: self.longiDestination)
                                
                                let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
                                let roundedDistance = Double(round(distanceInMeters * 10)/10)
                                print ("meters \(distanceInMeters)")
                                
                                
                                if roundedDistance <= self.distanceLimitation {
                                    
                                    
                                    switch self.wishAmount {
                                    case 1:
                                        
                                        if amount == 1 || amount == 4 {
                                            let dataToAppend: EatTogetherModel = EatTogetherModel(name: name, distance: roundedDistance, amount: amount, key: key)
                                            self.dataArray.append(dataToAppend)
                                            
                                        } else {
                                            print("amount doesnt match")
                                        }

                                    case 2:
                                        
                                        if amount == 3 {
                                            let dataToAppend: EatTogetherModel = EatTogetherModel(name: name, distance: roundedDistance, amount: amount, key: key)
                                            self.dataArray.append(dataToAppend)
                                            
                                        } else {
                                            print("amount doesnt match")
                                        }
                                        

                                    case 3:
                                        
                                        if amount == 2 {
                                            let dataToAppend: EatTogetherModel = EatTogetherModel(name: name, distance: roundedDistance, amount: amount, key: key)
                                            self.dataArray.append(dataToAppend)
                                            
                                        } else {
                                            print("amount doesnt match")
                                        }
                                    case 4:
                                        if amount == 1  {
                                            let dataToAppend: EatTogetherModel = EatTogetherModel(name: name, distance: roundedDistance, amount: amount, key: key)
                                            self.dataArray.append(dataToAppend)
                                            
                                        } else {
                                            print("amount doesnt match")
                                        }
                                        
                                        
                                        print ("")
                                    default:
                                        break
                                        
                                    }
                                    
                                    self.tableView.reloadData()
                                    
                                } else {
                                    
                                    print ("too far away")

                                }
                        })
                    }
                }
                self.tableView.reloadData()
//                if self.dataArray.count == 0 {
//                    let alert = UIAlertController(title: "無搜尋結果",
//                                                  message: "搜尋範圍內無正在揪團的肌友\n請等待其他肌友糾團\n或重新設定搜尋條件",
//                                                  preferredStyle: .alert)
//                    
//                    let cancel = UIAlertAction(title: "瞭解", style: .destructive, handler: { (action) -> Void in })
//                    alert.addAction(cancel)
//                    self.present(alert, animated: true, completion: nil)
//                    
//                    print (" all are too far away")
//                }
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                FIRDatabase.database().reference().child("eatTogether").child(uid!).updateChildValues(["wishAmount": self.wishAmount])
                FIRDatabase.database().reference().child("eatTogether").child(uid!).updateChildValues(["wishLocation": self.addressInput])
                FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: Any] {
                        guard
                            let name = dict["name"] as? String else { return }
                        
                        FIRDatabase.database().reference().child("eatTogether").child(uid!).updateChildValues(["userName": name])
                    }
                })
            }
        })
    }
    
    
    @IBAction func rangeButtonTapped(_ sender: Any) {
        
        rangePicker.isHidden = false
        rangeButton.isHidden = true
    }
    
    @IBAction func amountButtonTapped(_ sender: Any) {
        
        amountPicker.isHidden = false
        amountButton.isHidden = true
    }

    @IBAction func addressButtonTapped(_ sender: Any) {
        
        addressPicker.isHidden = false
        addressButton.isHidden = true
        
    }
    
    
    func fetchAddress() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let mainAdd = dict["mainAdd"] as? String
                let mainDetail = dict["mainDetail"] as? String
                let add = "\(mainAdd!)\(mainDetail!)"
                for x in 1...(dict.count / 2) - 1 {
                    
                    let street = dict["add\(x)"] as? String
                    let address = dict["detail\(x)"] as? String
                    let finalAdd = street! + address!
                    
                    self.addressArr.append(finalAdd)
                    self.addressButton.setTitle("\(mainAdd!)\(mainDetail!)", for: .normal)
                    
                    self.forwardGeocoding2(address: add)
                }
                

            }
            
            self.addressPicker.reloadAllComponents()
        })
    }

}
