
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
    
    var message = [Message]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        
        observeMessages()
        navigationItem.title = toName
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setUpInputComponents()
        

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        // swiftlint:disable:previous force_cast
        
        cell.backgroundColor = .yellow
        let message = self.message[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    

    
//    func observeMessages() {
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
//        let userMessagesRef = FIRDatabase.database().reference().child("user-messsages").child(uid)
//        
//        userMessagesRef.observe(.childAdded, with: { (snapshot) in
//            
//            let messageID = snapshot.key
//            print (messageID)
//            let messagesRef = FIRDatabase.database().reference().child("message").child(messageID)
//            
//            
//            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                guard let dictionary = snapshot.value as? [String: Any] else { return }
//                
//                print ("LOL \(dictionary)")
//                
//                let message = Message()
//                message.setValuesForKeys(dictionary)
//                
//                if message.chatPartnerId() == self.toID {
//                    self.message.append(message)
//                    DispatchQueue.main.async(execute: {
//                        self.collectionView?.reloadData()
//                    })
//                }
//                
//                
//            })
//            
//        }, withCancel: nil)
//        
//    }
    
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            print (messageId)
            let messagesRef = FIRDatabase.database().reference().child("message").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                let message = Message()
                // Potential of crashing if keys don't match
                
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerId() == self.toID {
                    self.message.append(message)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
            }, withCancel: nil)
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
    
    

    
}
