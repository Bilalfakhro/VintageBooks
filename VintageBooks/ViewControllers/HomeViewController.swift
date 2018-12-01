//
//  HomeViewController.swift
//  VintageBook
//
//  Created by Bilal Fakhro on 2018-11-26.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
 
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["Book_Text"] as! String
                let photoUrlString = dict["Book_Photo_Url"] as! String
                let bookTitel = dict["Book_Titel"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString, bookTitelString: bookTitel)
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: false, completion: nil)
    }
}

