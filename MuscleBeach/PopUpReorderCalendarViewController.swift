//
//  PopUpReorderCalendarViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/2.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class PopUpReorderCalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    @IBOutlet weak var calendarView: JTAppleCalendarView!

    @IBOutlet weak var monthLabel: UILabel!

    @IBOutlet weak var timeSeg: UISegmentedControl!

    var key: String = ""
    var date: String = ""
    var dateSelected: String = ""

    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)       // default is (3,3)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"

        let startDate = formatter.date(from: "2017 01 01")!         // You can use date generated from a formatter
        let endDate = formatter.date(from: "2017 12 31")!           // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid ,
            firstDayOfWeek: .sunday)
        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {

        guard let myCustomCell = cell as? CellView else { return }

        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text

        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)

        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.isHidden = false
        } else {
            myCustomCell.isHidden = true
        }

    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: visibleDates.monthDates.first!)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)

        dateSelected = localDate

        print ("aHA \(localDate)")
        print ("COUNT \(calendarView.selectedDates.count)")
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)

        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleDayCellView, cellState: CellState) -> Bool {

        if cellState.dateBelongsTo == .thisMonth, cellState.day != .sunday, cellState.day != .saturday {
                return true
        } else {
            return false
        }
    }

    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {

        guard let myCustomCell = view as? CellView  else {
            return
        }

        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = darkPurple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = white
            } else {
                myCustomCell.dayLabel.textColor = dimPurple
            }
        }
    }

    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }

        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius = 20
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }

    @IBAction func confirmTapped(_ sender: Any) {

        var time: String = ""

        if timeSeg.selectedSegmentIndex == 0 {
            time == "午餐"
            FIRDatabase.database().reference().child("order").child(self.key).updateChildValues(["time": "午餐"])
        } else if timeSeg.selectedSegmentIndex == 1 {
            time == "晚餐"
            FIRDatabase.database().reference().child("order").child(self.key).updateChildValues(["time": "晚餐"])
        }

        FIRDatabase.database().reference().child("order").child(self.key).updateChildValues(["date": dateSelected])

        self.willMove(toParentViewController: nil)

        self.view.removeFromSuperview()

        self.removeFromParentViewController()
        navigationController?.popToRootViewController(animated: true)

    }

    @IBAction func cancelTapped(_ sender: Any) {

        self.willMove(toParentViewController: nil)

        self.view.removeFromSuperview()

        self.removeFromParentViewController()

    }

}
