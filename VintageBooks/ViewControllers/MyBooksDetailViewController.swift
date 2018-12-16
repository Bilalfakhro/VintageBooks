//
//  MyBooksDetailViewController.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-12-09.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class MyBooksDetailViewController: UIViewController {
    
    @IBOutlet weak var booksTitleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var booksTextfield: UITextView!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var posts = [Post]()
    
    var users = [User]()
    
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    
    var bookTitleString = ""
    var bookText = ""
    var bookImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksTitleLabel.text = bookTitleString
        booksTextfield.text = bookText
        bookImageView.image = bookImage
    }
    
    @IBAction func updateButton_Tapped(_ sender: Any) {
        print(1234)
    }
    @IBAction func cancelButton_Tapped(_ sender: Any) {
        print(5678)
    }
    
}
