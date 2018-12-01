//
//  AddViewController.swift
//  VintageBook
//
//  Created by Bilal Fakhro on 2018-11-26.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    var selectedPhoto: UIImage?
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedPhoto != nil {
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        // FIREBASE DATABASE
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Book_Photo").child(userID!).child("\(imageName).jpeg")
        if let uploadData = selectedPhoto?.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                if let error = err {
                    print(error)
                    return
                }
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    guard let url = url else { return }
                    self.bookTitle.text = "" as String
                    self.ref?.child("Users").child(self.userID!).child("Posts").childByAutoId().child("Book_Title").setValue(self.bookTitle.text)
                })
            })
            self.clean()
        }
    }

    @IBAction func remove_TouchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }
    
//    func sendDataToDatabase(photoUrl: String, caption: String, bookTitel: String) {
//        let ref = Database.database().reference()
//        let postsReference = ref.child("Users").child(userID!).child("Posts")
//        let newPostId = postsReference.childByAutoId().key
//        let newPostReference = postsReference.child(newPostId!)
//        newPostReference.setValue(["Book_Photo_Url": photoUrl, "Book_Text": captionTextView.text!, "Book_Titel": bookTextfield.text!], withCompletionBlock: {
//            (error, ref) in
//            if error != nil {
//                print(error!.localizedDescription)
//                return
//            }
//            print("Success")
//            self.clean()
//            self.tabBarController?.selectedIndex = 0
//        })
//    }

    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "placeholder-photo")
        self.bookTitle.text = ""
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedPhoto = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
