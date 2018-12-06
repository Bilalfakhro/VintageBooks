//
//  ProfileViewController.swift
//  VintageBook
//
//  Created by Bilal Fakhro on 2018-11-26.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let profileCellID = "profileCellID"
    var posts = [Post]()
    var users = [User]()
    
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // REGISTER THE CLASS FOR THE CELL
        myTableView.register(myPostCell.self, forCellReuseIdentifier: profileCellID)
        
        fetchMyPost()
    }
    
    // DOWNLOAD THE DATA FROM FIREBASE DATABASE
    func fetchMyPost() {
    Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["Book_Text"] as! String
                let bookTitleString = dict["Book_Title"] as! String
                
                let photoUrlString = dict["Book_Photo_Url"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString, bookTitleString: bookTitleString)
                self.posts.append(post)
                DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                })
            }
        }
    }
    
    // HOW MANY ROWS IS NEEDED IN THE TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCellID, for: indexPath) as! myPostCell
        
        let posten = posts[indexPath.row]
        cell.textLabel?.text = posts[indexPath.row].bookTitle
        cell.detailTextLabel?.text = posts[indexPath.row].caption
//
//        // CREATE A STORAGE REFERENCE FROM FIREBASE STORAGE SERVICE
//        let storage = Storage.storage()
//        let imageRef = storage.reference(forURL: posten.photoUrl)
        
//        // DOWNLOAD IN MEMORY WITH A MAXIMUM ALLOWED SIZE OF 1MB (1 * 1024 * 1024 BYTES)
//        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            let photoUrl = posten.photoUrl
            if photoUrl != nil {
            cell.bookImageView.loadImageUsingCacheWithUrlString(photoUrl)
            } 
//        }
        return cell
    }
    
    // CELL ROW HEIGHT
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    @IBAction func infoButton(_ sender: Any) {
        performSegue(withIdentifier: "profileToInfoSegue", sender: self)
    }
}

// CLASS FOR THE CELL FOR THE POSTLABELS
class myPostCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TEXTLABEL & DETAILLABEL CONSTRAINT AND MARGIN
        textLabel?.frame = CGRect(x: 72, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 72, y: detailTextLabel!.frame.origin.y + 2, width: 320, height: detailTextLabel!.frame.height)
    }
    // IMAGEVIEW LAYOUTS, RADIUS & CONSTRAINS
    let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 27
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
        
        // WIDTH & HEIGHT FOR THE IMAGEVIEW.IMAGE
        bookImageView.widthAnchor.constraint(equalToConstant: 54).isActive = true
        bookImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
