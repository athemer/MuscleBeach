
//
//  ChatRoomViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/6.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var toID: String = ""
    var toName: String = ""
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "請輸入訊息"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    } ()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        navigationItem.title = toName
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setUpInputComponents()
        

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .yellow
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    
    var message = [Message]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messsages").child(uid)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("message").child(messageID)
            
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                print ("LOL \(dictionary)")
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if self.toID == uid {
                    self.message.append(message)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
                
                
            })
            
        }, withCancel: nil)
        
    }
    
    func setUpInputComponents () {
        
        // containerView
        let containerView = UIView()
        containerView.backgroundColor = .yellow
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
        
        let value: [String: Any] = ["text": inputTextField.text!, "toID": toID, "fromID": fromID!, "timeStamp": timeStamp]
        childRef.updateChildValues(value)
        
        let messageID = childRef.key
        
        FIRDatabase.database().reference().child("user-messages").child(fromID!).updateChildValues([messageID: true])
        
        let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toID)
        recipientUserMessagesRef.updateChildValues([messageID: true])
        
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
