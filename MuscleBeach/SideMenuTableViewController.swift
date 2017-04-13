//
//  SideMenuTableViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class SideMenuTableViewController: UITableViewController {

    enum CellComponents {
        case setting
        case profile
        case orderHistory
    }

    var cellComponentsArray: [CellComponents] = [.profile, .orderHistory, .setting ]

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cellComponentsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        switch cellComponentsArray[section] {
        case .profile:
            return 1
        case .orderHistory:
            return 1
        case .setting:
            return 1
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let componenets = cellComponentsArray[indexPath.section]

        switch componenets {
        case .profile:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            // swiftlint:disable:previous force_cast
            return cell

        case .orderHistory:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as! OrderHistoryCell
            // swiftlint:disable:previous force_cast
            return cell

        case .setting :
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            // swiftlint:disable:previous force_cast
            return cell

        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let componenets = cellComponentsArray[indexPath.section]
        switch componenets {
        case .profile:
            return 120
        case .orderHistory:
            return 40
        case .setting:
            return 40
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let componenets = cellComponentsArray[indexPath.section]
        switch componenets {
        case .profile:
//            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
//            self.present(profileViewController!, animated: true, completion: nil)
            performSegue(withIdentifier: "toProfilePage", sender: nil)

        case .orderHistory:
            print (3)

        case .setting:
            logOutFromFirebase()
            print (4)

        }
    }

    func registerCell() {
        let proFileNib = UINib(nibName: "ProfileCell", bundle: nil)
        let orderHisNib = UINib(nibName: "OrderHistoryCell", bundle: nil)
        let settingsNib = UINib(nibName: "SettingsCell", bundle: nil)
        tableView.register(proFileNib, forCellReuseIdentifier: "ProfileCell")
        tableView.register(orderHisNib, forCellReuseIdentifier: "OrderHistoryCell")
        tableView.register(settingsNib, forCellReuseIdentifier: "SettingsCell")
    }

    func logOutFromFirebase() {
        do {
            try FIRAuth.auth()?.signOut()
            let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(signUpViewController!, animated: true, completion: nil)

        } catch let error {
            print ("not logged out \(error)")
        }
    }

}
