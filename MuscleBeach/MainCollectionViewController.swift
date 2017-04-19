//
//  MainCollectionViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import CoreData

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var detailAddToDB: String = ""
    var mainAddToDB: String = ""
    var deliverToDB: String = ""

    var dataArray: [NSManagedObject] = []

    var addressArr: [AddressModel] = []

    enum Components {
        case one
        case two
    }

    let componentArr: [Components] = [.one, .two]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: 375, height: 240)
        
        let nib = UINib(nibName: "FirstCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "FirstCollectionViewCell")
        let nib2 = UINib(nibName: "SecondCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib2, forCellWithReuseIdentifier: "SecondCollectionViewCell")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAddress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return componentArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items

        switch componentArr[section] {
        case .one :
            return 1
        case .two :
            return 1
        }

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        switch componentArr[indexPath.section] {
        case .one :
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
            // swiftlint:disable:previous force_cast

            let uid = FIRAuth.auth()?.currentUser?.uid

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return cell}
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
            request.predicate = NSPredicate(format: "id == %@", uid!)

            do {
                guard let results = try context.fetch(request) as? [UserMO] else { return cell }

                if results.count > 0 {

                    print ("WERID", results[0].addressMain, results[0].addressDetail)

                    cell.addressLabel.text = results[0].addressMain
                    cell.detailLAbel.text = results[0].addressDetail

                } else {

                    print ("not possibly gonna happen")
                }

                try context.save()

            } catch {
                print (error.localizedDescription)
            }

            cell.backgroundColor = .black
            cell.startButton.addTarget(self, action: #selector(bonbon), for: .touchUpInside)
            return cell
        case .two :
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
            // swiftlint:disable:previous force_cast

            cell.backgroundColor = .yellow
            cell.pickerView.delegate = self
            cell.pickerView.dataSource = self
            cell.firstButton.addTarget(self, action: #selector(changeAddress), for: .touchUpInside)
            cell.secondButton.addTarget(self, action: #selector(changeAddress2), for: .touchUpInside)
            cell.deliverAddButton.addTarget(self, action: #selector(delivAddBtnTapped), for: .touchUpInside)
            
            
            cell.firstInfoButton.addTarget(self, action: #selector(showInfoOne), for: .touchUpInside)
            cell.secondInfoButton.addTarget(self, action: #selector(showInfoTwo), for: .touchUpInside)
            return cell
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addressArr.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return addressArr[row].finalAdd
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let index1: IndexPath = IndexPath(item: 0, section: 0)

        // swiftlint:disable:next force_cast
        let cell1 = collectionView?.cellForItem(at: index1) as! FirstCollectionViewCell
        // swiftlint:disable:previous force_cast

        cell1.addressLabel.text = addressArr[row].mainAdd
        cell1.detailLAbel.text = addressArr[row].detailAdd

        let index2: IndexPath = IndexPath(item: 0, section: 1)

        // swiftlint:disable:next force_cast
        let cell2 = collectionView?.cellForItem(at: index2) as! SecondCollectionViewCell
        // swiftlint:disable:previous force_cast

        cell2.pickerView.isHidden = true
        cell2.deliverAddButton.isHidden = false
        cell2.deliverAddButton.setTitle(addressArr[row].finalAdd, for: .normal)

//        let uid = FIRAuth.auth()?.currentUser?.uid
//        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainAdd": mainAddressLabel.text])
//        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainDetail": detailAddressLabel.text])

        guard let parentVC = self.parent as? MainPageViewController else { return }
        parentVC.locationArea = addressArr[row].mainAdd
        parentVC.locationDetail = addressArr[row].detailAdd
        parentVC.deliver = "外送"

        self.deliverToDB = "外送"
        self.mainAddToDB = addressArr[row].mainAdd
        self.detailAddToDB = addressArr[row].detailAdd

        let uid = FIRAuth.auth()?.currentUser?.uid

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
        request.predicate = NSPredicate(format: "id == %@", uid!)

        do {
            guard let results = try context.fetch(request) as? [UserMO] else { return }

            if results.count > 0 {

                results[0].addressMain = addressArr[row].mainAdd
                results[0].addressDetail = addressArr[row].detailAdd
                print ("CHECK", addressArr[row].detailAdd)
                results[0].deliver = "外送"

            } else {

                print ("not possibly gonna happen")
            }

            try context.save()
            print ("kinda saved")

        } catch {
            print (error.localizedDescription)
        }

        FIRDatabase.database().reference().child("users").child(uid!).child("address").child("mainAdd").setValue(addressArr[row].mainAdd)
        FIRDatabase.database().reference().child("users").child(uid!).child("address").child("mainDetail").setValue(addressArr[row].detailAdd)
        FIRDatabase.database().reference().child("users").child(uid!).child("mealPreference").child("deliver").setValue("外送")

        self.collectionView?.scrollToItem(at: index1, at: .left, animated: true)
    }

    func bonbon() {

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as? CalendarViewController else { return }

        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.detailAddToDB
        vc.locationAreaToDB = self.mainAddToDB

        self.navigationController?.pushViewController(vc, animated: true)
    }

    func changeAddress() {

        let index: IndexPath = IndexPath(item: 0, section: 0)

        // swiftlint:disable:next force_cast
        let cell = collectionView?.cellForItem(at: index) as! FirstCollectionViewCell
        // swiftlint:disable:previous force_cast

        guard let parentVC = self.parent as? MainPageViewController else {
            print ("wrong")
            return }
        parentVC.locationArea = "自取地點一"
        parentVC.locationDetail = "城市草倉"
        parentVC.deliver = "自取"

        cell.addressLabel.text = "城市草倉 C TEA"
        cell.detailLAbel.text = "台北市大安區羅斯福路三段283巷19弄4號"
        self.deliverToDB = "自取"
        self.mainAddToDB = "自取地點一"
        self.detailAddToDB = "城市草倉"

        let uid = FIRAuth.auth()?.currentUser?.uid

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
        request.predicate = NSPredicate(format: "id == %@", uid!)

        do {
            guard let results = try context.fetch(request) as? [UserMO] else { return }

            if results.count > 0 {

                results[0].addressMain = "自取地點一"
                results[0].addressDetail = "城市草倉"
                results[0].deliver = "自取"

            } else {

                print ("not possibly gonna happen")
            }

            try context.save()
            print ("kinda saved")

        } catch {
            print (error.localizedDescription)
        }

        FIRDatabase.database().reference().child("users").child(uid!).child("address").child("mainAdd").setValue("自取地點一")
        FIRDatabase.database().reference().child("users").child(uid!).child("address").child("mainDetail").setValue("城市草倉")
        FIRDatabase.database().reference().child("users").child(uid!).child("mealPreference").child("deliver").setValue("自取")

        self.collectionView?.scrollToItem(at: index, at: .left, animated: true)
    }

    func changeAddress2() {

        let index: IndexPath = IndexPath(item: 0, section: 0)

        // swiftlint:disable:next force_cast
        let cell = collectionView?.cellForItem(at: index) as! FirstCollectionViewCell
        // swiftlint:disable:previous force_cast

        cell.addressLabel.text = "肌肉海灘工作室"
        cell.detailLAbel.text = "信義區和平東路三段391巷8弄30號1樓"

        guard let parentVC = self.parent as? MainPageViewController else {
            print ("wrong")
            return }
        parentVC.locationArea = "自取地點二"
        parentVC.locationDetail = "肌肉海灘工作室"
        parentVC.deliver = "自取"

        self.deliverToDB = "自取"
        self.mainAddToDB = "自取地點二"
        self.detailAddToDB = "肌肉海灘工作室"

        let uid = FIRAuth.auth()?.currentUser?.uid

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
        request.predicate = NSPredicate(format: "id == %@", uid!)

        do {
            guard let results = try context.fetch(request) as? [UserMO] else { return }

            if results.count > 0 {

                results[0].addressMain = "自取地點二"
                results[0].addressDetail = "肌肉海灘工作室"
                results[0].deliver = "自取"

            } else {

                print ("not possibly gonna happen")
            }

            try context.save()
            print ("kinda saved")

        } catch {
            print (error.localizedDescription)
        }

//        
//        
//        
        FIRDatabase.database().reference().child("users").child(uid!).child("address").child("mainAdd").setValue("自取地點二")
        FIRDatabase.database().reference().child("users").child(uid!).child("address").child("mainDetail").setValue("肌肉海灘工作室")
        FIRDatabase.database().reference().child("users").child(uid!).child("mealPreference").child("deliver").setValue("自取")

        self.collectionView?.scrollToItem(at: index, at: .left, animated: true)
    }

    func fetchAddress() {
        let uid = FIRAuth.auth()?.currentUser?.uid
//
//        
//        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in
//        
//            if let dict = snapshot.value as? [String: AnyObject] {
//                let mainAdd = dict["mainAdd"] as? String
//                let mainDetail = dict["mainDetail"] as? String
//                
//                let index = IndexPath(item: 0, section: 0)
//                
//                // swiftlint:disable:next force_cast
//                let cell = self.collectionView?.cellForItem(at: index) as! FirstCollectionViewCell
//                // swiftlint:disable:previous force_cast
//                
//                print ("how", mainAdd, mainDetail)
//                
//                cell.addressLabel.text = mainAdd
//                cell.detailLAbel.text = mainDetail
//                
//            } else {
//                return
//            }
//            
//        })

        self.addressArr.removeAll()

        FIRDatabase.database().reference().child("users").child(uid!).child("addressPool").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {

                for x in 0...(dict.count / 2) - 1 {

                    print ("YOLO COME HERE", dict.count)

                    let street = dict["add\(x)"] as? String
                    let address = dict["detail\(x)"] as? String

                    print ("XOXO", street, address)

                    let finalAdd = street! + address!

                    let toAppend = AddressModel(mainAdd: street!, detailAdd: address!, finalAdd: finalAdd)

                    self.addressArr.append(toAppend)

                    let index: IndexPath = IndexPath(item: 0, section: 1)
                    // swiftlint:disable:next force_cast
                    let cell = self.collectionView?.cellForItem(at: index) as! SecondCollectionViewCell
                    // swiftlint:disable:previous force_cast

                    cell.deliverAddButton.setTitle("請選擇地址", for: .normal)
                    cell.deliverAddButton.isEnabled = true
                }

            } else {
                let index: IndexPath = IndexPath(item: 0, section: 1)
                // swiftlint:disable:next force_cast
                let cell = self.collectionView?.cellForItem(at: index) as! SecondCollectionViewCell
                // swiftlint:disable:previous force_cast

                cell.deliverAddButton.setTitle("請先至個人頁面新增地址", for: .normal)
                cell.deliverAddButton.isEnabled = false

                print ("no address to fetch")
                return
            }

            let index: IndexPath = IndexPath(item: 0, section: 1)

            // swiftlint:disable:next force_cast
            let cell = self.collectionView?.cellForItem(at: index) as! SecondCollectionViewCell
            // swiftlint:disable:previous force_cast
            cell.pickerView.reloadAllComponents()

        })
    }

    func delivAddBtnTapped() {

        let index: IndexPath = IndexPath(item: 0, section: 1)

        // swiftlint:disable:next force_cast
        let cell = collectionView?.cellForItem(at: index) as! SecondCollectionViewCell
        // swiftlint:disable:previous force_cast
        cell.pickerView.isHidden = false
        cell.deliverAddButton.isHidden = true

    }
    
    func showInfoOne() {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PickUpLocationViewController") as? PickUpLocationViewController else { return }
        vc.address = "台北市大安區羅斯福路三段283巷19弄4號"
        vc.latitude = 25.0194332
        vc.longitude = 121.5314772
        vc.name = "城市草倉 C-tea loft"
        vc.number = "02 2366 0381"
        vc.imageName = "c-tea"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showInfoTwo() {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PickUpLocationViewController") as? PickUpLocationViewController else { return }
        vc.address = "台北市信義區和平東路三段391巷8弄30號1樓"
        vc.latitude = 25.020501
        vc.longitude = 121.557314
        vc.name = "肌肉海灘工作室"
        vc.number = "02 2366 0381"
        vc.imageName = "MBLogo"
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
