//
//  BooksDetailViewController.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-12-07.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class BooksDetailViewController: UIViewController {

    @IBOutlet weak var booksTitleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var booksTextfield: UITextView!
    
    var posts = [Post]()
    
    var bookTitleString = ""
    var captionText = ""
    var bookImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksTitleLabel.text = bookTitleString
        booksTextfield.text = captionText
        bookImageView.image = bookImage
    
    
    }

}
