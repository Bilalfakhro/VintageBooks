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

    var bookTitleString = ""
    var bookText = ""
    var bookImage = UIImage()
    
    var users = [User]()
    
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksTitleLabel.text = bookTitleString
        booksTextfield.text = bookText
        bookImageView.image = bookImage
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showChatController))
    }
    
    @objc func showChatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
//       newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let SignInController = SignInViewController()
        present(SignInController, animated: true, completion: nil)
    }
}
