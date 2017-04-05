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

class EatTogetherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var amountTestField: UITextField!
    
    @IBOutlet weak var distanceTextfield: UITextField!
    
    
    var name:String = ""
    var distanceInMeters: Double = 0.0
    var amount: Int = 0
    
    
    var dataArray: [EatTogetherModel] = []
    
    var latCurrent: Double = 0
    var longiCurrent: Double = 0
    var latDestination: Double = 0
    var longiDestination:Double = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    let addressInput: String = "台北市士林區天母西路1號"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forwardGeocoding2(address: addressInput)

        tableView.delegate = self
        tableView.dataSource = self
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
        
        FIRDatabase.database().reference().child("eatTogether").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snaps = snapshot.value as? [String: Any] {
                
                for snap in snaps {
                    
                    if let dict = snap.value as? [String: Any] {
                        guard
                            let location = dict["wishLocation"] as? String,
                            let amount = dict["wishAmount"] as? Int,
                            let userData = dict["userData"] as? [String: Any],
                            let name = userData["userName"] as? String
                        else
                        { return }
                        
                        self.forwardGeocoding(address: location, completion:
                            {
                                
                                self.name = name
                                self.amount = amount
                                
                                let coordinate1 = CLLocation(latitude: self.latCurrent, longitude: self.longiCurrent)
                                let coordinate2 = CLLocation(latitude: self.latDestination, longitude: self.longiDestination)
                                
                                let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
                                let roundedDistance = Double(round(distanceInMeters * 10)/10)
                                print ("meters \(distanceInMeters)")
                                
                                
                                if roundedDistance <= 2000.0 {
                                    
                                    let dataToAppend: EatTogetherModel = EatTogetherModel(name: name, distance: roundedDistance, amount: amount)
                                    self.dataArray.append(dataToAppend)
                                    self.tableView.reloadData()
                                    
                                } else {
                                    
                                    let alert = UIAlertController(title: "無搜尋結果",
                                                                  message: "您所設定的搜尋範圍內無正在揪團的肌友\n若有新的肌友糾團訂購會再進行通知",
                                                                 preferredStyle: .alert)
                                    
                                    let cancel = UIAlertAction(title: "瞭解", style: .destructive, handler: { (action) -> Void in })
                                    alert.addAction(cancel)
                                    self.present(alert, animated: true, completion: nil)

                                    print ("too far away")
                                }
                        })
                    }
                }
            }
        })
    }
}
