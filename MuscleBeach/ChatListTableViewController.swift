//
//  ChatListTableViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/7.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip
import FirebaseStorage

class ChatListTableViewController: UITableViewController, IndicatorInfoProvider {

    var messages = [Message]()
    var messagesDictionary = [String: Message]()

    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        messages.removeAll()
        messagesDictionary.removeAll()

        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

//        observeMessages()
        observeUserMessages()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        // swiftlint:disable:previous force_cast

        let message = messages[indexPath.row]
        cell.message = message
        
//        cell.image.contentmode = .scallaspectfit 
//        if let profileImageUrl = user.profileImageUrl {
//            let url = URL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print (error)
//                    return
//                }
//                DispatchQueue.main.async(execute: {
//                    
//                    if let downloadedImage = UIImage(data: data!) {
//                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
//                        self.image = downloadedImage
//                    }
//                })
//            }).resume()
//            
//        }
//        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]

        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }

        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard
                let dictionary = snapshot.value as? [String: Any]
                else { return }

            print ("MEWO", dictionary)

            let user = User()

            guard let userName = dictionary["name"] as? String else { return }

            user.id = chatPartnerId
//            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(userId: chatPartnerId, userName: userName)

        }, withCancel: nil)
    }

    func observeUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }

        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in

            let userId = snapshot.key

            FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in

                let messageId = snapshot.key
                let messagesReference = FIRDatabase.database().reference().child("message").child(messageId)

                messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let message = Message()
                        message.setValuesForKeys(dictionary)

                        if let chatPartnerId = message.chatPartnerId() {
                            self.messagesDictionary[chatPartnerId] = message

                            self.messages = Array(self.messagesDictionary.values)
                            self.messages.sort(by: { (message1, message2) -> Bool in
                                return message1.timeStamp!.intValue > message2.timeStamp!.intValue
                            })
                        }
                        // this will crash because of background thread, so lets call this on dispatch_async main thread
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }, withCancel: nil)

            })

        }, withCancel: nil)
    }

//    func observeMessages() {
//        let ref = FIRDatabase.database().reference().child("message")
//        ref.observe(.childAdded, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: Any] {
//                let message = Message()
//                message.setValuesForKeys(dictionary)
//                
//                if let toId = message.toID {
//                    self.messagesDictionary[toId] = message
//                    
//                    self.messages = Array(self.messagesDictionary.values)
//                    self.messages.sort(by: { (message1, message2) -> Bool in
//                        return message1.timeStamp!.intValue > message2.timeStamp!.intValue
//                    })
//                }
//                
//                // this will crash because of background thread, so lets call this on dispatch_async main thread
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }, withCancel: nil)
//    }

    func showChatControllerForUser(userId: String, userName: String) {
        let chatRoomViewController = ChatRoomViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        ChatRoomViewController.user = user
        chatRoomViewController.toID = userId
        chatRoomViewController.toName = userName
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    func indicatorInfo(for pagerTablStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "聊天室")
    }

    
}

