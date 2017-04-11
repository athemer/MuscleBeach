//
//  WeekMenuSelectionViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/27.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class WeekMenuSelectionViewController: UIViewController {

    var deliverToDB: String = ""
    var locationAreaToDB: String = ""
    var locationDetailToDB: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dayButton(_ sender: Any) {

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as? CalendarViewController else { return }
        vc.daysLimitation = 5
        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.locationDetailToDB
        vc.locationAreaToDB = self.locationAreaToDB

        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func tenDayButton(_ sender: Any) {

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as? CalendarViewController else { return }
        vc.daysLimitation = 10
        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.locationDetailToDB
        vc.locationAreaToDB = self.locationAreaToDB
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func fifteenDayButton(_ sender: Any) {

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as? CalendarViewController else { return }
        vc.daysLimitation = 15
        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.locationDetailToDB
        vc.locationAreaToDB = self.locationAreaToDB
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func twDayButton(_ sender: Any) {

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as? CalendarViewController else { return }
        vc.daysLimitation = 20
        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.locationDetailToDB
        vc.locationAreaToDB = self.locationAreaToDB
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
