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
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?

    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
