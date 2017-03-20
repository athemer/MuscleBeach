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
    

    override func viewDidAppear(_ animated: Bool) {
        checkLoginStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable \(error)")
            } else {
                print("Successfully authenticated with Firebase")
                if let user = user {
                    let id = FIRAuth.auth()!.currentUser!.uid
                    let userData = ["provider": credential.provider]
                    let email = ["email": self.emailTextField.text!]
                    let password = ["password": self.passwordTextField.text!]
//                    self.completeSignIn(id: id , userData: userData, email: email, password: password)
                }
            }
        })
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
                    if let user = user {
                        let id = FIRAuth.auth()!.currentUser!.uid
                        let userData = ["provider": user.providerID]
                        let email = ["email": self.emailTextField.text!]
                        let password = ["password": self.passwordTextField.text!]
//                        self.completeSignIn(id: id, userData: userData, email: email, password: password)
                        
                        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(signUpViewController!, animated: true, completion: nil)
                    }
                } else {
                    let alertController = UIAlertController(title: "錯誤", message: "帳號不存在或密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "重試", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
//                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
//                        if error != nil {
//                            print(error)
//                            print("Unable to authenticate with Firebase using email")
//                        } else {
//                            print("Successfully authenticated with Firebase")
//                            if let user = user {
//                                let id = FIRAuth.auth()!.currentUser!.uid
//                                let userData = ["provider": user.providerID]
//                                let email = ["email": self.emailTextField.text!]
//                                let password = ["password": self.passwordTextField.text!]
////                                self.completeSignIn(id: id, userData: userData, email: email, password: password)
//                            }
//                        }
//                    })
                }
            })

        }
    }
    
    func checkLoginStatus () {
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            let tabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.present(tabBarViewController!, animated: true, completion: nil)
            print("user did logged in")
        } else {
            print ("not logged in ")
        }
    }
}
