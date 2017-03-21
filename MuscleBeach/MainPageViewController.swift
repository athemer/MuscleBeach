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


class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuManager.menuWidth = 200
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
}
