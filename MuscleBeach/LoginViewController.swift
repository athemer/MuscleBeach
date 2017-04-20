//
//  LoginViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/20.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import Spring

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var loginBtn: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signUpViewController!, animated: true, completion: nil)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        loginBtn.animation = "pop"
        loginBtn.curve = "easeIn"
        loginBtn.force = 2.0
        loginBtn.duration = 0.5
        loginBtn.damping = 1.0
        loginBtn.velocity = 1.0
        loginBtn.animate()
        
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_, error) in
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

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
