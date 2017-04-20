//
//  SignUpViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/20.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import Spring


class SignUpViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var numberTextField: UITextField!

    @IBOutlet weak var singUpBtn: SpringButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpKeyboardObservers()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func signInButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func userSignUpButtonTapped(_ sender: Any) {
        
        
        
        activityIndicator("帳號登入中")
        
        let when = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let email = self.emailTextField.text, let password = self.passwordTextField.text {
                
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        let alertController = UIAlertController(title: "錯誤", message: "email已被註冊", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "重試", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        print(error)
                        print("Unable to authenticate with Firebase using email")
                    } else {
                        print("Successfully authenticated with Firebase")
                        if let user = user {
                            let id = FIRAuth.auth()!.currentUser!.uid
                            let userData = ["provider": user.providerID]
                            let email = ["email": self.emailTextField.text!]
                            let password = ["password": self.passwordTextField.text!]
                            let name = ["name": self.nameTextField.text!]
                            let number = ["number": self.numberTextField.text!]
                            self.completeSignIn(id: id, userData: userData, email: email, password: password, name: name, number: number)
                            let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                            self.present(signUpViewController!, animated: true, completion: nil)
                            
                        }
                    }
                })
            }

            DispatchQueue.main.async {
                self.effectView.removeFromSuperview()
                
            }
        }

        
        
            }
    func completeSignIn(id: String, userData: [String: String], email: [String: String], password: [String: String], name: [String: String], number: [String: String]) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData, email: email, password: password, name: name, number: number)
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
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        backgroundView.addSubview(effectView)
    }


}
