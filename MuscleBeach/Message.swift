//
//  Message.swift
//  NewMessenger
//
//  Created by Farukh IQBAL on 21/03/2017.
//  Copyright © 2017 Farukh. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromID: String?
    var text: String?
    var timeStamp: NSNumber?
    var toID: String?

    func chatPartnerId() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
}
