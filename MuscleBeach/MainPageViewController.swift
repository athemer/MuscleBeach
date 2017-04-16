//
//  MainPageViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/20.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import FirebaseStorage

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segOne: UISegmentedControl!

    @IBOutlet weak var segTwo: UISegmentedControl!
    
    var mealPreference: [String: Any] = [:]
    var mealPrefExsit: Bool = false

    let dateArr: [String] = ["2017-01-02", "2017-01-03", "2017-01-04", "2017-01-05", "2017-01-06", "2017-01-09", "2017-01-10"]
    let mealNameArr: [String] = ["快樂分享餐", "肯德基全家餐", "泰國好吃餐", "居家旅行", "必備涼拌", "八方雲集", "四海遊龍"]
    
    enum Components {
        case homaPageImages
        case addressSelection
        case fastOrder
    }

    let componentArr: [Components] = [.homaPageImages, .addressSelection, .fastOrder]

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserPreference()
        
        setUpBarItem()
        SideMenuManager.menuWidth = 200
        tableView.delegate = self
        tableView.dataSource = self

        let nib1 = UINib(nibName: "MainPageImagesTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "MainPageImagesTableViewCell")
        let nib2 = UINib(nibName: "SecondTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "SecondTableViewCell")
        let nib3 = UINib(nibName: "ThirdTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "ThirdTableViewCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(signUpViewController!, animated: true, completion: nil)
        } catch let error {
            print ("not logged out \(error)")
        }
    }
    @IBAction func butTapped(_ sender: Any) {

    }

    @IBAction func start(_ sender: Any) {
        guard
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"SelfPickUpViewController") as? SelfPickUpViewController,
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"ConfirmDeliverAdViewController") as?ConfirmDeliverAdViewController
         else { return }

        if segOne.selectedSegmentIndex == 0 {

            vc1.deliverToDB = "自取"

            switch segTwo.selectedSegmentIndex {
            case 0:
                vc1.toWhichPage = "single"
            case 1:
                vc1.toWhichPage = "multiple"

            default: break

            }

            self.navigationController?.pushViewController(vc1, animated: true)
        } else {

            vc2.deliverToDB = "外送"

            switch segTwo.selectedSegmentIndex {
            case 0:
                vc2.toWhichPage = "single"
            case 1:
                vc2.toWhichPage = "multiple"

            default: break

            }

            self.navigationController?.pushViewController(vc2, animated: true)
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return componentArr.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch componentArr[section] {
        case .homaPageImages:
            return 1

        case .addressSelection:
            return 1

        case .fastOrder:
            return dateArr.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch componentArr[indexPath.section] {
        case .homaPageImages:
            return 240

        case .addressSelection:
            return 240

        case .fastOrder:
            return 80
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch componentArr[indexPath.section] {
        case .homaPageImages:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainPageImagesTableViewCell") as! MainPageImagesTableViewCell
            // swiftlint:disable:previous force_cast

            return cell

        case .addressSelection:

            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell") as! SecondTableViewCell
            // swiftlint:disable:previous force_cast

            cell.backgroundColor = .green

            let vcToAdd = storyboard?.instantiateViewController(withIdentifier: "MainCollectionViewController") as? MainCollectionViewController

            cell.vc = vcToAdd
            cell.contentView.addSubview((vcToAdd?.view)!)
            self.addChildViewController(vcToAdd!)

            return cell

        case .fastOrder:

            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableViewCell") as! ThirdTableViewCell
            //swiftlint:disable:previous force_cast
            cell.date.text = dateArr[indexPath.row]
            cell.mealName.text = mealNameArr[indexPath.row]
//            cell.addToCartButton.addTarget(self, action: #selector(fastAdd), for: .touchUpInside)
            
            return cell
        }

    }

    func showCart() {
        // swiftlint:disable:next force_cast
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
        // swiftlint:disable:previous force_cast

        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToMenu() {
        // swiftlint:disable:next force_cast
        let vc = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationController") as! UISideMenuNavigationController
        // swiftlint:disable:previous force_cast

        self.show(vc, sender: nil)

    }

    func setUpBarItem() {
        let menuImage = UIImage(named: "MenuIcon")
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(menuImage, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftButton.addTarget(self, action: #selector(goToMenu), for: .touchUpInside)
        leftButton.tintColor = .black

        let leftBarItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarItem

        let cartImage = UIImage(named: "cartIcon")
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(cartImage, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightButton.addTarget(self, action: #selector(showCart), for: .touchUpInside)
        rightButton.tintColor = .green

        let rightBarItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarItem

    }
    
    func fastAdd() {
        
        if  mealPrefExsit == false {
            
            print ("no pref yet plz add one first")
            
        } else if mealPrefExsit == true {
            
            
            
            
            print ("now show seg and add to cart")
//
//            
//            let uid = FIRAuth.auth()?.currentUser?.uid
//            let orderData: [String: Any] = ["date":  , "deliver":  , "locationArea":, "locationDetail":  , "userUID": uid!, "time": , "meal": self.mealPreference , "userData": "wait to be done" , "paymentStatus": "unpaid", "paymentClaim": "false"]
//            
//            FIRDatabase.database().reference().child("order").childByAutoId().setValue(orderData)
            
        }
    }
    
    
    func fetchUserPreference() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("mealPreference").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snap = snapshot.value as? [String: Any]
                else {
                    
                    print ("no preference yet")
                    return
            }
            
            self.mealPreference = snap
            self.mealPrefExsit = true
            
        })
        
    }

}
