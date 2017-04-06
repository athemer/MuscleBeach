
//
//  ChatRoomViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/6.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UICollectionViewController, UITextFieldDelegate {
    
    var toID: String = ""
    var toName: String = ""
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "請輸入訊息"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = toName
        collectionView?.backgroundColor = UIColor.white
        setUpInputComponents()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpInputComponents () {
        
        // containerView
        let containerView = UIView()
        containerView.backgroundColor = UIColor.yellow
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        
        //x y w h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Send Button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x y w h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        let line = UIView()
        line.backgroundColor = UIColor.black
        line.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(line)
        
        line.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        let checkButton = UIButton()
        checkButton.setTitle("CHECK", for: .normal)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(check), for: .touchUpInside)
        checkButton.backgroundColor = UIColor.black
        view.addSubview(checkButton)
        
        checkButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -100).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant:  100).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    func handleSend() {
        
        let ref = FIRDatabase.database().reference().child("message")
        let childRef = ref.childByAutoId()
        
        let fromID = FIRAuth.auth()?.currentUser?.uid
        let toID = self.toID
        let timeStamp = Date().timeIntervalSince1970
        
        let value: [String: Any] = ["text": inputTextField.text!, "toID": toID, "formID": fromID!, "timeStamp": timeStamp]
        childRef.updateChildValues(value)
        
        let messageID = childRef.key
        
        FIRDatabase.database().reference().child("user-messages").child(fromID!).updateChildValues([messageID: true])
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    
    func check() {
        let vc = ChatListTableViewController(style: .plain)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
