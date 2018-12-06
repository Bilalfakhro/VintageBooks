//
//  User.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-12-05.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["Name"] as? String
        self.email = dictionary["Email"] as? String
        self.profileImageUrl = dictionary["Profile_Image_Url"] as? String
    }
}
