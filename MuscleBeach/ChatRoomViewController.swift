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
    var url: String = ""

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
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)

        observeMessages()
        navigationItem.title = toName
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)

        collectionView?.keyboardDismissMode = .interactive

        setUpInputComponents()
        setUpKeyboardObservers()

        // Do any additional setup after loading the view.
    }

    //needtobedone

//    func scroll() {
//        let index = IndexPath(item: message.count - 1, section: 0)
//        print ("??", message.count)
//        self.collectionView?.scrollToItem(at: index, at: .bottom, animated: true)
//    }

//    lazy var inputContainerView: UIView = {
//        let containerView = UIView()
//        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        containerView.backgroundColor = .white
//        
//        
////        let textField = UITextField()
////        textField.placeholder = "請輸入訊息"
////        containerView.addSubview(textField)
////        textField.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        
//        
//        //Send Button
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        containerView.addSubview(sendButton)
//        
//        //x y w h
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        
//        
//        containerView.addSubview(self.inputTextField)
//        
//        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        
//        let line = UIView()
//        line.backgroundColor = UIColor.black
//        line.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(line)
//        
//        line.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        line.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        line.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        let lineToSeperate = UIView()
//        lineToSeperate.backgroundColor = UIColor.black
//        lineToSeperate.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(lineToSeperate)
//        
//        lineToSeperate.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        lineToSeperate.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        lineToSeperate.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        lineToSeperate.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        
//        return containerView
//    }()

//    override var inputAccessoryView: UIView? {
//        get {
//            return inputContainerView
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        // swiftlint:disable:previous force_cast
        let message = self.message[indexPath.item]

        setupCell(cell: cell, message: message)

        // to be deleted
        cell.backgroundColor = .white
        cell.textView.text = message.text

        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32

        return cell
    }

    private func setupCell(cell: ChatMessageCell, message: Message) {

//        if let profileImageUrl = self.user.profileImageUrl {
//            cell.profileImageView.
//        }

        if message.fromID == FIRAuth.auth()?.currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
            cell.textView.textColor = .white

            cell.profileImageView.isHidden = true

            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = .black

            cell.profileImageView.isHidden = false

            // do url

            let url = URL(string: self.url)
            //needtobedone
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in

                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async(execute: {

                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: self.url as AnyObject)
                        cell.profileImageView.image = downloadedImage
                    }
                })
            }).resume()

            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat = 80

        if let text = message[indexPath.item].text {
            height = estimatedFrameForText(text: text).height + 20
        }

        return CGSize(width: view.frame.width, height: height)
    }

    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toID)
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

                    self.message.append(message)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
//                        self.scroll()
                    })

            }, withCancel: nil)
        }, withCancel: nil)
    }

    var containerViewBottomAnchor: NSLayoutConstraint?

    func setUpInputComponents () {

        // containerView
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        //x y w h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        containerViewBottomAnchor?.isActive = true

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

        self.inputTextField.text = nil

        let messageID = childRef.key

        FIRDatabase.database().reference().child("user-messages").child(fromID!).child(toID).updateChildValues([messageID: true])

        let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toID).child(fromID!)

        recipientUserMessagesRef.updateChildValues([messageID: true])

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
       collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300).isActive = true

        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
            DispatchQueue.main.async(execute: {
//                self.scroll()
            })
        }
    }

    func keyboardWillHide(notification: NSNotification) {

        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant =  -50
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
}
