//
//  MessagesController.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-12-10.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    let cellId = "cellId"
    var posts = [Post]()
    var users = [User]()
    
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // REGISTER THE CLASS FOR THE CELL
        tableView.register(UsersCell .self, forCellReuseIdentifier: cellId)
        
        observeMessages()
    }

    var messages = [Message]()
    
    func observeMessages() {
        let ref = Database.database().reference()
        ref.child("Messages").childByAutoId().observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)

                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                print(dictionary)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UsersCell
        
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.text
        return cell
    }
}

//---------------------------------------------//
// CLASS FOR THE CELL FOR THE POSTLABELS
class UsersCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TEXTLABEL & DETAILLABEL CONSTRAINT AND MARGIN
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y + 2, width: 320, height: detailTextLabel!.frame.height)
    }
    // IMAGEVIEW LAYOUTS AND CONSTRAINS
    let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(bookImageView)
        
        // BOOKIMAGE CONSTRIANT
        bookImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        bookImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // WIDTH AND HEIGHT FOR THE IMAGEVIEW.IMAGE
        bookImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        bookImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


