//
//  Post.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-11-30.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit

class Post: NSObject {
    var bookText: String?
    var bookTitle: String?
    var bookPhotoUrl: String?
    
    init(Dictionary: [String: Any]) {
        self.bookText = Dictionary["Book_Text"] as? String
        self.bookTitle = Dictionary["Book_Title"] as? String
        self.bookPhotoUrl = Dictionary["Book_Photo_Url"] as? String
//        bookText = bookTextString
//        photoUrl = photoUrlString
//        bookTitle = bookTitleString
    }
}
