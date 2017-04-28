//
//  CalendarViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/23.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    @IBOutlet weak var calendarView: JTAppleCalendarView!

    @IBOutlet weak var moreDaysToGo: UILabel!

    @IBOutlet weak var haveAlreay: UILabel!

    @IBOutlet weak var discountLabel: UILabel!

    @IBOutlet weak var toHide: UILabel!
    var daysToGo: Int = 0
    var dateToDB: [String] = []
    var deliverToDB: String = ""
    var locationAreaToDB: String = ""
    var locationDetailToDB: String = ""

    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var monthLabel: UILabel!

    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)

    override func viewDidLoad() {
        super.viewDidLoad()

        print ("bobo \(deliverToDB) \(locationDetailToDB) \(locationAreaToDB)")
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)       // default is (3,3)
        // Do any additional setup after loading the view, typically from a nib.

        calendarView.allowsMultipleSelection  = true
        calendarView.rangeSelectionWillBeUsed = true
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

        let number: Int = calendarView.selectedDates.count
        daysLeft.text = "\(number)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)

        self.dateToDB.append(localDate)

        print ("aHA \(localDate)")
        print ("COUNT \(calendarView.selectedDates.count)")
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        

        countDiscount(number: number)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        let number: Int = calendarView.selectedDates.count
        daysLeft.text = "\(number)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)

        if let indexInArray = dateToDB.index(of: localDate) {
            dateToDB.remove(at: indexInArray)
        }

        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

        countDiscount(number: number)
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
            
            let layer = myCustomCell.selectedView!
            layer.animation = "pop"
            layer.curve = "easeInOutQuad"
            layer.force = 1.7
            layer.duration = 0.8
            layer.animate()
            
            
            
        } else {
            
            
            let layer = myCustomCell.selectedView!
            layer.animation = "zoomOut"
            layer.curve = "easeInOutQuad"
            layer.force = 1.7
            layer.duration = 0.8

            layer.animate()

            let when = DispatchTime.now() + 0.5

            DispatchQueue.main.asyncAfter(deadline: when){
                myCustomCell.selectedView.isHidden = true
            }
        }
        
        }
    

    @IBAction func goToSelectiontapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"MealVariationViewController") as? MealVariationViewController else { return }
        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.locationDetailToDB
        vc.locationAreaToDB = self.locationAreaToDB
        vc.dateToDB = self.dateToDB
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func countDiscount(number: Int) {

        if number <= 5 {

            self.daysToGo = 5 - number
            self.discountLabel.text = "80% off"

        } else if number > 5 && number <= 10 {

            self.daysToGo = 10 - number
            self.discountLabel.text = "70% off"

        } else if number > 10 && number <= 15 {

            self.daysToGo = 15 - number
            self.discountLabel.text = "60% off"

        } else if number > 15 && number <= 20 {

            self.daysToGo = 20 - number
            self.discountLabel.text = "50% off"

        } else {
            self.discountLabel.isHidden = true
            self.toHide.isHidden = true
            self.moreDaysToGo.isHidden = true
            self.haveAlreay.text = "已經達成最高運費折扣！"
        }

        self.moreDaysToGo.text = "\(self.daysToGo)"

    }

}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
