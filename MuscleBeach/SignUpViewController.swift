//
//  SignUpViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/20.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var numberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardObservers()
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
        if let email = emailTextField.text, let password = passwordTextField.text {

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
    }
    func completeSignIn(id: String, userData: [String: String], email: [String: String], password: [String: String], name: [String: String], number: [String: String]) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData, email: email, password: password, name: name, number: number)
    }

    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue

        view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardFrame!.height).isActive = true
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(notification: NSNotification) {

        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }

}
