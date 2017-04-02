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

    var dateArr: [String] = []
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var arr: [[String: AnyObject]] = []
    
    var deliverArr: [AnyObject] = []
    var timeArr: [AnyObject] = []
    var locationAreaArr: [AnyObject ] = []
    var locationDetailArr: [AnyObject] = []
    var typeAArr: [AnyObject] = []
    var typeBArr: [AnyObject] = []
    var typeCArr: [AnyObject] = []
    var mealArr: [String: Int] = [:]
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.arr.removeAll()
        self.dateArr.removeAll()
        fetchQueriedDataFromFirebase()
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

        var numberCheck: Int = dateArr.count
        
        if numberCheck >= 1 {
            
            if dateArr.contains(cellStateDateString) {
                myCustomCell.dayLabel.textColor = UIColor.yellow
            } else {
                return
            }
        } else {
            return
        }
       
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: visibleDates.monthDates.first!)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        self.deliverArr.removeAll()
        self.locationAreaArr.removeAll()
        self.locationDetailArr.removeAll()
        self.timeArr.removeAll()
        self.typeAArr.removeAll()
        self.typeBArr.removeAll()
        self.typeCArr.removeAll()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)
        
        assignValueToOrderDetailVC(date: localDate)
        
       
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"OrderDetailViewController") as? OrderDetailViewController else { return }
        vc.date = localDate
        vc.deliverArr = self.deliverArr
        vc.locationAreaArr = self.locationAreaArr
        vc.locationDetailArr = self.locationDetailArr
        vc.timeArr = self.timeArr
        vc.typeAAmount = self.typeAArr
        vc.typeBAmount = self.typeBArr
        vc.typeCAmount = self.typeCArr
        self.navigationController?.pushViewController(vc, animated: true)

//        print ("aHA \(localDate)")
//        print ("COUNT \(calendarView.selectedDates.count)")
        
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        performSegue(withIdentifier: "to", sender: nil)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleDayCellView, cellState: CellState) -> Bool {

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date)
        
        if cellState.dateBelongsTo == .thisMonth, cellState.day != .sunday, cellState.day != .saturday {
            if dateArr.contains(localDate) {
                return true
            } else {
                return false
            }

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
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("order").queryOrdered(byChild: "userUID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapData = snapshot.value as? [String: AnyObject] {
                for snap in snapData {
                    if let data = snap.value as? [String: AnyObject] {
                       print ("CD \(data)")
                        
                        guard
                            let paymentStatus = data["paymentStatus"] as? String,
                            let date = data["date"] as? String
                            else { return }
                        
                        if paymentStatus == "paid" {
                           self.arr.append(data)
                           self.dateArr.append(date)
                        } else {
                            print ("some order is not paid yet")
                        }
                        

                        
                    }
                }
                print ("dateArr eqauls to \(self.dateArr)")
                self.calendarView.reloadData()
            }
            
/*            let predicate = NSPredicate(format: "date == %@", "2017-03-29")
            let filtered = (self.arr as NSArray).filtered(using: predicate)
            
            print ("check \(filtered)")
            
            for x in 0...filtered.count - 1 {
                guard
                    let dict: [String : AnyObject] = filtered[x] as? [String : AnyObject],
                    let deliverType = dict["deliver"] as? AnyObject,
                    let deliverTime = dict["time"] as? AnyObject,
                    let deliverLocationArea = dict["locationArea"] as? AnyObject,
                    let delvierLocationDetail = dict["locationDetail"] as? AnyObject
                    else { return }
                
                
                self.deliverArr.append(deliverType)
                self.timeArr.append(deliverTime)
                self.locationAreaArr.append(deliverLocationArea)
                self.locationDetailArr.append(delvierLocationDetail)
            } */
        })
        print ("fetched")
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        fetchQueriedDataFromFirebase()
        
    }
    
    func assignValueToOrderDetailVC (date: String) {
        
        let predicate = NSPredicate(format: "date == %@", date)
        let filtered = (arr as NSArray).filtered(using: predicate)
        
        print ("check \(filtered)")
        
        for x in 0...filtered.count - 1 {
            guard
                let dict: [String : AnyObject] = filtered[x] as? [String : AnyObject],
                let deliverType = dict["deliver"] as? AnyObject,
                let deliverTime = dict["time"] as? AnyObject,
                let deliverLocationArea = dict["locationArea"] as? AnyObject,
                let delvierLocationDetail = dict["locationDetail"] as? AnyObject,
                let meal = dict["meal"] as? AnyObject,
                let typeBAmount = meal["typeB"] as? AnyObject,
                let typeCAmount = meal["typeC"] as? AnyObject,
                let typeAAmount = meal["typeA"] as? AnyObject
            
                else { return }
            
            
            self.deliverArr.append(deliverType)
            self.timeArr.append(deliverTime)
            self.locationAreaArr.append(deliverLocationArea)
            self.locationDetailArr.append(delvierLocationDetail)
            self.typeAArr.append(typeAAmount)
            self.typeBArr.append(typeBAmount)
            self.typeCArr.append(typeCAmount)
    }
    }
    
}
