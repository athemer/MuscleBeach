//
//  EatTogetherViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/4.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI
import CoreLocation

class EatTogetherViewController: UIViewController {

    var latOne: Double = 0
    var longiOne: Double = 0
    var latTwo: Double = 0
    var longiTwo:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forwardGeocoding(address: "台北市信義區基隆路一段178號")
        forwardGeocoding2(address: "台北市臨沂街33巷20號")
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("lat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                self.latOne = coordinate!.latitude
                self.longiOne = coordinate!.longitude
            }
        })
    }
    
    
    func forwardGeocoding2(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("lat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                self.latTwo = coordinate!.latitude
                self.longiTwo = coordinate!.longitude
            }
        })
    }

}
