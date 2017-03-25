//
//  ReorderViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/25.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class ReorderViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    
    let dateArray: [String] = ["2017-03-29", "2017-03-28", "2017-03-25"]

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)       // default is (3,3)
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarView.allowsMultipleSelection  = true
        calendarView.rangeSelectionWillBeUsed = true
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
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.isHidden = false
        } else {
            myCustomCell.isHidden = true
        }
        
        let cellStateDateString = dateFormatter.string(from: cellState.date)

        for x in 0...(dateArray.count - 1) {
            if cellStateDateString == dateArray[x] {
                myCustomCell.dayLabel.textColor = UIColor.red
            }
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: visibleDates.monthDates.first!)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)
        
        print ("aHA \(localDate)")
        print ("COUNT \(calendarView.selectedDates.count)")
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        
        
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
    
    func fetchQueriedDataFromFirebase () {
        var arr: [[String: AnyObject]] = []
        
        
        arr.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("order").queryOrdered(byChild: "userUID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapData = snapshot.value as? [String: AnyObject] {
                for snap in snapData {
//                    print (" DATA \(snap)")
                    if let data = snap.value as? [String: AnyObject] {
//                        print ("CD \(data)")

                        
                        arr.append(data)
                        
                    }
                    
                }
            }
//            print (arr)
            
            let predicate = NSPredicate(format: "date == %@", "2017-03-29")
            let filtered = (arr as NSArray).filtered(using: predicate)
            
            print ("check \(filtered)")
            
            
        })

        
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        fetchQueriedDataFromFirebase()
        
    }
    
    
    
}
