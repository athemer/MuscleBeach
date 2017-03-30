//
//  PopoverViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/30.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        print ("QOO")
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        let navigation = self.navigationController
        
        self.willMove(toParentViewController: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParentViewController()
 
        
    }

}
