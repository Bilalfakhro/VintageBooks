//
//  HomeTableViewController.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-12-03.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController {

    let homeCellID = "homeCellID"
    var posts = [Post]()
    var users = [User]()
    
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        // REGISTER THE CLASS FOR THE CELL
        tableView.register(postCell.self, forCellReuseIdentifier: homeCellID)
        
        fetchPost()
        checkIfUserIsLoggedIn()
    }
    
    // DOWNLOAD THE DATA FROM FIREBASE DATABASE
    func fetchPost() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded) { (snapshot) in
            if let Dictionary = snapshot.value as? [String: Any] {
                let post = Post(Dictionary: Dictionary)
                self.posts.append(post)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
//                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    // HOW MANY ROWS IS NEEDED IN THE TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellID, for: indexPath) as! postCell
        let posten = posts[indexPath.row]
        cell.textLabel?.text = posts[indexPath.row].bookTitle
        cell.detailTextLabel?.text = posts[indexPath.row].bookText
        
        if let bookPhotoUrl = posten.bookPhotoUrl {
            cell.bookImageView.loadImageUsingCacheWithUrlString(bookPhotoUrl)
            }
        return cell
    }
     
    // CELL ROW HEIGHT
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let booksDetailView = storyboard?.instantiateViewController(withIdentifier: "BooksDetailViewController") as? BooksDetailViewController
        
        let postens = posts[indexPath.row]
        booksDetailView?.bookTitleString = posts[indexPath.row].bookTitle!
        booksDetailView?.bookText = posts[indexPath.row].bookText!
        
        let bookImageView = UIImageView()
        if let booksPhotoUrl = postens.bookPhotoUrl {
           bookImageView.loadImageUsingCacheWithUrlString(booksPhotoUrl)
        }
        booksDetailView?.bookImage = bookImageView.image!
        
        let user = self.users[indexPath.row]
        booksDetailView?.navigationItem.title = user.name
        
        self.navigationController?.pushViewController(booksDetailView!, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let sigInController = SignInViewController()
//        sigInController.messagesController = self
        present(sigInController, animated: true, completion: nil)
    }
}

//---------------------------------------------//
// CLASS FOR THE CELL FOR THE POSTLABELS
class postCell: UITableViewCell {
    
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

