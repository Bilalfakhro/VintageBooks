//
//  Message.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-12-10.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
}
