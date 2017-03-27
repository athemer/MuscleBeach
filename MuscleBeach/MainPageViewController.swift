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

    @IBOutlet weak var segOne: UISegmentedControl!
    
    @IBOutlet weak var segTwo: UISegmentedControl!
    
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
    
}
