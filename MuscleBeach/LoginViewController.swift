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

    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

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

        activityIndicator("帳號登入中")

        let when = DispatchTime.now() + 1

        DispatchQueue.main.asyncAfter(deadline: when) {
            if let email = self.emailTextField.text, let password = self.passwordTextField.text {
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
            DispatchQueue.main.async {
                self.effectView.removeFromSuperview()

            }
        }

//        DispatchQueue.main.asyncAfter(deadline: when)

//        if let email = emailTextField.text, let password = passwordTextField.text {
//            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_, error) in
//                
//                if error == nil {
//                    print("Email user authenticated with Firebase")
//                        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
//                        self.present(signUpViewController!, animated: true, completion: nil)
//                } else {
//                    let alertController = UIAlertController(title: "錯誤", message: "帳號不存在或密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
//                    alertController.addAction(UIAlertAction(title: "重試", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            })
//
//        }
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

    func activityIndicator(_ title: String) {

        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()

        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2, width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()

        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        backgroundView.addSubview(effectView)
    }
    
    
    @IBAction func loginAsGuest(_ sender: Any) {
        
        activityIndicator("訪客登入中")
        
        let when = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
                FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                    
                    if error == nil {
                        
                        print("user signInAnonymously with Firebase")
                        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(signUpViewController!, animated: true, completion: nil)
                    } else {
                        
                        print ("check error", error)
                        
                        let alertController = UIAlertController(title: "錯誤", message: "帳號不存在或密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "重試", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                })

            DispatchQueue.main.async {
                self.effectView.removeFromSuperview()
                
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
