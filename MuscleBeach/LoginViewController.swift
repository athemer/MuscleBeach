//
//  LoginViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/20.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signUpViewController!, animated: true, completion: nil)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Email user authenticated with Firebase")
                        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(signUpViewController!, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "錯誤", message: "帳號不存在或密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "重試", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })

        }
    }

    func checkLoginStatus () {
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            let tabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
//            self.present(tabBarViewController!, animated: true, completion: nil)
            self.view.window?.rootViewController = tabBarViewController
            print("user did logged in")
        } else {
            print ("not logged in ")
        }
    }

}
