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
//    var bookTitel: String
    
    init(captionText: String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
 //       bookTitel = bookTitelString
    }
}
