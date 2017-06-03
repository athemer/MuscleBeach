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
import CoreData
import Spring

class MainPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var fetchData: [NSManagedObject] = []

    var mealPreference: [String: Any] = [:]

    var mealPrefExsit: Bool = false

    var locationArea: String = ""

    var locationDetail: String = ""

    var deliver: String = ""

    let screenSize = UIScreen.main.bounds

    let constants = Constants.createDataInCell()
    
    var mainCollectionViewVC: MainCollectionViewController!
    
    
    
    
    
    enum Components {

        case homaPageImages, addressSelection, fastOrder

    }

    let componentArr: [Components] = [.homaPageImages, .addressSelection, .fastOrder]

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserInfoWhenLaunchIfLoggedIn()

//        fetchUserPreference()

        setUpBarItem()
        
        SideMenuManager.menuWidth = 200
        
        tableView.delegate = self
        
        tableView.dataSource = self

        tableView.allowsSelection = false

        registerCell()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         // swiftlint:disable:next force_cast
        mainCollectionViewVC = storyboard.instantiateViewController(withIdentifier: "MainCollectionViewController") as! MainCollectionViewController
         // swiftlint:disable:previous force_cast

    }

    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(signUpViewController!, animated: true, completion: nil)
        } catch let error {
            print ("not logged out \(error)")
        }

        deleteAll()

    }
    
    func registerCell() {
        
        let nib1 = UINib(nibName: "MainPageImagesTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "MainPageImagesTableViewCell")
        let nib2 = UINib(nibName: "SecondTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "SecondTableViewCell")
        let nib3 = UINib(nibName: "ThirdTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "ThirdTableViewCell")
        
    }
    
    // Set up bar button item and action
    func setUpBarItem() {
        let menuImage = UIImage(named: "MenuIcon")
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(menuImage, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftButton.addTarget(self, action: #selector(goToMenu), for: .touchUpInside)
        leftButton.tintColor = .black

        let leftBarItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarItem

    }
    
    func goToMenu() {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationController") as? UISideMenuNavigationController else { return }
        
        self.show(vc, sender: nil)
    }
    
    
    // Set Up Fast Add Action and Alert
    func fastAdd(_ sender: UIButton) {

        let isAnonymous = FIRAuth.auth()?.currentUser?.isAnonymous

        if !isAnonymous! {

            guard let cell = sender.superview?.superview as? ThirdTableViewCell else { return }
            cell.timeView.isHidden = false
            cell.addToCartButton.isHidden = true

            tabBarController?.tabBar.items?[2].badgeValue = "2"

        } else {

            let alert = UIAlertController(title: "尚未登入",
                                          message: "請先登入後再進行操作",
                                          preferredStyle: .alert)

            let cancel = UIAlertAction(title: "返回", style: .destructive, handler: { (_) -> Void in })
            let loging = UIAlertAction(title: "登入", style: .default, handler: { (_) in
                do {
                    try FIRAuth.auth()?.signOut()
                    let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(signUpViewController!, animated: true, completion: nil)
                } catch let error {
                    print ("not logged out \(error)")
                }

            })
            alert.addAction(cancel)
            alert.addAction(loging)
            self.present(alert, animated: true, completion: nil)
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

        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let snap = snapshot.value as? [String: Any]
                else {

                    print ("no preference yet")
                    return
            }

            guard
                let locationArea = snap["mainAdd"] as? String,
                let locationDetail = snap["mainDetail"] as? String,
                let deliver = snap["deliver"] as? String else { return }

            self.locationArea = locationArea
            self.locationDetail = locationDetail
            self.deliver = deliver

        })
    }
    
    // Handle Button Action
    func lunchAdded(_ sender: UIButton) {
        
        fetchThenSetValueToDB(sender: sender, time: "午餐")

    }

    func dinnerAdded(_ sender: UIButton) {
        
        fetchThenSetValueToDB(sender: sender, time: "晚餐")
    }

    func fetchThenSetValueToDB(sender: UIButton, time: String) {
    
        guard let cell = sender.superview?.superview?.superview as? ThirdTableViewCell else { return }
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserMO")
    
        do {
        
            self.fetchData = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print (error)
            print("Could not fetch.")
        }
    
        let date = cell.dateLabelonLayer.text
        let uid = FIRAuth.auth()?.currentUser?.uid
    
        let fetchedResult = fetchData[0]
        guard
            let userNameFromFetch = fetchedResult.value(forKey: "name") as? String,
            let userNumber = fetchedResult.value(forKey: "number") as? String,
            let deliverFromFetch = fetchedResult.value(forKey: "deliver") as? String,
            let locationAreaFromFetch = fetchedResult.value(forKey: "addressMain") as? String,
            let locationDetailFromFetch = fetchedResult.value(forKey: "addressDetail") as? String,
            let prefA = fetchedResult.value(forKey: "prefA") as? Int,
            let prefB = fetchedResult.value(forKey: "prefB") as? Int,
            let prefC = fetchedResult.value(forKey: "prefC") as? Int
            else { return }
    
        let mealPreferenceFromFetch = ["typeA": prefA, "typeB": prefB, "typeC": prefC]
        let userData = ["userName": userNameFromFetch, "userNumber": userNumber]
    
        let orderData: [String: Any] = ["date": date, "deliver": deliverFromFetch, "locationArea": locationAreaFromFetch, "locationDetail": locationDetailFromFetch, "userUID": uid!, "time": time, "meal": mealPreferenceFromFetch, "userData": userData, "paymentStatus": "unpaid", "paymentClaim": "false"]
    
        FIRDatabase.database().reference().child("order").childByAutoId().setValue(orderData)
    
        }

    func fetchUserInfoWhenLaunchIfLoggedIn() {

        let uid = FIRAuth.auth()?.currentUser?.uid

        let isAnonymous = FIRAuth.auth()?.currentUser?.isAnonymous

        if uid != nil && !isAnonymous! {

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
            request.predicate = NSPredicate(format: "id == %@", uid!)

//            let userMO = UserMO(context: context)

            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

                if let snap = snapshot.value as? [String: Any] {
                    guard
                        let name = snap["name"] as? String,
                        let number = snap["number"] as? String,
                        let address = snap["address"] as? [String: Any],
                        let mainAdd = address["mainAdd"] as? String,
                        let mainDetail = address["mainDetail"] as? String,
                        let pref = snap["mealPreference"] as? [String: Any],
                        let prefA = pref["typeA"] as? Int,
                        let prefB = pref["typeB"] as? Int,
                        let prefC = pref["typeC"] as? Int,
                        let email = snap["email"] as? String,
                        let ImageUrl = snap["prfileImgURL"] as? String,
                        let deliver = pref["deliver"] as? String
                        else {
                            print ("BUGBUGBUG")
                            return }

                    print ("?????", name, number, mainAdd, mainDetail, email, prefA, prefB, prefC, ImageUrl)

                    do {
                        guard let results = try context.fetch(request) as? [UserMO] else {

                            return }

                        if results.count > 0 {

                            let url = URL(string: ImageUrl)
                            URLSession.shared.dataTask(with: url!) { (data, _, _) in

                                results[0].profileImage = NSData(data: data!)

                                }.resume()

                            results[0].id = uid!
                            results[0].name = name
                            results[0].number = number
                            results[0].deliver = deliver
                            results[0].addressMain = mainAdd
                            results[0].addressDetail = mainDetail
                            results[0].email = email
                            results[0].prefA = Int16(prefA)
                            results[0].prefB = Int16(prefB)
                            results[0].prefC = Int16(prefC)

                        } else {

                            let user = NSEntityDescription.insertNewObject(forEntityName: "UserMO", into: context)

                            print("insert object")

                            let url = URL(string: ImageUrl)
                            URLSession.shared.dataTask(with: url!) { (data, _, _) in

                                user.setValue(data, forKey: "profileImage")

                                }.resume()

                            user.setValue(name, forKey: "name")
                            user.setValue(number, forKey: "number")
                            user.setValue(mainAdd, forKey: "addressMain")
                            user.setValue(mainDetail, forKey: "addressDetail")
                            user.setValue(email, forKey: "email")
                            user.setValue(prefA, forKey: "prefA")
                            user.setValue(prefB, forKey: "prefB")
                            user.setValue(prefC, forKey: "prefC")
                            user.setValue(deliver, forKey: "deliver")
                            user.setValue(uid!, forKey: "id")

                        }

                        try context.save()
                        print ("kinda saved")

                    } catch {
                        print (error.localizedDescription)
                    }

                }

            })

        } else {

            // Handle No user has Logged in

            print ("do nothing yet")
        }

    }
    
    // Delete Data From Core Data
    func deleteAll() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")

        let moc = appDelegate.persistentContainer.viewContext

        do {

            guard let results = try moc.fetch(request) as? [UserMO] else {
                return
            }

            for result in results {

                moc.delete(result)

            }

            appDelegate.saveContext()

        } catch {

            fatalError("\(error)")
        }

    }

}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {

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
            return constants.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch componentArr[indexPath.section] {

        case .homaPageImages:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainPageImagesTableViewCell") as? MainPageImagesTableViewCell else { return UITableViewCell() }

            return cell

        case .addressSelection:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell") as? SecondTableViewCell
                else { return UITableViewCell() }

//            let vcToAdd = storyboard?.instantiateViewController(withIdentifier: "MainCollectionViewController") as? MainCollectionViewController
//            self.addChildViewController(vcToAdd!)
//            vcToAdd?.willMove(toParentViewController: self)
//            cell.contentView.addSubview((vcToAdd?.collectionView)!)
//            vcToAdd!.collectionView!.translatesAutoresizingMaskIntoConstraints = false
            
            
            addChildViewController(mainCollectionViewVC)
//            cell.addSubview(mainCollectionViewVC.view)
            cell.addCollectionView(view: mainCollectionViewVC.view)
            mainCollectionViewVC.didMove(toParentViewController: self)
            

//            vcToAdd?.collectionView?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0).isActive = true
//            vcToAdd?.collectionView?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
//            vcToAdd?.collectionView?.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
//            vcToAdd?.collectionView?.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
//            vcToAdd?.didMove(toParentViewController: self)

            return cell

        case .fastOrder:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableViewCell") as? ThirdTableViewCell else { return UITableViewCell() }

            cell.addToCartButton.addTarget(self, action: #selector(fastAdd), for: .touchUpInside)
            cell.lunchButton.addTarget(self, action: #selector(lunchAdded), for: .touchUpInside)
            cell.dinnerButton.addTarget(self, action: #selector(dinnerAdded), for: .touchUpInside)
            cell.dataConstants = self.constants[indexPath.row]

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch componentArr[indexPath.section] {

        case .homaPageImages:
            return screenSize.height * 0.35

        case .addressSelection:
            return screenSize.height * 0.35

        case .fastOrder:
            return 100
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "ThirdTableViewCell") as? ThirdTableViewCell else { return }

        let layer = cell3.mealImage!

        layer.animation = "fadeOutLeft"
        layer.curve = "easeInOutQuad"
        layer.duration = 1.0
        layer.scaleX = 1.5
        layer.scaleY = 1.5
        layer.damping = 0.9
        layer.velocity = 0.5
        layer.animate()

        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell") as? SecondTableViewCell else { return }


//        if  {
//            mainCollectionViewVC.willMove(toParentViewController: nil)
//            mainCollectionViewVC.view.removeFromSuperview()
//            mainCollectionViewVC.removeFromParentViewController()
//
//        }

        return

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch componentArr[section] {

        case .homaPageImages:
            return ""

        case .addressSelection:
            return "選擇訂餐地址"

        case .fastOrder:
            return "快速訂餐"
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch componentArr[section] {

        case .homaPageImages:
            return 0

        case .addressSelection:
            return 40

        case .fastOrder:
            return 40
        }
    }
    

//    func addViewControllerToParent(cell: UITableViewCell) {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "MainCollectionViewController") as? MainCollectionViewController else { return }
//        
//        
//        print ("AGA")
//        
//        self.addChildViewController(vc)
//        vc.willMove(toParentViewController: self)
//        cell.contentView.addSubview(vc.view)
//
//        
//    }
    
}
