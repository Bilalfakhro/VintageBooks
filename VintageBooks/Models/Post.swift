//
//  Post.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-11-30.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import Foundation
class Post {
    var caption: String
    var photoUrl: String
    var bookTitle: String
    
    init(captionText: String, photoUrlString: String, bookTitleString: String) {
        caption = captionText
        photoUrl = photoUrlString
        bookTitle = bookTitleString
    }
}
