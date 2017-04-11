//
//  SelfPickUpViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class SelfPickUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    //Data to Pass

    var deliverToDB: String = ""

    var toWhichPage: String = ""

    let theNameArr: [String] = ["自取地點一", "自取地點二"]
    let nameArr: [String] = ["城市草倉 C-tea loft", "肌肉海灘工作室"]
    let addressArr: [String] = ["台北市大安區羅斯福路三段283巷19弄4號", "信義區和平東路三段391巷8弄30號1樓"]
    let numberArr: [String] = ["02 2366 0381", "02 2366 0381"]
    let latitudeArr: [Double] = [25.0194332, 25.020501]
    let longitudeArr: [Double] = [121.5314772, 121.557314]
    let imageArr: [String] = ["c-tea", "MBLogo"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

         print ("quickCHECK \(deliverToDB)")
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
        cell.selfPickUpImage.image = UIImage(named: imageArr[indexPath.row])
//        cell.mapButton.tag = indexPath.row
        cell.mapButton.addTarget(self, action: #selector(moveToMapPage), for: .touchUpInside)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"SingleOrderViewController") as? SingleOrderViewController,
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"WeekMenuSelectionViewController") as? WeekMenuSelectionViewController else { return }

        if toWhichPage == "single" {
            vc1.deliverToDB = self.deliverToDB
            vc1.locationDetailToDB = nameArr[indexPath.row]
            vc1.locationAreaToDB = theNameArr[indexPath.row]

            self.navigationController?.pushViewController(vc1, animated: true)
        } else if toWhichPage == "multiple" {

            vc2.deliverToDB = self.deliverToDB
            vc2.locationDetailToDB = nameArr[indexPath.row]
            vc2.locationAreaToDB = theNameArr[indexPath.row]

            self.navigationController?.pushViewController(vc2, animated: true)
        }

        return
    }

    func moveToMapPage(sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"PickUpLocationViewController") as? PickUpLocationViewController else { return }
        guard let cell = sender.superview?.superview as? SelfPickUpTableViewCell else { return }
        let indexPath = self.tableView.indexPath(for: cell)

        vc.name = nameArr[(indexPath?.row)!]
        vc.number = numberArr[(indexPath?.row)!]
        vc.address = addressArr[(indexPath?.row)!]
        vc.latitude = latitudeArr[(indexPath?.row)!]
        vc.longitude = longitudeArr[(indexPath?.row)!]

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func confirmTapped(_ sender: Any) {

    }

}
