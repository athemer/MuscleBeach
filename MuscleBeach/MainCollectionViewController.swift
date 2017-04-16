//
//  MainCollectionViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/13.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var detailAddToDB: String = ""
    var mainAddToDB: String = ""
    var deliverToDB: String = ""

    var addressArr: [AddressModel] = []

    enum Components {
        case one
        case two
    }

    let componentArr: [Components] = [.one, .two]

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAddress()

        let nib = UINib(nibName: "FirstCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "FirstCollectionViewCell")
        let nib2 = UINib(nibName: "SecondCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib2, forCellWithReuseIdentifier: "SecondCollectionViewCell")
        // Do any additional setup after loading the view.
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

        self.collectionView?.scrollToItem(at: index1, at: .left, animated: true)

//        let uid = FIRAuth.auth()?.currentUser?.uid
//        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainAdd": mainAddressLabel.text])
//        FIRDatabase.database().reference().child("users").child(uid!).child("address").updateChildValues(["mainDetail": detailAddressLabel.text])
        
        guard let parentVC = UIViewController.self as? MainPageViewController else { return }
        parentVC.locationArea = addressArr[row].mainAdd
        parentVC.locationDetail = addressArr[row].detailAdd
        parentVC.deliver = "外送"
        
        self.deliverToDB = "外送"
        self.mainAddToDB = addressArr[row].mainAdd
        self.detailAddToDB = addressArr[row].detailAdd

    }

    func bonbon() {

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as? CalendarViewController else { return }

        vc.deliverToDB = self.deliverToDB
        vc.locationDetailToDB = self.detailAddToDB
        vc.locationAreaToDB = self.mainAddToDB

        self.navigationController?.pushViewController(vc, animated: true)

        print ("1234567")
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

        self.collectionView?.scrollToItem(at: index, at: .left, animated: true)
    }

    func fetchAddress() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("address").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let mainAdd = dict["mainAdd"] as? String
                let mainDetail = dict["mainDetail"] as? String

                for x in 1...(dict.count / 2) - 1 {

                    let street = dict["add\(x)"] as? String
                    let address = dict["detail\(x)"] as? String
                    let finalAdd = street! + address!

                    let toAppend = AddressModel(mainAdd: street!, detailAdd: address!, finalAdd: finalAdd)

                    self.addressArr.append(toAppend)

                }

            } else {

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
}
