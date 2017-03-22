//
//  PickUpLocationViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/22.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import MapKit

class PickUpLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var longitude: Double = 0
    var latitude: Double = 0
    var name: String = ""
    var number: String = ""
    var address: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.delegate = self
        self.mapView.mapType = MKMapType.standard
        
        let latDelta = 0.01
        let longDelta = 0.01
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let center: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        self.mapView.setRegion(currentRegion, animated: true)
        
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: latitude, longitude: longitude).coordinate
        self.mapView.addAnnotation(objectAnnotation)
        mapView.view(for: objectAnnotation)
        
        
        numberLabel.text = number
        nameLabel.text = name
        addressLabel.text = address
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
